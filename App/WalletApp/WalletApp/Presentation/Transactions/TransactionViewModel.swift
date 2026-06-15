import Foundation
import Observation
import CoreTypes

@Observable @MainActor
final class TransactionViewModel {
    private var transactionRepository: TransactionRepository
    private var csvExportService: CSVExportServiceProtocol
    var transactions: [TransactionItem] = []
    var exportURL: URL?
    
    var searchText: String = ""
    var selectedCategory: CategoryKind? = nil
    var selectedPeriod: TransactionPeriodFilter = .all
    
    init(transactionRepository: TransactionRepository, csvExportService: CSVExportServiceProtocol) {
        self.transactionRepository = transactionRepository
        self.csvExportService = csvExportService
    }
    
    func load() async {
        self.transactions = await transactionRepository.fetchAll()
    }
    
    func addTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.add(transaction)
        await load()
    }
    
    func deleteTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.delete(transaction)
        await load()
    }
    
    func updateTransaction(_ transaction: TransactionItem) async {
        await transactionRepository.update(transaction)
        await load()
    }
    
    var sortedTransactions: [TransactionItem] { transactions.sorted { $0.date > $1.date } }
    
    var filteredTransactions: [TransactionItem] {
        sortedTransactions
            .filter(matchesPeriod)
            .filter(matchesCategory)
            .filter(matchesSearch)
    }
    
    var totalSpentMoney: Decimal {
        transactions.reduce(0, { accum, transaction in
            return accum + transaction.total.value
        })
    }
    
    var filteredTotalSpentMoney: Decimal {
        filteredTransactions.reduce(0, {  accum, transaction in
            return accum + transaction.total.value
        })
    }
    
    var isFiltering: Bool {
        selectedPeriod != .all ||
        selectedCategory != nil ||
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func resetFilters() {
        searchText = ""
        selectedPeriod = .all
        selectedCategory = nil
    }
    
    // MARK: - Filter helpers
    private func matchesCategory(_ transaction: TransactionItem) -> Bool {
        guard let selectedCategory else { return true }
        return transaction.categoryKind == selectedCategory
    }
    
    private func matchesPeriod(_ transaction: TransactionItem) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .all:
            return true
        case .currentMonth:
            return calendar.isDate(transaction.date, equalTo: now, toGranularity: .month)
        case .lastWeek:
            guard let startDate = calendar.date(byAdding: .day, value: -7, to: now) else { return true }
            return transaction.date >= startDate && transaction.date <= now
        }
    }
    
    private func matchesSearch(_ transaction: TransactionItem) -> Bool {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard !query.isEmpty else { return true }
        
        let merchant = transaction.merchant?.lowercased() ?? ""
        let category = transaction.categoryKind.title.lowercased()
        let note = transaction.note?.lowercased() ?? ""
        let payment = transaction.paymentMethod?.title.lowercased() ?? ""
        
        return
            merchant.contains(query) ||
            category.contains(query) ||
            note.contains(query) ||
            payment.contains(query)
    }
    
    // MARK: CSV export
    func exportCSV() {
        do {
            exportURL = try csvExportService.createCSVFile(filteredTransactions)
        } catch {
            print("CSV export failed", error)
            exportURL = nil
        }
    }
}
