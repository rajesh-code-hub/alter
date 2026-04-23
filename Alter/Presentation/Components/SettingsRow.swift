import SwiftUI

struct SettingsRow: View {
    let item: AccountSettingItem

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.systemImage)
                .foregroundStyle(item.accentColor)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.05))
                .clipShape(Circle())

            Text(item.title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(item.accentColor == AppTheme.Colors.accentEnd ? AppTheme.Colors.accentEnd : .white.opacity(0.9))

            Spacer()

            if let value = item.value {
                Text(value)
                    .font(AppTheme.Typography.micro)
                    .foregroundStyle(item.title == "Default Quality" ? AppTheme.Colors.accentStart : AppTheme.Colors.secondaryText)
            }

            if item.showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.tertiaryText)
            }
        }
        .padding(.vertical, 16)
    }
}
