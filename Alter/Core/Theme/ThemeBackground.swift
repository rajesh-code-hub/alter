import SwiftUI

struct ThemeBackground: View {
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            Circle()
                .fill(AppTheme.Colors.accentStart.opacity(0.22))
                .frame(width: 280, height: 280)
                .blur(radius: 90)
                .offset(x: -140, y: -260)

            Circle()
                .fill(AppTheme.Colors.accentEnd.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 110)
                .offset(x: 160, y: 320)
        }
    }
}
