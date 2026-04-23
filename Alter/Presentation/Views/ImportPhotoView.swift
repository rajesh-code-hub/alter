import Photos
import SwiftUI
import UIKit

struct ImportPhotoView: View {
    @StateObject var viewModel: ImportPhotoViewModel
    @Environment(\.openURL) private var openURL
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage?
    let onBack: () -> Void
    let onImport: (EditorImage?) -> Void

    private let recentPhotoTileSize: CGFloat = 104
    private let gridSpacing: CGFloat = 8
    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(recentPhotoTileSize), spacing: gridSpacing), count: 3)
    }

    var body: some View {
        ZStack {
            ThemeBackground()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        tabSelector
                        sectionTitle
                        content
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .fullScreenCover(isPresented: $isCameraPresented) {
            CameraCaptureView(
                onCapture: { image in
                    capturedImage = image
                    isCameraPresented = false
                },
                onCancel: {
                    isCameraPresented = false
                }
            )
            .ignoresSafeArea()
        }
        .onChange(of: capturedImage) { _, newValue in
            guard let image = newValue else { return }
            onImport(EditorImage(title: "Camera Photo", image: image))
            capturedImage = nil
        }
        .alert("Photo Access", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            Button(action: {
                if viewModel.selectedAlbum != nil {
                    viewModel.closeAlbum()
                } else {
                    onBack()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.08))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.selectedAlbum?.title ?? "Import Photo")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white)

            Spacer()

            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }

    private var tabSelector: some View {
        HStack(spacing: 8) {
            ForEach(PhotoSourceTab.allCases) { tab in
                Button {
                    viewModel.selectTab(tab)
                } label: {
                    Text(tab.rawValue)
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(viewModel.selectedTab == tab ? .white : AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(viewModel.selectedTab == tab ? .white.opacity(0.08) : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.Colors.border, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var sectionTitle: some View {
        Text(viewModel.currentSectionTitle)
            .font(AppTheme.Typography.headline)
            .foregroundStyle(.white)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.authorizationStatus != .authorized && viewModel.authorizationStatus != .limited && !viewModel.isLoading {
            EmptyStateView(
                title: "Allow Photo Access",
                message: "Enable photo library permission in Settings to browse recent images, albums, and favorites.",
                systemImage: "photo.on.rectangle.angled",
                buttonTitle: "Open Settings",
                action: openAppSettings
            )
        } else if viewModel.selectedTab == .albums && viewModel.selectedAlbum == nil {
            if viewModel.albums.isEmpty {
                EmptyStateView(
                    title: "No Albums Found",
                    message: "Your photo library does not currently contain any albums with images.",
                    systemImage: "rectangle.stack",
                    buttonTitle: nil,
                    action: nil
                )
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.albums) { album in
                        AlbumTile(album: album, coverProvider: viewModel.loadThumbnail) {
                            Task { await viewModel.openAlbum(album) }
                        }
                    }
                }
            }
        } else {
            if shouldShowAssetGrid {
                assetGrid
            } else {
                EmptyStateView(
                    title: emptyStateTitle,
                    message: emptyStateMessage,
                    systemImage: emptyStateIcon,
                    buttonTitle: nil,
                    action: nil
                )
            }
        }
    }
}

private extension ImportPhotoView {
    var shouldShowAssetGrid: Bool {
        isShowingRecentGrid || !(viewModel.visibleAssets.isEmpty && viewModel.isInitialLoadComplete)
    }

    var isShowingRecentGrid: Bool {
        viewModel.selectedTab == .recent && viewModel.selectedAlbum == nil
    }

    @ViewBuilder
    var assetGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: gridSpacing) {
            if isShowingRecentGrid {
                CameraTile(size: recentPhotoTileSize, action: openCamera)
            }

            ForEach(viewModel.visibleAssets) { asset in
                LibraryPhotoTile(
                    asset: asset,
                    thumbnailProvider: viewModel.loadThumbnail,
                    tileSize: recentPhotoTileSize
                ) {
                    Task {
                        let editorImage = await viewModel.makeEditorImage(from: asset)
                        onImport(editorImage)
                    }
                }
            }

            if viewModel.visibleAssets.isEmpty && !viewModel.isInitialLoadComplete {
                ForEach(0..<12, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.05))
                        .frame(width: recentPhotoTileSize, height: recentPhotoTileSize)
                        .overlay {
                            ProgressView()
                                .tint(.white.opacity(0.7))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppTheme.Colors.border, lineWidth: 1)
                        }
                }
            }
        }
    }

    var emptyStateTitle: String {
        if viewModel.selectedAlbum != nil {
            return "No Photos In Album"
        }

        switch viewModel.selectedTab {
        case .recent:
            return "No Recent Photos"
        case .albums:
            return "No Albums Found"
        case .favorites:
            return "No Favorite Photos"
        }
    }

    var emptyStateMessage: String {
        if viewModel.selectedAlbum != nil {
            return "This album does not contain any importable photos."
        }

        switch viewModel.selectedTab {
        case .recent:
            return "There are no recent photos available to import."
        case .albums:
            return "Create albums in Photos and they will appear here."
        case .favorites:
            return "Mark photos as favorites in the Photos app to see them here."
        }
    }

    var emptyStateIcon: String {
        if viewModel.selectedAlbum != nil {
            return "photo.stack"
        }

        switch viewModel.selectedTab {
        case .recent:
            return "clock.arrow.circlepath"
        case .albums:
            return "rectangle.stack"
        case .favorites:
            return "heart"
        }
    }

    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            viewModel.errorMessage = "Camera is not available on this device."
            return
        }

        isCameraPresented = true
    }
}

struct ImportPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ImportPhotoView(
            viewModel: ImportPhotoViewModel(photoLibraryService: MockPhotoLibraryService()),
            onBack: {},
            onImport: { _ in }
        )
    }
}

private struct MockPhotoLibraryService: PhotoLibraryService {
    func requestAuthorization() async -> PHAuthorizationStatus { .authorized }
    func fetchRecentAssets() async -> [ImportedPhotoAsset] { [] }
    func fetchFavoriteAssets() async -> [ImportedPhotoAsset] { [] }
    func fetchAlbums() async -> [PhotoAlbum] { [] }
    func fetchAssets(in album: PhotoAlbum) async -> [ImportedPhotoAsset] { [] }
    func requestImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage? { nil }
}

private struct CameraTile: View {
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(AppTheme.Colors.secondaryText)

                Text("Camera")
                    .font(AppTheme.Typography.micro)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }
            .frame(width: size, height: size)
            .background(.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.Colors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct CameraCaptureView: UIViewControllerRepresentable {
    let onCapture: (UIImage) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCapture: onCapture, onCancel: onCancel)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let onCapture: (UIImage) -> Void
        private let onCancel: () -> Void

        init(onCapture: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onCapture = onCapture
            self.onCancel = onCancel
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            guard let image = info[.originalImage] as? UIImage else {
                onCancel()
                return
            }

            onCapture(image)
        }
    }
}
