
import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: FinanceStore

    var body: some View {
        Group {
            if !store.hasPIN {
                CreatePINView()
            } else if !store.isUnlocked {
                PINView()
            } else {
                MainTabView()
            }
        }
    }
}
