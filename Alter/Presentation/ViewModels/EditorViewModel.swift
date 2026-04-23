import Combine
import SwiftUI
import UIKit

@MainActor
final class EditorViewModel: ObservableObject {
    @Published var selectedTool: EditorTool = .remove
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var compareModeEnabled = false

    let title: String
    let editorImage: EditorImage

    private let aiService: GenerativeAIService

    init(
        editorImage: EditorImage,
        aiService: GenerativeAIService
    ) {
        self.title = editorImage.title
        self.editorImage = editorImage
        self.aiService = aiService
    }

    func applySelectedTool() async {
        isProcessing = true
        errorMessage = nil

        defer { isProcessing = false }

        do {
            switch selectedTool {
            case .remove:
                _ = try await aiService.removeObject(from: editorImage.image, mask: Path())
            case .background:
                _ = try await aiService.changeBackground(image: editorImage.image, prompt: "Studio background")
            case .wardrobe:
                _ = try await aiService.swapOutfit(image: editorImage.image, category: .streetwear)
//            case .enhance, .adjust:
//                break
            }
        } catch {
            errorMessage = "AI action is stubbed and ready for backend integration."
        }
    }
}
