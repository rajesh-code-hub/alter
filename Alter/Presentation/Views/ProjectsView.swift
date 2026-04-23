import SwiftUI

struct ProjectsView: View {
    @StateObject var viewModel: ProjectsViewModel
    let onCreateProject: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    var body: some View {
        ZStack {
            ThemeBackground()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        SearchField(placeholder: "Search projects...", text: $viewModel.searchText)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(ProjectFilter.allCases) { filter in
                                    FilterChip(
                                        title: filter.rawValue,
                                        isSelected: viewModel.selectedFilter == filter
                                    ) {
                                        viewModel.selectedFilter = filter
                                    }
                                }
                            }
                        }

                        HStack {
                            Text("\(viewModel.filteredProjects.count) Projects")
                                .font(AppTheme.Typography.micro)
                                .foregroundStyle(AppTheme.Colors.secondaryText)

                            Spacer()

                            HStack(spacing: 6) {
                                smallToggleButton(systemImage: "square.grid.2x2.fill", isActive: true)
                                smallToggleButton(systemImage: "list.bullet", isActive: false)
                            }
                        }

                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(viewModel.filteredProjects) { project in
                                ProjectCard(project: project) {
                                    viewModel.selectedProject = project
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: $viewModel.selectedProject) { project in
            ProjectActionSheet(project: project)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            IconButton(systemImage: "chevron.left") {}
                .hidden()
            Spacer()
            Text("Projects")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white)
            Spacer()
            IconButton(systemImage: "plus", action: onCreateProject)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 12)
    }

    private func smallToggleButton(systemImage: String, isActive: Bool) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(isActive ? .white : AppTheme.Colors.secondaryText)
            .frame(width: 32, height: 32)
            .background(isActive ? .white.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct ProjectActionSheet: View {
    let project: ProjectItem

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [project.accentColor.opacity(0.9), AppTheme.Colors.background],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .overlay {
                        Image(systemName: project.imageName)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(project.title)
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Text("Last edited \(project.subtitle)")
                        .font(AppTheme.Typography.micro)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }
            }

            VStack(spacing: 10) {
                actionButton("Open Project", systemImage: "folder")
                actionButton("Duplicate", systemImage: "doc.on.doc")
                actionButton("Export & Share", systemImage: "square.and.arrow.up")
            }

            Spacer()
        }
        .padding(24)
        .background(AppTheme.Colors.background)
    }

    private func actionButton(_ title: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.tertiaryText)
        }
        .padding(16)
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(viewModel: ProjectsViewModel(), onCreateProject: {})
    }
}
