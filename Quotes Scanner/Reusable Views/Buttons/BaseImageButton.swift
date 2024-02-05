//
//  BaseImageButton.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 18/01/2024.
//

import SwiftUI

struct BaseImageButton: View {
    
    // MARK: - Properties

    private let buttonImage: Image.BaseImages
    private let buttonAction: () -> ()
    
    // MARK: - Initialization
    
    init(_ buttonImage: Image.BaseImages, buttonAction: @escaping () -> Void) {
        self.buttonImage = buttonImage
        self.buttonAction = buttonAction
    }
    
    
    var body: some View {
        
        return Button.init(
            action: self.buttonAction, label: {
                Image.createImage(buttonImage)
                    .padding(.all, 12.00)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .font(.callout)
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

