import SwiftUI

struct IconButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.white.opacity(0.08))
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}
