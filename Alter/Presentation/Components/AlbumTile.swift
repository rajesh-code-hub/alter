import Photos
import SwiftUI
import UIKit

struct AlbumTile: View {
    let album: PhotoAlbum
    let coverProvider: (PHAsset, CGSize) async -> UIImage?
    let action: () -> Void
    @State private var coverImage: UIImage?

    private let coverSize = CGSize(width: 180, height: 180)

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.06))

                    if let coverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ProgressView()
                            .tint(.white.opacity(0.7))
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(album.title)
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(.white)
                    Text("\(album.count) photos")
                        .font(AppTheme.Typography.micro)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.tertiaryText)
            }
            .padding(14)
            .background(.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.Colors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .task(id: album.id) {
            guard coverImage == nil, let coverAsset = album.coverAsset else { return }
            coverImage = await coverProvider(coverAsset, coverSize)
        }
    }
}
