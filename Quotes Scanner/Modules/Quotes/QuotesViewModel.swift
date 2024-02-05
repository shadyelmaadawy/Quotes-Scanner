//
//  QuotesViewModel.swift
//  Quotes Scanner
//
//  Created by Shady El-Maadawy on 05/02/2024.
//

import Combine
import Foundation

// MARK: - Not the best I know do not worry.
final class QuotesViewModel: ObservableObject {
    
    // MARK: - Enums
    
    enum ViewStates {
        case initial
        case imageSelected
        case isLoading
        case textIsReady
    }
    
    enum ViewEvents {
        case imageSelected(imageBuffer: Data)
        case extractEventRaised
        case copyClicked
    }
    
    // MARK: - Properties
    
    public lazy var subscriptions: Set<AnyCancellable> = {
        return Set<AnyCancellable>()
    }()
    
    var visionText: AnyPublisher<String, Never> {
        return visionTextSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    var viewState: AnyPublisher<ViewStates, Never> {
        return currentState
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private let visionTextSubject = PassthroughSubject<String, Never>()
    private let currentState = PassthroughSubject<ViewStates, Never>()
    let eventsStream = PassthroughSubject<ViewEvents, Never>()
    private let visionService: VisionService
    private var imageData: Data = .init()
    
    // MARK: - Initialization
    
    init(visionService: VisionService = VisionService.init()) {
        self.visionService = visionService
        self.bindInputs()
    }
    
    // MARK: - Object Life Cycle;
    
    deinit {
        
        subscriptions.forEach({$0.cancel()})
        subscriptions.removeAll()
        
    }

}

// MARK: - Data Binding

private extension QuotesViewModel {
    
    func bindInputs() {
        
        eventsStream.sink { [weak self] event in
            
            guard let self = self else {
                return
            }
            
            switch(event) {
                
                case.imageSelected(let imageBuffer):
                
                    self.imageData = imageBuffer
                    self.currentState.send(.imageSelected)

                case .extractEventRaised:
                
                    self.currentState.send(.isLoading)
                
                    Task.init {
                        
                        guard let value = try? await self.visionService.extractFromImage(imageBuffer: self.imageData) else {
                            
                            self.imageData = .init()
                            self.currentState.send(.initial)
                            
                            return
                            
                        }
                        
                        self.imageData = .init()

                        self.currentState.send(.textIsReady)
                        self.visionTextSubject.send(value)

                    }
                
                case .copyClicked:
                    
                    self.visionTextSubject.send("")
                    self.currentState.send(.initial)
            }
        }
        .store(in: &subscriptions)
        
    }
    
}

