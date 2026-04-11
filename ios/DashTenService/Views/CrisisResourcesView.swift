import SwiftUI

struct CrisisResourcesView: View {
    private let resources = TransitionDataService.crisisResources()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.red)
                    Text("You Are Not Alone")
                        .font(.title2.bold())
                    Text("If you or someone you know is struggling, help is available 24/7. These resources are free and confidential.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("This app is not an emergency service or mental health provider. The resources below connect you directly to trained professionals.")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.red.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                ForEach(resources) { resource in
                    CrisisResourceCard(resource: resource)
                }

                NonAffiliationBanner()
                    .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Crisis Resources")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CrisisResourceCard: View {
    let resource: CrisisResource

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(resource.isEmergency ? .red.opacity(0.12) : AppTheme.forestGreen.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: resource.icon)
                        .font(.body.weight(.bold))
                        .foregroundStyle(resource.isEmergency ? .red : AppTheme.forestGreen)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(resource.title)
                        .font(.subheadline.weight(.bold))
                    Text(resource.subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }
            }

            HStack(spacing: 10) {
                if let phone = resource.phoneNumber {
                    if let url = URL(string: "tel:\(phone.replacingOccurrences(of: "-", with: ""))") {
                        Link(destination: url) {
                            Label("Call \(phone)", systemImage: "phone.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(resource.isEmergency ? .red : AppTheme.forestGreen)
                                .clipShape(Capsule())
                        }
                    }
                }

                if let text = resource.textLine {
                    if let url = URL(string: "sms:\(text)") {
                        Link(destination: url) {
                            Label("Text \(text)", systemImage: "message.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(resource.isEmergency ? .red : AppTheme.forestGreen)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background((resource.isEmergency ? Color.red : AppTheme.forestGreen).opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }

                if let urlString = resource.url, let url = URL(string: urlString) {
                    Link(destination: url) {
                        Label("Website", systemImage: "arrow.up.right.square")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(resource.isEmergency ? .red.opacity(0.2) : .clear, lineWidth: 1)
        )
    }
}
