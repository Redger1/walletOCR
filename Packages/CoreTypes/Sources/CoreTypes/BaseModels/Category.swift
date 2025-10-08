//
//  Category.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public enum CategoryKind: String, CaseIterable, Codable, Sendable {
    case food
    case transfer
    case health
    case entertainment
    case other
    
    public var iconName: String {
        switch self {
            case .entertainment: "gamecontroller"
            case .food: "fork.knife"
            case .health: "stethoscope"
            case .transfer: "arrow.down.left.arrow.up.right"
            case .other: "cart"
        }
    }
    
    public var title: String {
        switch self {
            case .food: "Еда"
            case .entertainment: "Развлечения"
            case .health: "Здоровье"
            case .transfer: "Перевод"
            case .other: "Другое"
        }
    }
}
