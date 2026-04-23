import Combine
import SwiftUI

final class AccountViewModel: ObservableObject {
    @Published var autoWatermarkEnabled = false

    let userName = "Sarah Jenkins"
    let email = "sarah.j@example.com"
    let remainingCredits = 450
    let creditsProgress = 0.75
    let resetText = "Resets in 12 days"
    let versionText = "Version 2.4.1 build 84"

    let defaultSettings: [AccountSettingItem] = [
        AccountSettingItem(title: "Export Format", value: "JPG", systemImage: "photo", accentColor: .white.opacity(0.7), showsChevron: true),
        AccountSettingItem(title: "Default Quality", value: "4K Ultra HD", systemImage: "arrow.up.left.and.arrow.down.right", accentColor: AppTheme.Colors.accentStart, showsChevron: true)
    ]

    let privacySettings: [AccountSettingItem] = [
        AccountSettingItem(title: "Privacy Center", value: nil, systemImage: "shield", accentColor: .white.opacity(0.7), showsChevron: true),
        AccountSettingItem(title: "Notifications", value: nil, systemImage: "bell", accentColor: .white.opacity(0.7), showsChevron: true),
        AccountSettingItem(title: "Appearance", value: "Dark Mode", systemImage: "moon", accentColor: .white.opacity(0.7), showsChevron: true)
    ]

    let supportSettings: [AccountSettingItem] = [
        AccountSettingItem(title: "Help & Support", value: nil, systemImage: "questionmark.circle", accentColor: .white.opacity(0.7), showsChevron: true),
        AccountSettingItem(title: "Restore Purchases", value: nil, systemImage: "arrow.clockwise", accentColor: AppTheme.Colors.accentEnd, showsChevron: false)
    ]
}
