//
//  Currency.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct Currency: Codable, Hashable, Sendable {
    public let code: String
    public let symbol: String
    public let fractionDigits: Int
    
    public init(code: String, symbol: String, fractionDigits: Int = 2) {
        self.code = code
        self.symbol = symbol
        self.fractionDigits = fractionDigits
    }
    
    public static let rub = Currency(code: "RUB", symbol: "₽")
}
