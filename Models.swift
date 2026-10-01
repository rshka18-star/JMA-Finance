
import Foundation
import CryptoKit

enum TransactionKind: String, Codable, CaseIterable {
    case income
    case expense
}

struct FinanceTransaction: Identifiable, Codable, Equatable {
    let id: UUID
    var kind: TransactionKind
    var amount: Double
    var category: String
    var note: String
    var date: Date

    init(id: UUID = UUID(), kind: TransactionKind, amount: Double, category: String, note: String, date: Date = Date()) {
        self.id = id
        self.kind = kind
        self.amount = amount
        self.category = category
        self.note = note
        self.date = date
    }
}

enum PeriodFilter: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"

    var id: String { rawValue }
}

final class FinanceStore: ObservableObject {
    @Published var transactions: [FinanceTransaction] = [] {
        didSet { saveTransactions() }
    }

    @Published var isUnlocked = false
    @Published var period: PeriodFilter = .day

    private let transactionsKey = "jma.transactions.v1"
    private let pinKey = "jma.pin.hash.v1"

    init() {
        loadTransactions()
    }

    var hasPIN: Bool {
        UserDefaults.standard.string(forKey: pinKey) != nil
    }

    func setPIN(_ pin: String) {
        UserDefaults.standard.set(hash(pin), forKey: pinKey)
    }

    func verifyPIN(_ pin: String) -> Bool {
        guard let stored = UserDefaults.standard.string(forKey: pinKey) else { return false }
        return stored == hash(pin)
    }

    func changePIN(old: String, new: String) -> Bool {
        guard verifyPIN(old) else { return false }
        setPIN(new)
        return true
    }

    func add(kind: TransactionKind, amount: Double, category: String, note: String) {
        let item = FinanceTransaction(kind: kind, amount: amount, category: category, note: note)
        transactions.insert(item, at: 0)
    }

    func delete(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
    }

    func delete(id: UUID) {
        transactions.removeAll { $0.id == id }
    }

    var totalIncome: Double {
        transactions.filter { $0.kind == .income }.reduce(0) { $0 + $1.amount }
    }

    var totalExpense: Double {
        transactions.filter { $0.kind == .expense }.reduce(0) { $0 + $1.amount }
    }

    var balance: Double { totalIncome - totalExpense }

    func totals(for filter: PeriodFilter) -> (income: Double, expense: Double, balance: Double) {
        let cal = Calendar.current
        let now = Date()

        let filtered: [FinanceTransaction] = transactions.filter { tx in
            switch filter {
            case .day:
                return cal.isDate(tx.date, inSameDayAs: now)
            case .week:
                guard let interval = cal.dateInterval(of: .weekOfYear, for: now) else { return false }
                return interval.contains(tx.date)
            case .month:
                guard let interval = cal.dateInterval(of: .month, for: now) else { return false }
                return interval.contains(tx.date)
            }
        }

        let income = filtered.filter { $0.kind == .income }.reduce(0) { $0 + $1.amount }
        let expense = filtered.filter { $0.kind == .expense }.reduce(0) { $0 + $1.amount }
        return (income, expense, income - expense)
    }

    private func saveTransactions() {
        do {
            let data = try JSONEncoder().encode(transactions)
            UserDefaults.standard.set(data, forKey: transactionsKey)
        } catch { }
    }

    private func loadTransactions() {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey) else { return }
        do {
            transactions = try JSONDecoder().decode([FinanceTransaction].self, from: data)
        } catch {
            transactions = []
        }
    }

    private func hash(_ pin: String) -> String {
        let salt = "JMA::iPhone::"
        let data = Data((salt + pin).utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

extension Double {
    var euro: String {
        String(format: "€%.2f", self)
    }
}
