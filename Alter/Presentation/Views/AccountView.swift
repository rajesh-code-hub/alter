import SwiftUI

struct AccountView: View {
    @StateObject var viewModel: AccountViewModel

    var body: some View {
        ZStack {
            ThemeBackground()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        profileCard
                        creditsCard
                        defaultsSection
                        privacySection
                        supportSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 120)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            IconButton(systemImage: "chevron.left") {}
                .hidden()
            Spacer()
            Text("Settings")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 12)
    }

    private var profileCard: some View {
        GlassCard {
            VStack(spacing: 14) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.Colors.accentStart, AppTheme.Colors.accentEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                VStack(spacing: 4) {
                    Text(viewModel.userName)
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Text(viewModel.email)
                        .font(AppTheme.Typography.micro)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }

                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                    Text("PRO MEMBER")
                }
                .font(AppTheme.Typography.micro)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: [AppTheme.Colors.accentStart, AppTheme.Colors.accentEnd],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var creditsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("AI Usage")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.8))

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.remainingCredits)")
                            .font(AppTheme.Typography.title)
                            .foregroundStyle(.white)
                        Text("Credits remaining")
                            .font(AppTheme.Typography.micro)
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                    }

                    Spacer()

                    Text("Buy More")
                        .font(AppTheme.Typography.micro)
                        .foregroundStyle(AppTheme.Colors.accentEnd)
                }

                ProgressView(value: viewModel.creditsProgress)
                    .tint(AppTheme.Colors.accentStart)

                HStack {
                    Spacer()
                    Text(viewModel.resetText)
                        .font(AppTheme.Typography.micro)
                        .foregroundStyle(AppTheme.Colors.tertiaryText)
                }
            }
        }
    }

    private var defaultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Defaults")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white.opacity(0.8))

            GlassCard {
                VStack(spacing: 0) {
                    ForEach(viewModel.defaultSettings) { item in
                        SettingsRow(item: item)
                        Divider().overlay(.white.opacity(0.08))
                    }

                    HStack(spacing: 14) {
                        Image(systemName: "c.circle")
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(.white.opacity(0.05))
                            .clipShape(Circle())

                        Text("Auto-Watermark")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.white.opacity(0.9))

                        Spacer()

                        Toggle("", isOn: $viewModel.autoWatermarkEnabled)
                            .labelsHidden()
                            .tint(AppTheme.Colors.accentStart)
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Privacy & App")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white.opacity(0.8))

            GlassCard {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.privacySettings.enumerated()), id: \.element.id) { index, item in
                        SettingsRow(item: item)
                        if index < viewModel.privacySettings.count - 1 {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }
        }
    }

    private var supportSection: some View {
        VStack(spacing: 12) {
            GlassCard {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.supportSettings.enumerated()), id: \.element.id) { index, item in
                        SettingsRow(item: item)
                        if index < viewModel.supportSettings.count - 1 {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }

            Text("Log Out")
                .font(AppTheme.Typography.micro)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(viewModel.versionText)
                .font(AppTheme.Typography.micro)
                .foregroundStyle(.white.opacity(0.2))
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(viewModel: AccountViewModel())
    }
}
