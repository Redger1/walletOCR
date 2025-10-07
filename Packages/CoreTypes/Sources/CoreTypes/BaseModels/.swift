//
//  Merchant.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct Merchant: Identifiable, Hashable, Sendable, Codable {
    public let id: UUID
    public var name: String
    
    public init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
