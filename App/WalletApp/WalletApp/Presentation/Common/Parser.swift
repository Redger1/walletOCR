//
//  Parser.swift
//  WalletApp
//
//  Created by Артем on 07.10.2025.
//
import Foundation

struct Parser {
    static func parseDecimal(_ s: String, locale: Locale = .current) -> Decimal? {
        let allowed = CharacterSet(charactersIn: "0123456789.,-")
        let filtered = s.unicodeScalars.filter { allowed.contains($0) }
        let raw = String(String.UnicodeScalarView(filtered))
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // пусто или просто "-" — невалидно
        guard !raw.isEmpty, raw != "-", raw != "." else { return nil }
        
        if let d = Decimal(string: raw, locale: Locale(identifier: "en_US_POSIX")) {
            return d
        }
        
        let nf = NumberFormatter()
        nf.locale = locale
        nf.generatesDecimalNumbers = true
        nf.numberStyle = .decimal
        if let num = nf.number(from: raw) as? NSDecimalNumber {
            return num as Decimal
        }
        return nil
    }
}
