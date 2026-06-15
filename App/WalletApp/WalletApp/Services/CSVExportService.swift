import CoreTypes
import Foundation

protocol CSVExportServiceProtocol {
    func createCSVFromTransactions(_ transactions: [TransactionItem]) -> String
    func createCSVFile(_ transactions: [TransactionItem]) throws -> URL
}

final class CSVExportService: CSVExportServiceProtocol {
    func createCSVFromTransactions(_ transactions: [TransactionItem]) -> String {
        var rows: [String] = []
        rows.append("date,amount,currency,category,merchant,paymentMethod,status,note")
        
        let dateFormatter = ISO8601DateFormatter()
        
        for t in transactions {
            let dateCSV = escape(dateFormatter.string(from: t.date))
            let amountCSV = escape(t.total.value.description)
            let currencyCSV = escape(t.total.currency.code)
            let categoryCSV = escape(t.categoryKind.title)
            let merchantCSV = escape(t.merchant ?? "")
            let paymentMethodCSV = escape(t.paymentMethod?.title ?? "")
            let statusCSV = escape(t.status?.title ?? "")
            let noteCSV = escape(t.note ?? "")
            
            rows.append("\(dateCSV),\(amountCSV),\(currencyCSV),\(categoryCSV),\(merchantCSV),\(paymentMethodCSV),\(statusCSV),\(noteCSV)")
        }
        
        return rows.joined(separator: "\n")
    }
    
    func createCSVFile(_ transactions: [TransactionItem]) throws -> URL {
        let csvString: String = createCSVFromTransactions(transactions)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = dateFormatter.string(from: Date())
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walletOCR-transactions-\(now).csv")
        
        guard let data = csvString.data(using: .utf8) else {
            throw CSVExportErrors.encodingFailed
        }
        
        try data.write(to: url, options: [.atomic])
        return url
    }
    
    private func escape(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
}
