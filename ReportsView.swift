
import SwiftUI
import Charts

struct ReportsView: View {
    @EnvironmentObject var store: FinanceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    NeonCard {
                        VStack(spacing: 14) {
                            reportRow("Total Income", store.totalIncome, .green)
                            reportRow("Total Expenses", store.totalExpense, .red)
                            reportRow("Balance", store.balance, .white)
                        }
                    }

                    NeonCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overview").font(.headline)
                            Chart {
                                BarMark(x: .value("Type", "Income"), y: .value("Amount", store.totalIncome))
                                    .foregroundStyle(.green)
                                BarMark(x: .value("Type", "Expenses"), y: .value("Amount", store.totalExpense))
                                    .foregroundStyle(.red)
                            }
                            .frame(height: 220)
                        }
                    }
                }
                .padding()
            }
            .background(JMATheme.bg)
            .navigationTitle("Reports")
        }
    }

    private func reportRow(_ title: String, _ amount: Double, _ color: Color) -> some View {
        HStack {
            Text(title).foregroundStyle(color).fontWeight(.semibold)
            Spacer()
            Text(amount.euro).foregroundStyle(color).font(.title3.bold())
        }
    }
}
