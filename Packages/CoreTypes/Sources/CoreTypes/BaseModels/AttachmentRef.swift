//
//  AttachmentRef.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import Foundation

public enum AttachmentRefType: String, Codable, Sendable, Hashable {
    case image, pdf, other
}

public struct AttachmentRef: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var type: AttachmentRefType
    public var url: URL?
    
    public init(type: AttachmentRefType, url: URL? = nil) {
        self.id = UUID()
        self.url = url
        self.type = type
    }
}
