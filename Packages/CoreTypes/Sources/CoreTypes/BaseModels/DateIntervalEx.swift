//
//  DateIntervalEx.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public struct DateIntervalEx: Codable, Hashable, Sendable {
    public let start: Date
    public let end: Date
    
    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    public var duration: TimeInterval { end.timeIntervalSince(start) }
    public func contains(_ date: Date) -> Bool { (start...end).contains(date) }
}
