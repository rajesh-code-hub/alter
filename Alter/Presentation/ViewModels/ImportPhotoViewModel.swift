import Combine
import Photos
import UIKit

@MainActor
final class ImportPhotoViewModel: ObservableObject {
    @Published var selectedTab: PhotoSourceTab = .recent
    @Published var selectedAlbum: PhotoAlbum?
    @Published private(set) var recentAssets: [ImportedPhotoAsset] = []
    @Published private(set) var favoriteAssets: [ImportedPhotoAsset] = []
    @Published private(set) var albums: [PhotoAlbum] = []
    @Published private(set) var albumAssets: [ImportedPhotoAsset] = []
    @Published private(set) var authorizationStatus: PHAuthorizationStatus = .notDetermined
    @Published private(set) var isLoading = false
    @Published private(set) var isInitialLoadComplete = false
    @Published var errorMessage: String?

    private let photoLibraryService: PhotoLibraryService

    init(photoLibraryService: PhotoLibraryService = SystemPhotoLibraryService()) {
        self.photoLibraryService = photoLibraryService
    }

    var currentSectionTitle: String {
        if let selectedAlbum {
            return selectedAlbum.title
        }

        switch selectedTab {
        case .recent:
            return "Recent Photos"
        case .albums:
            return "Albums"
        case .favorites:
            return "Favorite Photos"
        }
    }

    var visibleAssets: [ImportedPhotoAsset] {
        if selectedAlbum != nil {
            return albumAssets
        }

        switch selectedTab {
        case .recent:
            return recentAssets
        case .albums:
            return []
        case .favorites:
            return favoriteAssets
        }
    }

    func loadIfNeeded() async {
        guard recentAssets.isEmpty, favoriteAssets.isEmpty, albums.isEmpty else { return }
        await requestAccessAndLoad()
    }

    func requestAccessAndLoad() async {
        isLoading = true
        isInitialLoadComplete = false
        errorMessage = nil

        let status = await photoLibraryService.requestAuthorization()
        authorizationStatus = status

        guard status == .authorized || status == .limited else {
            isLoading = false
            isInitialLoadComplete = true
            errorMessage = "Photo library access is required to import images."
            return
        }

        isLoading = false

        async let recent = photoLibraryService.fetchRecentAssets()
        async let favorites = photoLibraryService.fetchFavoriteAssets()
        async let albums = photoLibraryService.fetchAlbums()

        recentAssets = await recent
        favoriteAssets = await favorites
        self.albums = await albums
        isInitialLoadComplete = true
    }

    func selectTab(_ tab: PhotoSourceTab) {
        selectedTab = tab
        selectedAlbum = nil
        albumAssets = []
    }

    func openAlbum(_ album: PhotoAlbum) async {
        selectedAlbum = album
        isLoading = true
        albumAssets = await photoLibraryService.fetchAssets(in: album)
        isLoading = false
    }

    func closeAlbum() {
        selectedAlbum = nil
        albumAssets = []
    }

    func loadThumbnail(for asset: PHAsset, targetSize: CGSize) async -> UIImage? {
        await photoLibraryService.requestImage(for: asset, targetSize: targetSize)
    }

    func makeEditorImage(from asset: ImportedPhotoAsset) async -> EditorImage? {
        guard let image = await photoLibraryService.requestImage(
            for: asset.asset,
            targetSize: CGSize(width: 1600, height: 1600)
        ) else {
            errorMessage = "Unable to load the selected photo."
            return nil
        }

        return EditorImage(title: asset.title, image: image)
    }
}
