import SwiftUI

struct SCRAProtectionsView: View {
    @State private var expandedSection: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(scraProtections) { protection in
                    ProtectionAccordionCard(
                        protection: protection,
                        isExpanded: expandedSection == protection.id
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            expandedSection = expandedSection == protection.id ? nil : protection.id
                        }
                    }
                }
                howToInvokeCard
                legalOfficeCard
                Text("General information only · Not affiliated with any government agency")
                    .font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("SCRA Protections")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var howToInvokeCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill").foregroundStyle(AppTheme.gold)
                Text("General Steps").font(.subheadline.weight(.bold))
            }
            VStack(alignment: .leading, spacing: 8) {
                stepRow("1", "Notify the creditor or landlord in writing that you are on active duty and that the SCRA applies.")
                stepRow("2", "Include a copy of your orders or a statement from your commanding officer.")
                stepRow("3", "Send via certified mail to create a delivery record.")
                stepRow("4", "Your installation legal assistance office can help — at no cost to you.")
            }
        }
        .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
    }

    private var legalOfficeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "building.columns.fill").foregroundStyle(AppTheme.forestGreen)
                Text("Installation Legal Assistance").font(.subheadline.weight(.bold))
            }
            Text("Every military installation has a legal assistance office that can review your situation and explain how the SCRA applies to your circumstances. This service is available to active-duty members at no charge.")
                .font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
        }
        .padding(14).background(AppTheme.forestGreen.opacity(0.06)).clipShape(.rect(cornerRadius: 12))
    }

    private func stepRow(_ num: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(num).font(.caption.weight(.heavy)).foregroundStyle(.white)
                .frame(width: 22, height: 22).background(AppTheme.forestGreen).clipShape(Circle())
            Text(text).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
        }
    }

    private var scraProtections: [SCRAProtection] {[
        SCRAProtection(id: "interest", icon: "percent", color: AppTheme.forestGreen,
            title: "6% Interest Rate Cap",
            summary: "Pre-service debt interest may be capped at 6% during active-duty service.",
            details: [
                "Applies to credit cards, car loans, mortgages, and other debts incurred before active-duty service began.",
                "The lender is required to forgive interest above 6% for the covered period.",
                "Written notice with a copy of orders is typically required.",
                "When active-duty service ends, the original rate may resume.",
            ]),
        SCRAProtection(id: "lease", icon: "house.fill", color: .blue,
            title: "Residential Lease Termination",
            summary: "A housing lease may be terminated early without penalty under certain conditions.",
            details: [
                "Applies to leases signed before orders were issued, and to leases signed during service when qualifying PCS or deployment orders are received.",
                "Written notice and a copy of orders are delivered to the landlord.",
                "The lease typically terminates 30 days after the next scheduled rent payment.",
                "State law governs return of security deposits.",
            ]),
        SCRAProtection(id: "auto", icon: "car.fill", color: .purple,
            title: "Vehicle Lease Termination",
            summary: "A vehicle lease may be terminated without early-termination penalties in certain situations.",
            details: [
                "May apply when called to active duty for 180 or more days after signing the lease.",
                "May also apply when receiving PCS orders outside the continental US or deployment orders of 180+ days.",
                "Payments due up to the termination date remain the service member's responsibility.",
            ]),
        SCRAProtection(id: "credit", icon: "creditcard.fill", color: .orange,
            title: "Credit Protection",
            summary: "Invoking SCRA protections cannot be used as a basis to deny or change credit terms.",
            details: [
                "Lenders cannot report SCRA-protected reduced payments as delinquent.",
                "Invoking SCRA rights cannot be used to deny credit, raise rates, or close an account.",
            ]),
        SCRAProtection(id: "court", icon: "building.2.fill", color: .indigo,
            title: "Civil Court Proceedings",
            summary: "A delay of civil proceedings may be available when active duty prevents attendance.",
            details: [
                "Applies to civil matters including bankruptcy, divorce, or foreclosure proceedings.",
                "A postponement of at least 90 days may be requested.",
                "Demonstrating that military duties materially prevent attendance is generally required.",
            ]),
        SCRAProtection(id: "storage", icon: "archivebox.fill", color: .teal,
            title: "Storage Lien Protection",
            summary: "Storage facilities cannot sell your property to satisfy a lien without a court order during active-duty service.",
            details: [
                "Standard lien laws often allow storage facilities to sell belongings after nonpayment.",
                "A storage facility must obtain a court order before enforcing a lien against an active-duty service member.",
            ]),
    ]}
}

struct SCRAProtection: Identifiable {
    let id: String; let icon: String; let color: Color
    let title: String; let summary: String; let details: [String]
}

struct ProtectionAccordionCard: View {
    let protection: SCRAProtection
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: protection.icon).font(.body.weight(.semibold)).foregroundStyle(protection.color)
                        .frame(width: 36, height: 36).background(protection.color.opacity(0.12)).clipShape(.rect(cornerRadius: 10))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(protection.title).font(.subheadline.weight(.bold)).lineLimit(2).multilineTextAlignment(.leading)
                        Text(protection.summary).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).lineLimit(2).multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.down").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14)).contentShape(Rectangle())
            }
            .buttonStyle(.plain).sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(protection.details, id: \.self) { detail in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(protection.color).frame(width: 5, height: 5).padding(.top, 7)
                            Text(detail).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
            }
        }
    }
}
