import SwiftUI

struct PreviewCanvas: View {
    let image: UIImage
    let title: String
    let showsCropOverlay: Bool

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()

                VStack(spacing: 14) {
                    Spacer()
                    Text(title)
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.24))
                        .clipShape(Capsule())
                        .padding(.bottom, 22)
                }

                if showsCropOverlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.45), lineWidth: 1)
                        .padding(16)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            }
        }
    }
}
