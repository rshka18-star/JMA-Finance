
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: FinanceStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.transactions) { tx in
                    HStack {
                        Image(systemName: tx.kind == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundStyle(tx.kind == .income ? .green : .red)
                        VStack(alignment: .leading) {
                            Text(tx.category.isEmpty ? tx.kind.rawValue.capitalized : tx.category)
                                .fontWeight(.semibold)
                            if !tx.note.isEmpty {
                                Text(tx.note).font(.caption).foregroundStyle(.secondary)
                            }
                            Text(tx.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text((tx.kind == .income ? "+" : "-") + tx.amount.euro)
                            .foregroundStyle(tx.kind == .income ? .green : .red)
                            .fontWeight(.bold)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            store.delete(id: tx.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(JMATheme.bg)
            .navigationTitle("History")
        }
    }
}
