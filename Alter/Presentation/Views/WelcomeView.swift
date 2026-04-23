import SwiftUI

struct WelcomeView: View {
    @StateObject var viewModel: WelcomeViewModel
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            ThemeBackground()

            VStack(spacing: 0) {
                progressHeader

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        heroSection
                        permissionsSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }

                PrimaryButton(title: "Continue", systemImage: "arrow.right", action: onContinue)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var progressHeader: some View {
        HStack {
            Button("Skip", action: onContinue)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Spacer()

            HStack(spacing: 8) {
                Capsule().fill(AppTheme.Colors.accentStart).frame(width: 32, height: 6)
                Capsule().fill(.white.opacity(0.2)).frame(width: 32, height: 6)
            }

            Spacer()

            Color.clear.frame(width: 32, height: 32)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }

    private var heroSection: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.Colors.accentStart.opacity(0.95), AppTheme.Colors.accentEnd.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: 280)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "sparkles")
                        .font(.system(size: 72, weight: .light))
                        .foregroundStyle(.white.opacity(0.9))
                }

            VStack(spacing: 12) {
                Text("Meet your\nAI Photo Editor")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Remove objects, swap backgrounds, and enhance quality with a single tap.")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
        }
    }

    private var permissionsSection: some View {
        GlassCard {
            VStack(spacing: 18) {
                ForEach(Array(viewModel.permissions.enumerated()), id: \.element.id) { index, permission in
                    PermissionToggleCard(permission: permission) { enabled in
                        viewModel.setPermission(permission, enabled: enabled)
                    }

                    if index < viewModel.permissions.count - 1 {
                        Divider().overlay(.white.opacity(0.08))
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewModel: WelcomeViewModel(), onContinue: {})
    }
}
