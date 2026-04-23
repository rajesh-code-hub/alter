import SwiftUI

struct SearchField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.Colors.tertiaryText)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .foregroundStyle(.white)
        }
        .font(AppTheme.Typography.caption)
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.Colors.border, lineWidth: 1)
        }
    }
}
