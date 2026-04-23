import SwiftUI

struct PermissionToggleCard: View {
    let permission: PermissionToggleState
    let onToggle: (Bool) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: permission.systemImage)
                .foregroundStyle(permission.isOn ? AppTheme.Colors.accentStart : .white.opacity(0.7))
                .frame(width: 40, height: 40)
                .background(permission.isOn ? AppTheme.Colors.accentStart.opacity(0.18) : .white.opacity(0.08))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(permission.title)
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(.white)
                    if permission.isOptional {
                        Text("(Optional)")
                            .font(AppTheme.Typography.micro)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                    }
                }

                Text(permission.detail)
                    .font(AppTheme.Typography.micro)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Toggle("", isOn: .init(
                get: { permission.isOn },
                set: onToggle
            ))
            .labelsHidden()
            .tint(AppTheme.Colors.accentStart)
        }
    }
}
