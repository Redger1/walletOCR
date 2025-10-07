//
//  Category.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public enum CategoryKind: String, CaseIterable, Codable, Sendable {
    case food = "Еда"
    case transfer = "Перевод"
    case health = "Здоровье"
    case entertainment = "Развлечения"
    case other = "Другое"
    
    public var iconName: String {
        switch self {
            case .entertainment: "gamecontroller"
            case .food: "fork.knife"
            case .health: "stethoscope"
            case .transfer: "arrow.down.left.arrow.up.right"
            case .other: "cart"
        }
    }
    
    public var title: String { self.rawValue }
}
