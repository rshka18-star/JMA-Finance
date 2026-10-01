
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
            ReportsView()
                .tabItem { Label("Reports", systemImage: "chart.bar.fill") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(.cyan)
    }
}

struct HomeView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var addKind: TransactionKind?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    JMALogoView()
                        .scaleEffect(0.82)

                    HStack(spacing: 12) {
                        actionCard(kind: .income)
                        actionCard(kind: .expense)
                    }

                    NeonCard {
                        HStack {
                            Image(systemName: "wallet.pass.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(.yellow)
                            VStack(alignment: .leading) {
                                Text("Current Balance").font(.headline)
                                Text(store.balance.euro).font(.system(size: 34, weight: .bold))
                            }
                            Spacer()
                            Image(systemName: "eye.fill").foregroundStyle(.white)
                        }
                    }

                    Picker("Period", selection: $store.period) {
                        ForEach(PeriodFilter.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)

                    let t = store.totals(for: store.period)
                    summaryCard(title: periodTitle(store.period), totals: t)

                    HStack(spacing: 12) {
                        summaryCard(title: "This Week", totals: store.totals(for: .week))
                        summaryCard(title: "This Month", totals: store.totals(for: .month))
                    }

                    NeonCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Recent Transactions").font(.headline)
                                Spacer()
                            }
                            if store.transactions.isEmpty {
                                Text("No transactions yet").foregroundStyle(.secondary)
                            } else {
                                ForEach(store.transactions.prefix(6)) { tx in
                                    HStack {
                                        Image(systemName: tx.kind == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                            .foregroundStyle(tx.kind == .income ? .green : .red)
                                        VStack(alignment: .leading) {
                                            Text(tx.category.isEmpty ? tx.kind.rawValue.capitalized : tx.category)
                                                .fontWeight(.semibold)
                                            Text(tx.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text((tx.kind == .income ? "+" : "-") + tx.amount.euro)
                                            .foregroundStyle(tx.kind == .income ? .green : .red)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(JMATheme.bg)
            .navigationTitle("JMA Finance")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $addKind) { kind in
            AddTransactionView(kind: kind)
        }
    }

    private func actionCard(kind: TransactionKind) -> some View {
        let isIncome = kind == .income
        return Button {
            addKind = kind
        } label: {
            VStack(spacing: 10) {
                Text(isIncome ? "Income" : "Expenses")
                    .font(.headline)
                Image(systemName: isIncome ? "plus.circle.fill" : "minus.circle.fill")
                    .font(.system(size: 54))
                Text((isIncome ? store.totalIncome : store.totalExpense).euro)
                    .font(.title2.bold())
                Text("Tap to add")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill((isIncome ? Color.green : Color.red).opacity(0.22))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isIncome ? Color.green : Color.red, lineWidth: 1.5)
            )
            .foregroundStyle(isIncome ? .green : .red)
        }
        .buttonStyle(.plain)
    }

    private func summaryCard(title: String, totals: (income: Double, expense: Double, balance: Double)) -> some View {
        NeonCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text("↑ Income  \(totals.income.euro)").foregroundStyle(.green)
                Text("↓ Expenses \(totals.expense.euro)").foregroundStyle(.red)
                Text("▥ Balance \(totals.balance.euro)").foregroundStyle(.white).fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func periodTitle(_ p: PeriodFilter) -> String {
        switch p {
        case .day: return "Today Summary"
        case .week: return "This Week"
        case .month: return "This Month"
        }
    }
}
