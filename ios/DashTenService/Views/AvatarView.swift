import SwiftUI

struct AvatarView: View {
    let photoData: Data?
    let presetId: String?
    let displayName: String
    var size: CGFloat = 64

    private var initials: String {
        let trimmed = displayName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return "" }
        let parts = trimmed.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }

    var body: some View {
        ZStack {
            if let data = photoData, let uiImage = UIImage(data: data) {
                Color(.secondarySystemBackground)
                    .frame(width: size, height: size)
                    .overlay {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .allowsHitTesting(false)
                    }
                    .clipShape(Circle())
            } else {
                let preset = AvatarPreset.preset(for: presetId)
                Circle()
                    .fill(preset.color.opacity(0.18))
                    .frame(width: size, height: size)
                    .overlay {
                        if !initials.isEmpty && presetId == nil {
                            Text(initials)
                                .font(.system(size: size * 0.42, weight: .heavy, design: .rounded))
                                .foregroundStyle(preset.color)
                        } else {
                            Image(systemName: preset.icon)
                                .font(.system(size: size * 0.46, weight: .semibold))
                                .foregroundStyle(preset.color)
                        }
                    }
            }
        }
    }
}
