import SwiftUI

struct FeatureCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(AppTheme.Typography.micro)
            }
            .foregroundStyle(isActive ? .white : AppTheme.Colors.secondaryText)
            .frame(width: 72, height: 64)
            .background(isActive ? .white.opacity(0.12) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(alignment: .topTrailing) {
                if isActive {
                    Circle()
                        .fill(AppTheme.Colors.accentStart)
                        .frame(width: 8, height: 8)
                        .padding(8)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title), \(subtitle)")
    }
}
