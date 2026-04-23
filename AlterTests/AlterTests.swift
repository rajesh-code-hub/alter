import Testing
import SwiftUI
import UIKit
@testable import Alter

struct AlterTests {
    @Test func importPhotoButtonReflectsSelectionState() async throws {
        let viewModel = ImportPhotoViewModel()

        #expect(viewModel.selectedCountText == "Import 1 Photo")

        viewModel.selectedPhoto = nil

        #expect(viewModel.selectedCountText == "Import Photo")
    }

    @Test func editorInvokesStubbedAIServiceForSelectedTool() async throws {
        let service = RecordingAIService()
        let viewModel = await EditorViewModel(
            previewAsset: PhotoAsset(title: "Portrait", imageName: "person.crop.square", accentColor: .blue, isCameraTile: false),
            aiService: service
        )

        await MainActor.run {
            viewModel.selectedTool = .background
        }
        await viewModel.applySelectedTool()

        let didCallBackground = await service.didCallBackground
        #expect(didCallBackground)
    }
}

actor RecordingAIService: GenerativeAIService {
    private(set) var didCallBackground = false

    func removeObject(from image: UIImage, mask: Path) async throws -> UIImage {
        _ = image
        _ = mask
        return UIImage()
    }

    func changeBackground(image: UIImage, prompt: String) async throws -> UIImage {
        _ = image
        _ = prompt
        didCallBackground = true
        return UIImage()
    }

    func swapOutfit(image: UIImage, category: OutfitCategory) async throws -> UIImage {
        _ = image
        _ = category
        return UIImage()
    }
}
