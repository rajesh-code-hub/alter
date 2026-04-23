import SwiftUI

struct ProjectCard: View {
    let project: ProjectItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [project.accentColor.opacity(0.9), AppTheme.Colors.background],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .aspectRatio(0.78, contentMode: .fit)
                        .overlay {
                            VStack(spacing: 10) {
                                Image(systemName: project.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(.white)

                                if project.isExported {
                                    Text("Exported")
                                        .font(AppTheme.Typography.micro)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(.black.opacity(0.24))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppTheme.Colors.border, lineWidth: 1)
                        }

                    if project.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(AppTheme.Colors.accentEnd)
                            .frame(width: 24, height: 24)
                            .background(.black.opacity(0.3))
                            .clipShape(Circle())
                            .padding(10)
                    }
                }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.title)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Text(project.subtitle)
                            .font(AppTheme.Typography.micro)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                    }

                    Spacer()

                    Image(systemName: "ellipsis")
                        .foregroundStyle(AppTheme.Colors.tertiaryText)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
