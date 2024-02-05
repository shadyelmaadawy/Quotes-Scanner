//
//  VisionService.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 05/02/2024.
//

import UIKit
import Vision
import Foundation

final class VisionService {
    
    // MARK: - Enums
    
    private enum visionErrorCodes: Error {
        case invalidTextObservation
        case invalidCGImage
        
    }

    // MARK: - I am keeping my word, as always.
    func extractFromImage(imageBuffer: Data) async throws -> String {
        
        return try await withCheckedThrowingContinuation { continuationThrowing in
            
            let recognizeTextRequest = VNRecognizeTextRequest.init { recognizeRequest, requestError in
                
                guard let textObservation = recognizeRequest.results as? [VNRecognizedTextObservation],
                      textObservation.isEmpty == false else {
                    
                    continuationThrowing.resume(throwing: visionErrorCodes.invalidTextObservation)
                    return
                    
                }

                guard requestError == nil else {
                    
                    continuationThrowing.resume(throwing: requestError!)
                    return

                }
                let extractedText = textObservation.compactMap({
                    
                    guard $0.confidence > 0.00,
                          let textBuffer = $0.topCandidates(1).first?.string,
                          textBuffer.count > 0 else {
                        return nil
                    }
                    
                    return textBuffer
                    
                }).joined(separator: "\n")
                continuationThrowing.resume(returning: extractedText)
            }
            recognizeTextRequest.usesLanguageCorrection = false
            recognizeTextRequest.revision = VNRecognizeTextRequestRevision3
            recognizeTextRequest.recognitionLevel = VNRequestTextRecognitionLevel.accurate

            guard let imageWithText = UIImage.init(data: imageBuffer), let cgImage = imageWithText.cgImage else {
                continuationThrowing.resume(throwing: visionErrorCodes.invalidCGImage)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    
                    try VNImageRequestHandler.init(cgImage: cgImage).perform([
                        recognizeTextRequest
                    ])
                    
                } catch {
                    
                    continuationThrowing.resume(throwing: error)
                    
                }
                
            }
        }

    }
}
