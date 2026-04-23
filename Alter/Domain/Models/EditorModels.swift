import Photos
import SwiftUI
import UIKit

enum AppRoute: Hashable {
    case welcome
    case importPhoto
    case editor(EditorImage)
}

enum RootTab: String, CaseIterable, Identifiable {
    case projects = "Projects"
    case account = "Account"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .projects: "folder"
        case .account: "person.crop.circle"
        }
    }
}

enum PhotoSourceTab: String, CaseIterable, Identifiable {
    case recent = "Recent"
    case albums = "Albums"
    case favorites = "Favorites"

    var id: String { rawValue }
}

enum EditorTool: String, CaseIterable, Identifiable {
    case remove = "Remove"
    case background = "Background"
    case wardrobe = "Wardrobe"
//    case enhance = "Enhance"
//    case adjust = "Adjust"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .remove: "eraser"
        case .background: "photo.on.rectangle"
        case .wardrobe: "tshirt"
            //        case .enhance: "wand.and.stars"
            //        case .adjust: "slider.horizontal.3"
        }
    }
}

enum OutfitCategory: String, CaseIterable, Identifiable {
    case casual = "Casual"
    case formal = "Formal"
    case streetwear = "Streetwear"
    case evening = "Evening"

    var id: String { rawValue }
}

struct PermissionToggleState: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let systemImage: String
    let isOptional: Bool
    var isOn: Bool
}

struct PhotoAsset: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let accentColor: Color
    let isCameraTile: Bool

    static let camera = PhotoAsset(
        title: "Camera",
        imageName: "camera.fill",
        accentColor: .white.opacity(0.4),
        isCameraTile: true
    )
}

struct ImportedPhotoAsset: Identifiable, Hashable {
    let id: String
    let title: String
    let asset: PHAsset

    static func == (lhs: ImportedPhotoAsset, rhs: ImportedPhotoAsset) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PhotoAlbum: Identifiable, Hashable {
    let id: String
    let title: String
    let count: Int
    let collection: PHAssetCollection
    let coverAsset: PHAsset?

    static func == (lhs: PhotoAlbum, rhs: PhotoAlbum) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct EditorImage: Hashable {
    let id = UUID()
    let title: String
    let image: UIImage
}

enum ProjectFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case edited = "Edited"
    case exported = "Exported"
    case favorites = "Favorites"

    var id: String { rawValue }
}

struct ProjectItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let accentColor: Color
    let isFavorite: Bool
    let isExported: Bool
}

struct AccountSettingItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: String?
    let systemImage: String
    let accentColor: Color
    let showsChevron: Bool
}
