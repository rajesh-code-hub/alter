import SwiftUI

struct RootView: View {
    @State private var selectedTab: RootTab = .projects
    @State private var creationPath: [AppRoute] = []
    @State private var isCreationFlowPresented = false
    private let aiService: GenerativeAIService

    init(aiService: GenerativeAIService = StubGenerativeAIService()) {
        self.aiService = aiService
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ProjectsView(
                    viewModel: ProjectsViewModel(),
                    onCreateProject: {
                        creationPath = []
                        isCreationFlowPresented = true
                    }
                )
            }
            .fullScreenCover(isPresented: $isCreationFlowPresented, onDismiss: {
                creationPath = []
            }) {
                NavigationStack(path: $creationPath) {
                    ImportPhotoView(
                        viewModel: ImportPhotoViewModel(),
                        onBack: {
                            isCreationFlowPresented = false
                        },
                        onImport: { editorImage in
                            if let editorImage {
                                creationPath.append(.editor(editorImage))
                            }
                        }
                    )
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .editor(let editorImage):
                            EditorView(
                                viewModel: EditorViewModel(
                                    editorImage: editorImage,
                                    aiService: aiService
                                )
                            )
                        case .welcome, .importPhoto:
                            EmptyView()
                        }
                    }
                }
            }
            .tabItem {
                Label(RootTab.projects.rawValue, systemImage: RootTab.projects.systemImage)
            }
            .tag(RootTab.projects)

            NavigationStack {
                AccountView(viewModel: AccountViewModel())
            }
            .tabItem {
                Label(RootTab.account.rawValue, systemImage: RootTab.account.systemImage)
            }
            .tag(RootTab.account)
        }
        .tint(.white)
    }
}
