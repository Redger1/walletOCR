//
//  Nuke.swift
//  WalletApp
//
//  Created by Артем on 13.10.2025.
//
import Foundation
import SwiftData

enum StoreNuke {
    static func reset() {
        #if DEBUG
        let fm = FileManager.default
        if let url = try? fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("default.store") {
            try? fm.removeItem(at: url)
            print("Store nuked:", url.path())
        }
        #endif
    }
}
