import SwiftUI

struct EditorView: View {
    @StateObject var viewModel: EditorViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var imageScale: CGFloat = 1
    @State private var lastImageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var lastImageOffset: CGSize = .zero

    var body: some View {
        TabView(selection: $viewModel.selectedTool) {
            ForEach(EditorTool.allCases) { tool in
                ZStack {
                    ThemeBackground()
                    VStack(spacing: 0) {
                        header
                        editorImageLayer
                    }
                }
                .tag(tool)
                .tabItem {
                    Label(tool.rawValue, systemImage: tool.iconName)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .tint(.white)
        .alert("Editor Status", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var editorImageLayer: some View {
        GeometryReader { geometry in
            let viewportSize = geometry.size
            let baseImageSize = fittedImageSize(in: viewportSize)

            ZStack {
                Image(uiImage: viewModel.editorImage.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: viewportSize.width, height: viewportSize.height)
                    .scaleEffect(imageScale)
                    .offset(imageOffset)
                    .gesture(imageInteractionGesture(baseImageSize: baseImageSize, viewportSize: viewportSize))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func imageInteractionGesture(baseImageSize: CGSize, viewportSize: CGSize) -> some Gesture {
        imageMagnificationGesture(baseImageSize: baseImageSize, viewportSize: viewportSize)
            .simultaneously(with: imageDragGesture(baseImageSize: baseImageSize, viewportSize: viewportSize))
    }

    private func imageMagnificationGesture(baseImageSize: CGSize, viewportSize: CGSize) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let nextScale = lastImageScale * value.magnification
                imageScale = min(max(nextScale, 1), 4)
                imageOffset = clampedOffset(
                    imageOffset,
                    baseImageSize: baseImageSize,
                    viewportSize: viewportSize,
                    scale: imageScale
                )
            }
            .onEnded { _ in
                lastImageScale = imageScale
                imageOffset = clampedOffset(
                    imageOffset,
                    baseImageSize: baseImageSize,
                    viewportSize: viewportSize,
                    scale: imageScale
                )
                lastImageOffset = imageOffset
            }
    }

    private func imageDragGesture(baseImageSize: CGSize, viewportSize: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let proposedOffset = CGSize(
                    width: lastImageOffset.width + value.translation.width,
                    height: lastImageOffset.height + value.translation.height
                )
                imageOffset = clampedOffset(
                    proposedOffset,
                    baseImageSize: baseImageSize,
                    viewportSize: viewportSize,
                    scale: imageScale
                )
            }
            .onEnded { _ in
                imageOffset = clampedOffset(
                    imageOffset,
                    baseImageSize: baseImageSize,
                    viewportSize: viewportSize,
                    scale: imageScale
                )
                lastImageOffset = imageOffset
            }
    }

    private func fittedImageSize(in viewportSize: CGSize) -> CGSize {
        let imageSize = viewModel.editorImage.image.size
        guard imageSize.width > 0, imageSize.height > 0 else {
            return viewportSize
        }

        let imageAspectRatio = imageSize.width / imageSize.height
        let viewportAspectRatio = viewportSize.width / viewportSize.height

        if imageAspectRatio > viewportAspectRatio {
            return CGSize(width: viewportSize.width, height: viewportSize.width / imageAspectRatio)
        } else {
            return CGSize(width: viewportSize.height * imageAspectRatio, height: viewportSize.height)
        }
    }

    private func clampedOffset(
        _ proposedOffset: CGSize,
        baseImageSize: CGSize,
        viewportSize: CGSize,
        scale: CGFloat
    ) -> CGSize {
        guard scale > 1 else {
            return .zero
        }

        let scaledWidth = baseImageSize.width * scale
        let scaledHeight = baseImageSize.height * scale
        let horizontalLimit = max((scaledWidth - viewportSize.width) / 2, 0)
        let verticalLimit = max((scaledHeight - viewportSize.height) / 2, 0)

        return CGSize(
            width: min(max(proposedOffset.width, -horizontalLimit), horizontalLimit),
            height: min(max(proposedOffset.height, -verticalLimit), verticalLimit)
        )
    }

    private var header: some View {
        HStack {
            IconButton(systemImage: "chevron.left") {
                dismiss()
            }
            Spacer()
            Text(viewModel.title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white)
            Spacer()
            IconButton(systemImage: "square.and.arrow.up") {}
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 8)
    }

    private var controls: some View {
        VStack(spacing: 18) {
            Button {
                viewModel.compareModeEnabled.toggle()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    Text("Hold to Compare")
                }
                .font(AppTheme.Typography.micro)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                }
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

        }
        .padding(.top, 14)
        .padding(.bottom, 8)
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(
            viewModel: EditorViewModel(
                editorImage: EditorImage(title: "City Portrait", image: UIImage(systemName: "person.crop.square") ?? UIImage()),
                aiService: StubGenerativeAIService()
            )
        )
    }
}
