//
//  DisplayView.swift
//  Jia Jie's DCA Calculator
//
//  Created by Jia Jie Chan on 5/10/21.
//

import Foundation
import SwiftUI
import Combine

struct LineGraphView: View {
    
    @EnvironmentObject var viewModel: GraphViewModel
    @Binding var mode: Mode
    @State var graphPoints: [CGPoint] = []
    @State var path = Path()
    let g1: Color = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    let g2: Color = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    let g3: Color = Color(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    @State var area = Path()
    @State var spec: Specifications<Double> = .init(count: 0, type: .line(zero: false), title: "", height: 0, width: 0, padding: 0, max: 0, min: 0)
    @ViewBuilder var body: some View {
        let zeroPosition = YFactory.getZeroPosition(spec: .init(count: viewModel.results.count, type: .line(zero: true), title: "gain", height: viewModel.height, width: viewModel.width, padding: viewModel.padding, max: viewModel.meta!.maxGain, min: viewModel.meta!.minGain))
        ZStack {
            if true {
            let redGradient = LinearGradient(gradient: .init(colors: [g3, .white]), startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: zeroPosition / viewModel.height))
            let blueGradient = LinearGradient(gradient: .init(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
        blueGradient
            .opacity(1)
            .mask(area)
            .frame(width: viewModel.width, height: zeroPosition)
            .clipped()
            .position(x: (viewModel.width / 2), y: zeroPosition - (zeroPosition * 0.5))
        redGradient
            .mask(
        Color.white
            .opacity(1)
            .mask(area)
            .offset(y: -1 * zeroPosition)
            .frame(width: viewModel.width, height: viewModel.height - zeroPosition)
            .clipped()
            .offset(y: zeroPosition * 0.5)
                )
              
        path
            .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            .fill(
                LinearGradient(gradient: .init(colors: [g1, g2]), startPoint: .leading, endPoint: .trailing))
            .overlay(IndicatorView(mode: $mode, graphPoints: $graphPoints, spec: $spec)
                        .environmentObject(viewModel))
            .foregroundColor(Color.blue)
        }
        }
        .onAppear {
            generatePath()
        }
        .onChange(of: mode) { value in
            generatePath()
        }
        .onChange(of: viewModel.id) { value in
            generatePath()
        }
    }
    
    private func generatePath() {
        let spec: Specifications<Double> = .init(count: viewModel.results.count, type: .line(zero: true), title: "gain", height: viewModel.height, width: viewModel.width, padding: viewModel.padding, max: viewModel.meta!.maxGain, min: viewModel.meta!.minGain)
        let render = ChartLibraryGeneric.render(data: viewModel.results, setItemsToPlot: [
            \DCAResult.gain : spec
        ])
        self.area = render.lines["gain"]!.area
//        self.graphPoints = render.bars["gain"].points
        self.path = render.lines["gain"]!.path
        self.spec = spec
        self.graphPoints = render.lines["gain"]!.points
        
    }
}
    

struct ZeroLineView: View {
    
    @EnvironmentObject var viewModel: GraphViewModel
    @Binding var mode: Mode
    
    var minY: Double {
        viewModel.meta!.mode(mode: mode, min: true)
    }
    
    @ViewBuilder var body: some View {
        if viewModel.results.count >= 1 && viewModel.meta != nil {
    
        GeometryReader { geometry in
            Path { path in
                let spec: Specifications<Double> = .init(count: viewModel.results.count, type: .line(zero: true), title: "gain", height: viewModel.height, width: viewModel.width, padding: viewModel.padding, max: viewModel.meta!.maxGain, min: viewModel.meta!.minGain)
                let zeroPosition = YFactory.getZeroPosition(spec: spec)
                
                //MARK: ZERO POSITION
                path.move(to: CGPoint(x: spec.padding, y: zeroPosition))
                path.addLine(to: CGPoint(x: viewModel.width - spec.padding
                                         , y: zeroPosition))
            }
            .stroke(minY < 0 ? Color.gray.opacity(0.3) : Color.gray.opacity(1.0), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    }
}