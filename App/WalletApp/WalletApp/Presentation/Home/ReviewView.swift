//
//  ReviewView.swift
//  WalletApp
//
//  Created by Артем on 06.10.2025.
//
import SwiftUI

struct ReviewView: View {
    var id: UUID
    var goBack: () -> Void
    
    var body: some View {
        VStack {
            Text("ID: \(id.uuidString)")
            Button("Return") { goBack() }
        }
    }
}
