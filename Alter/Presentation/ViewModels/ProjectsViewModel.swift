import Combine
import SwiftUI

final class ProjectsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter: ProjectFilter = .all
    @Published var selectedProject: ProjectItem?
    @Published private(set) var projects: [ProjectItem] = [
        ProjectItem(title: "Neon Portrait", subtitle: "2 hours ago", imageName: "person.crop.square", accentColor: .purple, isFavorite: true, isExported: false),
        ProjectItem(title: "Cyber Street", subtitle: "Yesterday", imageName: "building.2.crop.circle", accentColor: .pink, isFavorite: false, isExported: false),
        ProjectItem(title: "Watch Promo", subtitle: "Oct 12", imageName: "applewatch", accentColor: .orange, isFavorite: false, isExported: false),
        ProjectItem(title: "Night Peaks", subtitle: "Oct 10", imageName: "mountain.2.fill", accentColor: .indigo, isFavorite: false, isExported: true)
    ]

    var filteredProjects: [ProjectItem] {
        projects.filter { project in
            let matchesSearch = searchText.isEmpty || project.title.localizedCaseInsensitiveContains(searchText)
            let matchesFilter: Bool

            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .edited:
                matchesFilter = !project.isExported
            case .exported:
                matchesFilter = project.isExported
            case .favorites:
                matchesFilter = project.isFavorite
            }

            return matchesSearch && matchesFilter
        }
    }
}
