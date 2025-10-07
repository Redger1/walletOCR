//
//  ScanView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI

struct ScanView: View {
    var openReview: () -> Void
    
    var body: some View {
        VStack {
            Button("Симулировать скан") {
                openReview()
            }
        }
    }
}
