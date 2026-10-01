
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var oldPIN = ""
    @State private var newPIN = ""
    @State private var confirmPIN = ""
    @State private var message = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Security") {
                    SecureField("Current PIN", text: $oldPIN)
                        .keyboardType(.numberPad)
                    SecureField("New 4-digit PIN", text: $newPIN)
                        .keyboardType(.numberPad)
                    SecureField("Confirm new PIN", text: $confirmPIN)
                        .keyboardType(.numberPad)
                    Button("Change PIN") {
                        if newPIN.count == 4, newPIN.allSatisfy(\.isNumber), newPIN == confirmPIN,
                           store.changePIN(old: oldPIN, new: newPIN) {
                            message = "PIN changed successfully."
                            oldPIN = ""; newPIN = ""; confirmPIN = ""
                        } else {
                            message = "PIN change failed."
                        }
                    }
                    Text(message).foregroundStyle(message.contains("success") ? .green : .red)
                }

                Section("App") {
                    LabeledContent("Currency", value: "Euro (€)")
                    LabeledContent("Version", value: "1.0")
                }

                Section {
                    Button("Lock App") {
                        store.isUnlocked = false
                    }
                    .foregroundStyle(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .background(JMATheme.bg)
            .navigationTitle("Settings")
        }
    }
}
