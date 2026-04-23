import Photos
import UIKit

protocol PhotoLibraryService {
    func requestAuthorization() async -> PHAuthorizationStatus
    func fetchRecentAssets() async -> [ImportedPhotoAsset]
    func fetchFavoriteAssets() async -> [ImportedPhotoAsset]
    func fetchAlbums() async -> [PhotoAlbum]
    func fetchAssets(in album: PhotoAlbum) async -> [ImportedPhotoAsset]
    func requestImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage?
}

struct SystemPhotoLibraryService: PhotoLibraryService {
    func requestAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
    }

    func fetchRecentAssets() async -> [ImportedPhotoAsset] {
        await fetchAssets {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            return PHAsset.fetchAssets(with: options)
        }
    }

    func fetchFavoriteAssets() async -> [ImportedPhotoAsset] {
        await fetchAssets {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            options.predicate = NSPredicate(format: "mediaType == %d AND favorite == YES", PHAssetMediaType.image.rawValue)
            return PHAsset.fetchAssets(with: options)
        }
    }

    func fetchAlbums() async -> [PhotoAlbum] {
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var items: [PhotoAlbum] = []

        collections.enumerateObjects { collection, _, _ in
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            guard assets.count > 0 else { return }

            items.append(
                PhotoAlbum(
                    id: collection.localIdentifier,
                    title: collection.localizedTitle ?? "Album",
                    count: assets.count,
                    collection: collection,
                    coverAsset: assets.firstObject
                )
            )
        }

        return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    func fetchAssets(in album: PhotoAlbum) async -> [ImportedPhotoAsset] {
        await fetchAssets {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            return PHAsset.fetchAssets(in: album.collection, options: options)
        }
    }

    func requestImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }

    private func fetchAssets(_ provider: () -> PHFetchResult<PHAsset>) async -> [ImportedPhotoAsset] {
        let result = provider()
        var items: [ImportedPhotoAsset] = []

        result.enumerateObjects { asset, index, _ in
            let title = asset.creationDate.map(Self.formatter.string(from:)) ?? "Photo \(index + 1)"
            items.append(
                ImportedPhotoAsset(
                    id: asset.localIdentifier,
                    title: title,
                    asset: asset
                )
            )
        }

        return items
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
