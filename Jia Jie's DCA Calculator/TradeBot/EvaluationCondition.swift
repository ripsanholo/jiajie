//
//  EvaluationCondition.swift
//  Jia Jie's DCA Calculator
//
//  Created by Jia Jie Chan on 21/12/21.
//

import Foundation
import CloudKit

struct EvaluationCondition: CloudKitInterchangeable, CloudChild {
    
    init?(record: CKRecord) {
        let technicalIndicatorRawValue = record["technicalIndicator"] as! Double
        let aboveOrBelowRawValue = record["aboveOrBelow"] as! Int
        let enterOrExitRawValue = record["enterOrExit"] as! Int
        
        self.technicalIndicator = TechnicalIndicators.build(rawValue: technicalIndicatorRawValue)
        self.aboveOrBelow = AboveOrBelow(rawValue: aboveOrBelowRawValue)!
        self.enterOrExit = EnterOrExit(rawValue: enterOrExitRawValue)!
        self.record = record
    }
    
    init?(technicalIndicator: TechnicalIndicators, aboveOrBelow: AboveOrBelow, enterOrExit: EnterOrExit, andCondition: [EvaluationCondition]) {
        let record = CKRecord(recordType: "EvaluationCondition")
                record.setValuesForKeys([
                    "technicalIndicator": technicalIndicator.rawValue,
                    "aboveOrBelow": aboveOrBelow.rawValue,
                    "enterOrExit": enterOrExit.rawValue,
                ])
        self.init(record: record)
        self.andCondition = andCondition
    }
    
    var record: CKRecord
    
    func update(newCondition: EvaluationCondition) -> EvaluationCondition {
        let record = self.record
        //DO STUFF WITH THE RECORD
        record.setValuesForKeys([
            "technicalIndicator" : newCondition.technicalIndicator.rawValue,
            "aboveOrBelow" : newCondition.aboveOrBelow.rawValue,
            "enterOrExit" : newCondition.enterOrExit.rawValue
        ])
        
        return EvaluationCondition(record: record)!
    }
    
    var technicalIndicator: TechnicalIndicators
    let aboveOrBelow: AboveOrBelow
    let enterOrExit: EnterOrExit
    var andCondition: [EvaluationCondition] = []
 
    var validationMessage: String {
        switch self.technicalIndicator {
        case .movingAverage:
            return "Condition clash: Set ticker \(aboveOrBelow.opposingDescription) indicator."
        case .bollingerBands(percentage: let percentage):
            return "Condition clash: Set ticker \(aboveOrBelow.opposingDescription) indicator and \(aboveOrBelow.opposingDescription) \((percentage * 100).zeroDecimalPlaceString)% threshold."
        case .RSI(_, let percentage):
            return "Condition clash: Set ticker \(aboveOrBelow.opposingDescription) indicator and \(aboveOrBelow.opposingDescription) \((percentage * 100).zeroDecimalPlaceString)% threshold."
        case .lossTarget:
            return ""
        case .profitTarget:
            return ""
        case .holdingPeriod:
            return ""
        case .movingAverageOperation(period1: let period1, period2: let period2):
            return ""
        }
    }
}
