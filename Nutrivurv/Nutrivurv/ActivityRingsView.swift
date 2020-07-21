//
//  ActivityRingsView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ActivityRingsView: View {
    @State private var showCaloriesStroke = false
    @State private var showCarbsStroke = false
    @State private var showProteinsStroke = false
    @State private var showFatsStroke = false
    
    var uiColor = UIColor(named: "nutrivurv-blue")!
    var width: CGFloat = 100
    var height: CGFloat = 100
    var percent: CGFloat = 88
    
    
    var body: some View {
        let multiplier = width / 100
        let progress = 1 - percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.07), style: StrokeStyle(lineWidth: 9 * multiplier))
                .frame(width: width - 1 * multiplier, height: height - 1 * multiplier)
                .onTapGesture {
                    self.showCaloriesStroke.toggle()
                }
            
            Circle()
                .trim(from: showCaloriesStroke ? progress : 0.99, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(uiColor).opacity(0.6), Color(uiColor)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 10 * multiplier, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: width, height: height)
                .shadow(color: Color(uiColor).opacity(0.25), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
                .animation(.easeOut)
                .onTapGesture {
                    self.showCaloriesStroke.toggle()
            }
        }
    }
}

struct ActivityRingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingsView()
    }
}
