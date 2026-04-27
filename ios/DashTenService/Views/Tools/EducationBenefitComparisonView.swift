import SwiftUI

struct EducationBenefitComparisonView: View {
    @State private var selectedBenefit: Int = 0

    private let benefits: [EdBenefit] = [
        EdBenefit(
            name: "Post-9/11 GI Bill",
            chapter: "Chapter 33",
            color: .blue,
            tuition: "Up to full in-state tuition at public schools, or up to ~$27,120/yr at private schools",
            housing: "Monthly housing allowance based on school ZIP code and enrollment status",
            books: "Up to $1,000/year for books and supplies",
            duration: "36 months of benefits",
            eligibility: "90+ days of active duty service after 9/10/2001, or 30+ days with service-connected discharge",
            transferable: "Can transfer to spouse or dependents if you have 6+ years of service and commit to 4 more",
            pros: ["Highest overall benefit value", "Housing allowance is substantial", "Transferable to dependents", "No out-of-pocket tuition at most public schools"],
            cons: ["Must have post-9/11 service", "Housing only paid during enrollment", "Online-only students get reduced BAH", "Transfer requires additional service commitment"]
        ),
        EdBenefit(
            name: "Montgomery GI Bill",
            chapter: "Chapter 30",
            color: .teal,
            tuition: "Flat monthly payment (~$2,186/mo for full-time) applied to any school",
            housing: "Included in monthly payment (no separate housing allowance)",
            books: "Included in monthly payment",
            duration: "36 months of benefits",
            eligibility: "Enrolled and paid $1,200 during first year of service, served 2+ years active duty",
            transferable: "Not transferable to dependents",
            pros: ["Flat rate is predictable", "Can be used at any school type", "Good for expensive private schools where Post-9/11 cap falls short", "Can combine with other programs"],
            cons: ["Lower total value than Post-9/11 in most cases", "No separate housing allowance", "Required $1,200 enrollment fee", "Not transferable"]
        ),
        EdBenefit(
            name: "Veteran Readiness (VR&E)",
            chapter: "Chapter 31",
            color: .purple,
            tuition: "Full tuition, fees, books, and supplies covered",
            housing: "Monthly subsistence allowance during training",
            books: "Fully covered",
            duration: "Up to 48 months (case-by-case)",
            eligibility: "Must have a service-connected disability rating AND an employment barrier",
            transferable: "Not transferable",
            pros: ["Covers everything including supplies and equipment", "Longer duration than GI Bill", "Includes career counseling and job placement", "Can be used after GI Bill is exhausted"],
            cons: ["Requires disability rating with employment barrier", "More restrictive approval process", "Counselor assigns training program", "Less flexibility in school/program choice"]
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.doc.horizontal.fill")
                            .foregroundStyle(.indigo)
                        Text("Compare Your Options")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Understanding the differences between education benefits helps you maximize your investment. Each program has unique advantages depending on your situation.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Educational summary only — not legal, financial, or VA-certified guidance. Verify with the VA and your School Certifying Official before enrolling.")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.85))
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.orange.opacity(0.10))
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding(14)
                .background(.indigo.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                Picker("Benefit", selection: $selectedBenefit) {
                    ForEach(0..<benefits.count, id: \.self) { i in
                        Text(benefits[i].name).tag(i)
                    }
                }
                .pickerStyle(.segmented)

                let benefit = benefits[selectedBenefit]
                benefitDetail(benefit)

                comparisonTable

                Text("Benefit amounts and eligibility change annually. Verify all details with official sources before making enrollment decisions.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Education Benefits")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func benefitDetail(_ b: EdBenefit) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Circle().fill(b.color).frame(width: 10, height: 10)
                Text(b.name)
                    .font(.title3.weight(.bold))
                StatusBadge(text: b.chapter, color: b.color)
            }

            VStack(spacing: 10) {
                detailRow(label: "Tuition", value: b.tuition, icon: "graduationcap.fill", color: b.color)
                Divider()
                detailRow(label: "Housing", value: b.housing, icon: "house.fill", color: b.color)
                Divider()
                detailRow(label: "Books", value: b.books, icon: "book.fill", color: b.color)
                Divider()
                detailRow(label: "Duration", value: b.duration, icon: "clock.fill", color: b.color)
                Divider()
                detailRow(label: "Eligibility", value: b.eligibility, icon: "person.fill.checkmark", color: b.color)
                Divider()
                detailRow(label: "Transferable", value: b.transferable, icon: "arrow.triangle.swap", color: b.color)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pros")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    ForEach(b.pros, id: \.self) { pro in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.forestGreen)
                                .padding(.top, 2)
                            Text(pro)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Cons")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red)
                    ForEach(b.cons, id: \.self) { con in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "minus.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(.red)
                                .padding(.top, 2)
                            Text(con)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.red.opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }

    private func detailRow(label: String, value: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.6))
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
            }
        }
    }

    private var comparisonTable: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Comparison")
                .font(.headline.weight(.bold))

            VStack(spacing: 0) {
                tableHeader
                tableRow(label: "Max Tuition", values: ["Full in-state", "~$2,186/mo", "Full coverage"])
                tableRow(label: "Housing", values: ["BAH rate", "Included", "Subsistence"])
                tableRow(label: "Duration", values: ["36 mo", "36 mo", "Up to 48 mo"])
                tableRow(label: "Transfer", values: ["Yes", "No", "No"])
            }
            .clipShape(.rect(cornerRadius: 12))
        }
    }

    private var tableHeader: some View {
        HStack(spacing: 0) {
            Text("")
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(benefits, id: \.name) { b in
                Text(b.chapter)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(b.color)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
    }

    private func tableRow(label: String, values: [String]) -> some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(values, id: \.self) { val in
                Text(val)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemGroupedBackground))
    }
}

private nonisolated struct EdBenefit: Sendable {
    let name: String
    let chapter: String
    let color: Color
    let tuition: String
    let housing: String
    let books: String
    let duration: String
    let eligibility: String
    let transferable: String
    let pros: [String]
    let cons: [String]
}
