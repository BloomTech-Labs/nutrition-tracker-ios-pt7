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
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.07), style: StrokeStyle(lineWidth: 9))
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: showCaloriesStroke ? 0.1 : 0.99, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "nutrivurv-blue")!).opacity(0.6), Color(UIColor(named: "nutrivurv-blue")!)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: 100, height: 100)
                .shadow(color: Color(UIColor(named: "nutrivurv-blue")!).opacity(0.25), radius: 3, x: 0, y: 3)
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
