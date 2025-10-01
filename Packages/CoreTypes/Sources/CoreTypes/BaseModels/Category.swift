//
//  Category.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct Category: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var iconName: String
    
    public init(name: String, iconName: String) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
    }
}
