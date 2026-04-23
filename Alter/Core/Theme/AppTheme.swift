import SwiftUI

enum AppTheme {
    enum Colors {
        static let background = Color(hex: 0x0F0F13)
        static let surface = Color.white.opacity(0.08)
        static let elevatedSurface = Color.white.opacity(0.12)
        static let border = Color.white.opacity(0.12)
        static let secondaryText = Color.white.opacity(0.62)
        static let tertiaryText = Color.white.opacity(0.42)
        static let accentStart = Color(hex: 0xA78BFA)
        static let accentEnd = Color(hex: 0xF9A8D4)
        static let success = Color(hex: 0xA78BFA)
    }

    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 24, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
        static let micro = Font.system(size: 11, weight: .medium, design: .rounded)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
