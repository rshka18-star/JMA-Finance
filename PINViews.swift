
import SwiftUI

struct PINView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var pin = ""
    @State private var error = false

    var body: some View {
        ZStack {
            JMATheme.bg.ignoresSafeArea()
            VStack(spacing: 26) {
                Spacer()
                JMALogoView()
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 58))
                    .foregroundStyle(.cyan)
                    .shadow(color: .cyan.opacity(0.7), radius: 15)
                Text("Enter PIN")
                    .font(.title2.bold())

                HStack(spacing: 16) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i < pin.count ? Color.cyan : Color.clear)
                            .frame(width: 16, height: 16)
                            .overlay(Circle().stroke(.cyan, lineWidth: 2))
                    }
                }

                keypad
                if error {
                    Text("PIN-ka waa khalad.")
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding()
        }
    }

    private var keypad: some View {
        VStack(spacing: 14) {
            ForEach([[1,2,3],[4,5,6],[7,8,9]], id: \.self) { row in
                HStack(spacing: 18) {
                    ForEach(row, id: \.self) { number in
                        key("\(number)")
                    }
                }
            }
            HStack(spacing: 18) {
                Button { pin = "" } label: {
                    Image(systemName: "xmark.circle").font(.title2)
                }.frame(width: 72, height: 58)
                key("0")
                Button {
                    if !pin.isEmpty { pin.removeLast() }
                } label: {
                    Image(systemName: "delete.left").font(.title2)
                }.frame(width: 72, height: 58)
            }
        }
    }

    private func key(_ text: String) -> some View {
        Button {
            guard pin.count < 4 else { return }
            pin += text
            if pin.count == 4 {
                if store.verifyPIN(pin) {
                    error = false
                    store.isUnlocked = true
                } else {
                    error = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { pin = "" }
                }
            }
        } label: {
            Text(text).font(.title2.bold())
                .frame(width: 72, height: 58)
                .background(Circle().fill(JMATheme.panel))
        }
        .buttonStyle(.plain)
    }
}

struct CreatePINView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var pin = ""
    @State private var confirm = ""
    @State private var message = ""

    var body: some View {
        ZStack {
            JMATheme.bg.ignoresSafeArea()
            VStack(spacing: 22) {
                JMALogoView()
                Text("Create 4-digit PIN").font(.title2.bold())

                SecureField("PIN", text: $pin)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm PIN", text: $confirm)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button("Save PIN") {
                    if pin.count == 4 && pin.allSatisfy(\.isNumber) && pin == confirm {
                        store.setPIN(pin)
                        store.isUnlocked = true
                    } else {
                        message = "Geli 4 lambar oo isku mid ah."
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)

                Text(message).foregroundStyle(.red)
            }
            .padding(32)
        }
    }
}
