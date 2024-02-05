//
//  Image+Ext.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 18/01/2024.
//

import SwiftUI

extension Image {
    
    // MARK: - Enums
    
    enum BaseImages: String {
        case copyButton = "doc.text"
    }
    
}

// MARK: - Operations

extension Image {
    
    /// Create Image Instance from system
    /// - Parameter imageBaseName: base image name in system
    /// - Returns: return created image
    static func createImage(_ imageBaseName: BaseImages) -> Image {
        return Image.init(systemName: imageBaseName.rawValue)
    }

}
