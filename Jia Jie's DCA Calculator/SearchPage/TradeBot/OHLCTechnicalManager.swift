//
//  OHLCTechnicalManager.swift
//  Jia Jie's DCA Calculator
//
//  Created by Jia Jie Chan on 9/12/21.
//

import Foundation
class OHLCTechnicalManager {
    
    let window: Int
    
    init(window: Int) {
        self.window = window
        self.movingAverageCalculator = .init(window: window)
        self.bollingerBandsCalculator = .init(window: window)
    }
    
    var movingAverageCalculator: SimpleMovingAverageCalculator
    var bollingerBandsCalculator: BollingerBandCalculator
    var rsiCalculator: RSICalculator?
    
    func addOHLCCloudElement(key: String, value: TimeSeriesDaily) -> OHLCCloudElement {
        let open = Double(value.open)!
        let high = Double(value.high)!
        let low = Double(value.low)!
        let close = Double(value.close)!
        let stamp: String = key
        let adjustedClose: Double = Double(value.adjustedClose)!
        let volume: Double = Double(value.volume)!
        let dividendAmount: Double = Double(value.dividendAmount)!
        let splitCoefficient: Double = Double(value.splitCoefficient)!
        
        
        //MARK: TECHNICAL INDICATORS
        if rsiCalculator == nil { rsiCalculator = .init(period: 14, indexData: close) }
        let movingAverage = movingAverageCalculator.generate(indexData: close)
        let bollingerBand = bollingerBandsCalculator.generate(indexData: close)
        let rsi = rsiCalculator!.generate(indexData: close)
        
        let element: OHLCCloudElement = .init(stamp: stamp, open: open, high: high, low: low, close: close, adjustedClose: adjustedClose, volume: volume, dividendAmount: dividendAmount, splitCoefficient: splitCoefficient, percentageChange: nil, RSI: rsi.relativeStrengthIndex, movingAverage: movingAverage, standardDeviation: bollingerBand.standardDeviation, upperBollingerBand: bollingerBand.upperBollingerBand, lowerBollingerBand: bollingerBand.lowerBollingerBand)
        return element
        
    }
}