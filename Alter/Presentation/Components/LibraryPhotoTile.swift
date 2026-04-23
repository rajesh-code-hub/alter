import Photos
import SwiftUI
import UIKit

struct LibraryPhotoTile: View {
    let asset: ImportedPhotoAsset
    let thumbnailProvider: (PHAsset, CGSize) async -> UIImage?
    let tileSize: CGFloat
    let action: () -> Void
    @State private var thumbnail: UIImage?

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white.opacity(0.05))

                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .tint(.white.opacity(0.7))
                }
            }
            .frame(width: tileSize, height: tileSize)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.Colors.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .task(id: asset.id) {
            guard thumbnail == nil else { return }
            thumbnail = await thumbnailProvider(asset.asset, CGSize(width: tileSize * 2, height: tileSize * 2))
        }
    }
}
