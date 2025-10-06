//
//  TransactionDetailsView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI

struct TransactionDetailsView: View {
    var id: UUID
    var goBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Details: \(id.uuidString)")
            Button("Go back") { goBack() }
        }
    }
}
