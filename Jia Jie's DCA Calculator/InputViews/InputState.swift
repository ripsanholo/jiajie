//
//  InputState.swift
//  Jia Jie's DCA Calculator
//
//  Created by Jia Jie Chan on 7/1/22.
//

import Foundation
import SwiftUI

class InputState: ObservableObject {
    private static var window: [Int] = [20, 50, 100, 200]
    private static var position: [AboveOrBelow] = [.priceAbove, .priceBelow]
    
    @Published var selectedWindowIdx: Int = 0 { didSet {
//        Log.queue(action: "selected window: \(selectedWindowIdx)")
    }}
    
    @Published var anotherSelectedWindowIdx: Int = 0 { didSet {
//        Log.queue(action: "selected window: \(selectedWindowIdx)")
    }}
    
    @Published var selectedPositionIdx: Int = 0 { didSet {
//        validationState = updateValidationState()
    }}
    @Published var selectedPercentage: Double = 0 { didSet {
//        Log.queue(action: "selected percentage: \(selectedPercentage)")
//        validationState = updateValidationState()
    }}
    
    @Published var stepperValue: Int = 2
    
    func getWindow() -> Int {
        return InputState.window[selectedWindowIdx]
    }
    
    func getAnotherWindow() -> Int {
        return InputState.window[anotherSelectedWindowIdx]
    }
    
    func getPosition() -> AboveOrBelow {
        return InputState.position[selectedPositionIdx]
    }
    
    func getIndex(window: Int) -> Int? {
        return InputState.window.firstIndex(of: window)
    }
    
    func set(selectedWindowIdx: Int? = nil, anotherSelectedWindowIdx: Int? = nil, selectedPositionIdx: Int? = nil, selectedPercentage: Double? = nil, stepperValue: Int? = nil) {
        if let selectedPercentage = selectedPercentage {
            self.selectedPercentage = selectedPercentage
        }
        
        if let selectedWindowIdx = selectedWindowIdx {
            self.selectedWindowIdx = selectedWindowIdx
        }
        
        if let stepperValue = stepperValue {
            self.stepperValue = stepperValue
        }
        
        if let selectedWindowIdx = selectedWindowIdx {
            self.selectedWindowIdx = selectedWindowIdx
        }
        
        if let selectedPositionIdx = selectedPositionIdx {
            self.selectedPositionIdx = selectedPositionIdx
        }
        
    }
    
    func reset() {
        selectedWindowIdx = 0
        selectedPercentage = 0
        selectedPositionIdx = 0
        anotherSelectedWindowIdx = 0
        stepperValue = 2
    }
}