//
//  BaseTextField.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 18/01/2024.
//

import SwiftUI

struct BaseTextField: View {
    
    // MARK: - Properties
    
    @Binding private var textValue: String
    private let textLabel: String
    
    // MARK: - Initialization

    init(_ textValue: Binding<String>, textLabel: String) {
        self._textValue = textValue
        self.textLabel = textLabel
    }
    
    var body: some View {
        
        TextField.init(text: $textValue, label: {
            Text(self.textLabel)
        })
        .frame(maxWidth: .infinity)
        .padding(.all, 12.00)
        .overlay {
            RoundedRectangle(cornerRadius: 6.00)
                .stroke(Color.accentColor.opacity(0.8))
        }
        .textFieldStyle(.plain)
        .disabled(true)
        
    }
}
