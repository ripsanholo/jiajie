//
//  EvaluationTemplate.swift
//  Jia Jie's DCA Calculator
//
//  Created by Jia Jie Chan on 9/1/22.
//

import Foundation

protocol EvaluationState {
    func perform() -> Bool
    func setContext(context: ContextObject)
}

struct ContextObject {
    
    internal init(account: Account, previous: OHLCCloudElement, mostRecent: OHLCCloudElement) {
        self.account = account
        self.previous = previous
        self.mostRecent = mostRecent
    }
    
    var account: Account
    var previous: OHLCCloudElement
    var mostRecent: OHLCCloudElement
}

struct MA_EVState: EvaluationState {
  
    typealias T = Double
    private(set) var context: ContextObject!
    var condition: EvaluationCondition!
    
    func setContext(context: ContextObject) {
        
    }
    
    func perform() -> Bool {
        switch condition.technicalIndicator {
        case .movingAverage(period: let period):
            switch condition.aboveOrBelow {
            case .priceAbove:
                return context.mostRecent.open > context.mostRecent.movingAverage[period]!
            case .priceBelow:
                return context.mostRecent.open < context.mostRecent.movingAverage[period]!
            }
        default:
            fatalError()
        }
    }
}

struct BB_EVState: EvaluationState {
  
    typealias T = Double
    private(set) var context: ContextObject!
    var condition: EvaluationCondition!
    
    func setContext(context: ContextObject) {
       
    }
    
    func perform() -> Bool {
        switch condition.technicalIndicator {
        case .bollingerBands(percentage: let percent):
            switch condition.aboveOrBelow {
            case .priceAbove:
                return context.mostRecent.open > context.mostRecent.valueAtPercent(percent: percent)!
            case .priceBelow:
                return context.mostRecent.open < context.mostRecent.valueAtPercent(percent: percent)!
            }
        default:
            fatalError()
        }
    }
}

struct MAOperation_EVState: EvaluationState {
  
    typealias T = Double
    private(set) var context: ContextObject!
    var condition: EvaluationCondition!
    
    func setContext(context: ContextObject) {
        
    }
    
    func perform() -> Bool {
        switch condition.technicalIndicator {
        case .movingAverageOperation(period1: let p1, period2: let p2):
            switch condition.aboveOrBelow {
            case .priceAbove:
                return context.mostRecent.movingAverage[p1]! > context.mostRecent.movingAverage[p2]!
            case .priceBelow:
                return context.mostRecent.movingAverage[p1]! < context.mostRecent.movingAverage[p2]!
            }
        default:
            fatalError()
        }
    }
}

struct RSI_EVState: EvaluationState {
  
    typealias T = Double
    private(set) var context: ContextObject!
    var condition: EvaluationCondition!
    
    func setContext(context: ContextObject) {
        
    }
    
    func perform() -> Bool {
        switch condition.technicalIndicator {
        case .RSI(period: let period, value: let value):
            switch condition.aboveOrBelow {
            case .priceAbove:
                return context.mostRecent.open > context.mostRecent.RSI[period]!
            case .priceBelow:
                return context.mostRecent.open < context.mostRecent.RSI[period]!
            }
        default:
            fatalError()
        }
    }
}

struct EVStateFactory {
    static func getEVState(condition: EvaluationCondition) -> EvaluationState {
        switch condition.technicalIndicator {
        case .movingAverage(period: let period):
            return MA_EVState()
        case .bollingerBands(percentage: let percentage):
            return MA_EVState()
        case .RSI(period: let period, value: let value):
            return MA_EVState()
        case .lossTarget(value: let value):
            return MA_EVState()
        case .profitTarget(value: let value):
            return MA_EVState()
        case .exitTrigger(value: let value):
            return MA_EVState()
        case .movingAverageOperation(period1: let period1, period2: let period2):
            return MA_EVState()
        }
    }
}

class EvaluationAlgorithm {
    var objectA: EvaluationState!
    
    static private func checkCondition(context: ContextObject, condition: EvaluationCondition) -> Bool {
        var state: EvaluationState = EVStateFactory.getEVState(condition: condition)
        return state.perform()
    }
    
    static func check(context: ContextObject, condition: EvaluationCondition) -> Bool {
        if checkCondition(context: context, condition: condition) {
            for andConditions in condition.andCondition {
                if checkCondition(context: context, condition: andConditions) {
                    continue
                } else {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
}
