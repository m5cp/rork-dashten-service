import SwiftUI
import PhotosUI

struct EditProfileSheet: View {
    @Bindable var storage: StorageService
    @Environment(\.dismiss) private var dismiss

    @State private var nameDraft: String = ""
    @State private var presetDraft: String? = nil
    @State private var photoDraft: Data? = nil
    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var isLoadingPhoto: Bool = false

    private let columns = [GridItem(.adaptive(minimum: 64), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    AvatarView(
                        photoData: photoDraft,
                        presetId: photoDraft == nil ? presetDraft : nil,
                        displayName: nameDraft,
                        size: 120
                    )
                    .overlay(alignment: .bottomTrailing) {
                        if isLoadingPhoto {
                            ProgressView()
                                .padding(8)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 12)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("DISPLAY NAME")
                            .font(.caption2.weight(.heavy))
                            .tracking(1.1)
                            .foregroundStyle(.secondary)
                        TextField("Your name", text: $nameDraft)
                            .font(.body.weight(.semibold))
                            .padding(14)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 12))
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 4)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("PHOTO")
                            .font(.caption2.weight(.heavy))
                            .tracking(1.1)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 10) {
                            PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
                                Label(photoDraft == nil ? "Upload Photo" : "Replace Photo", systemImage: "photo.on.rectangle")
                                    .font(.subheadline.weight(.bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .foregroundStyle(.white)
                                    .background(AppTheme.forestGreen, in: .rect(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)

                            if photoDraft != nil {
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                        photoDraft = nil
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .font(.subheadline.weight(.bold))
                                        .frame(width: 48, height: 48)
                                        .foregroundStyle(.red)
                                        .background(Color.red.opacity(0.12), in: .rect(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 4)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("OR PICK A PRESET")
                            .font(.caption2.weight(.heavy))
                            .tracking(1.1)
                            .foregroundStyle(.secondary)

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(AvatarPreset.all) { preset in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        photoDraft = nil
                                        presetDraft = preset.id
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(preset.color.opacity(0.18))
                                            .frame(width: 60, height: 60)
                                        Image(systemName: preset.icon)
                                            .font(.system(size: 26, weight: .semibold))
                                            .foregroundStyle(preset.color)
                                    }
                                    .overlay {
                                        Circle()
                                            .stroke(presetDraft == preset.id && photoDraft == nil ? preset.color : .clear, lineWidth: 3)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.body.weight(.semibold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .font(.body.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                }
            }
            .onAppear {
                nameDraft = storage.profile.displayName
                presetDraft = storage.profile.avatarPresetId ?? "default"
                photoDraft = storage.profile.avatarPhotoData
            }
            .onChange(of: pickerItem) { _, newValue in
                guard let newValue else { return }
                isLoadingPhoto = true
                Task {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let resized = Self.compress(data: data) {
                        await MainActor.run {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                photoDraft = resized
                            }
                            isLoadingPhoto = false
                        }
                    } else {
                        await MainActor.run { isLoadingPhoto = false }
                    }
                }
            }
        }
    }

    private func save() {
        storage.profile.displayName = nameDraft.trimmingCharacters(in: .whitespaces)
        storage.profile.avatarPhotoData = photoDraft
        storage.profile.avatarPresetId = photoDraft == nil ? presetDraft : nil
        dismiss()
    }

    nonisolated private static func compress(data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let maxDim: CGFloat = 512
        let scale = min(1, maxDim / max(image.size.width, image.size.height))
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.8)
    }
}
