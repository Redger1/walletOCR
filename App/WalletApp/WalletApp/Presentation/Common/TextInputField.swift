//
//  TextInputField.swift
//  WalletApp
//
//  Created by Артем on 07.10.2025.
//
import Foundation
import SwiftUI

struct TextInputField: View {
    var placeholder: String
    @Binding var value: String
    var ignoreSubmit: Bool
    @FocusState private var isInputActive: Bool
    
    init(_ placeholder: String, value: Binding<String>) {
        self.placeholder = placeholder
        self._value = value
        self.ignoreSubmit = false
    }
    
    var body: some View {
        TextField(placeholder, text: $value)
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .focused($isInputActive)
            .onSubmit {
                if !ignoreSubmit { isInputActive = false }
            }
    }
}
