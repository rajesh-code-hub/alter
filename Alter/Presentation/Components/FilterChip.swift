import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.micro)
                .foregroundStyle(isSelected ? AppTheme.Colors.accentStart : AppTheme.Colors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? AppTheme.Colors.accentStart.opacity(0.18) : .white.opacity(0.08))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(isSelected ? AppTheme.Colors.accentStart.opacity(0.55) : AppTheme.Colors.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}
