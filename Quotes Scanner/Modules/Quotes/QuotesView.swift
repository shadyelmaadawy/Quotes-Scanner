//
//  QuotesView.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 18/01/2024.
//

import SwiftUI
import PhotosUI
import SwiftUIGIF

struct QuotesView: View {
    
    @StateObject private var viewModel = QuotesViewModel.init()
    @State var textValue: String = .init()
    @State private var currentState: QuotesViewModel.ViewStates = .initial
    @State private var selectedQuote: PhotosPickerItem? = nil
    @State private var showPicker: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                HStack {
                    
                    BaseTextField.init(
                        $textValue, textLabel: "Quote Full-Text"
                    )

                    BaseImageButton.init(.copyButton) {
                        
                        self.viewModel.eventsStream.send(.copyClicked)
                        UIPasteboard.general.string = self.textValue
                    }
                    .disabled(currentState != .textIsReady)
                    
                }
                .padding(.horizontal, 12.00)
                
                HStack {
                    
                    BaseButton.init("Select Image") {
                        showPicker.toggle()
                    }
                    .disabled(currentState != .initial)
                    
                    BaseButton.init("Extract") {
                        
                        self.viewModel.eventsStream.send(.extractEventRaised)

                    }
                    .disabled(currentState != .imageSelected)


                }
                .padding(.horizontal, 12.00)
                .padding(.vertical, 12.00)
            }
            .disabled(currentState == .isLoading)
            .opacity(currentState == .isLoading ? 0.50 : 1.00)

            GIFImage.init(name: "Itsmagic")
                .frame(width: 200, height: 150)
                .clipShape(Circle.init())
                .disabled(currentState == .isLoading)
                .opacity(currentState == .isLoading ? 1.00 : 0.00)

        }
        .onChange(of: selectedQuote) { _, _ in
            
            Task.init    {

                if let quoteData = try? await selectedQuote?.loadTransferable(type: Data.self) {
                    self.viewModel.eventsStream.send(.imageSelected(imageBuffer: quoteData))
                }
                
            }

        }
        .photosPicker(isPresented: $showPicker, selection: $selectedQuote)
        .onReceive(self.viewModel.visionText, perform: { value in
            
            self.textValue = value
            
        })
        .onReceive(self.viewModel.viewState, perform: { value in
            
            self.currentState = value

            if(self.currentState == .initial) {
                self.selectedQuote = nil
            }
            
        })
    }
    
}
