//
//  Money.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct Money: Codable, Hashable, Sendable {
    public let value: Decimal
    public let currency: Currency
    
    public init(value: Decimal, currency: Currency) {
        self.value = value
        self.currency = currency
    }
    
    // Релаизовать метод округления вверх
    public func ronded() -> Int {
        return 0
    }
}
