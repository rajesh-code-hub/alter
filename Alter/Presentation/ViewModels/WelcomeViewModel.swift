import Combine

final class WelcomeViewModel: ObservableObject {
    @Published var permissions: [PermissionToggleState] = [
        PermissionToggleState(
            title: "Access Photos",
            detail: "Required to select and edit your images. We never store photos without permission.",
            systemImage: "photo.on.rectangle.angled",
            isOptional: false,
            isOn: true
        ),
        PermissionToggleState(
            title: "Notifications",
            detail: "Get notified when complex AI generations are complete.",
            systemImage: "bell.fill",
            isOptional: true,
            isOn: false
        )
    ]

    func setPermission(_ permission: PermissionToggleState, enabled: Bool) {
        guard let index = permissions.firstIndex(where: { $0.id == permission.id }) else { return }
        permissions[index].isOn = enabled
    }
}
