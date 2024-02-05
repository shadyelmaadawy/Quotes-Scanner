//
//  BaseButton.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 18/01/2024.
//

import SwiftUI

struct BaseButton: View {
    
    // MARK: - Properties
    
    private let buttonText: String
    private let buttonAction: () -> ()
    
    // MARK: - Initialization
    
    init(_ buttonText: String, buttonAction: @escaping () -> Void) {
        self.buttonText = buttonText
        self.buttonAction = buttonAction
    }
    
    
    var body: some View {
        return Button.init(
            action: self.buttonAction, label: {
                Text(self.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.all, 12.00)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
            }
        )
        .backgroundStyle(.accent)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 6.0,
                style: .continuous
            )
        )
        .shadow(color: .accent, radius: 4.00)

    }
}

