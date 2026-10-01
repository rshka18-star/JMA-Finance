
import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var store: FinanceStore
    @Environment(\.dismiss) var dismiss

    let kind: TransactionKind
    @State private var amount = ""
    @State private var category = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("€0.00", text: $amount)
                        .keyboardType(.decimalPad)
                }
                Section("Details") {
                    TextField("Category", text: $category)
                    TextField("Note (optional)", text: $note)
                }
                Section {
                    Button(kind == .income ? "Save Income" : "Save Expense") {
                        let normalized = amount.replacingOccurrences(of: ",", with: ".")
                        if let value = Double(normalized), value > 0 {
                            store.add(kind: kind, amount: value, category: category, note: note)
                            dismiss()
                        }
                    }
                    .foregroundStyle(kind == .income ? .green : .red)
                    .fontWeight(.bold)
                }
            }
            .navigationTitle(kind == .income ? "Add Income" : "Add Expense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
