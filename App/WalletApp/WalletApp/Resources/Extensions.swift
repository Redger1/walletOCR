//
//  Extensions.swift
//  WalletApp
//
//  Created by Артем on 21.10.2025.
//
import SwiftUI

struct CapsuleBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func capsuleBackground() -> some View {
        modifier(CapsuleBackground())
    }
}
