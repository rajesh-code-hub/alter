import SwiftUI
import UIKit

protocol GenerativeAIService {
    func removeObject(from image: UIImage, mask: Path) async throws -> UIImage
    func changeBackground(image: UIImage, prompt: String) async throws -> UIImage
    func swapOutfit(image: UIImage, category: OutfitCategory) async throws -> UIImage
}

enum GenerativeAIServiceError: Error {
    case notImplemented
}

struct StubGenerativeAIService: GenerativeAIService {
    func removeObject(from image: UIImage, mask: Path) async throws -> UIImage {
        _ = mask
        throw GenerativeAIServiceError.notImplemented
    }

    func changeBackground(image: UIImage, prompt: String) async throws -> UIImage {
        _ = prompt
        throw GenerativeAIServiceError.notImplemented
    }

    func swapOutfit(image: UIImage, category: OutfitCategory) async throws -> UIImage {
        _ = category
        throw GenerativeAIServiceError.notImplemented
    }
}
