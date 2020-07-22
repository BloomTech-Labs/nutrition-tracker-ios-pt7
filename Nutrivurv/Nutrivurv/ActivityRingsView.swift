//
//  ActivityRingsView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ActivityRingsView: View {
    @State var showCaloriesStroke = false
    @State var showCarbsStroke = false
    @State var showProteinsStroke = false
    @State var showFatsStroke = false
    
    
    var blueColor = UIColor(named: "nutrivurv-blue")!
    var greenColor = UIColor(named: "nutrivurv-green-2")!
    var yellowColor = UIColor(named: "nutrivurv-orange")!
    var redColor = UIColor(named: "nutrivurv-red-2")!
    
    
    var body: some View {
        ZStack {
            RingView(show: $showCaloriesStroke, uiColor: blueColor, width: 120, height: 120, percent: 85).animation(.easeInOut)
            RingView(show: $showCaloriesStroke, uiColor: greenColor, width: 95.6, height: 95.6, percent: 36).animation(.easeInOut)
            RingView(show: $showCaloriesStroke, uiColor: yellowColor, width: 75.84, height: 75.84, percent: 54).animation(.easeInOut)
            RingView(show: $showCaloriesStroke, uiColor: redColor, width: 59.53, height: 59.53, percent: 74).animation(.easeInOut)
        }
    }
}

struct ActivityRingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingsView()
    }
}


struct RingView: View {
    @Binding var show: Bool
    
    var uiColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var percent: CGFloat
    
    var body: some View {
        let multiplier = width / 100
        let progress = 1 - percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 9 * multiplier)).grayscale(0.4).brightness(0.09)
                .frame(width: width - 1 * multiplier, height: height - 1 * multiplier)
                .onTapGesture {
                    self.show.toggle()
                }
            
            Circle()
                .trim(from: show ? progress : 0.999, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(uiColor).opacity(0.5), Color(uiColor)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 10 * multiplier, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: width, height: height)
                .shadow(color: Color(uiColor).opacity(0.25), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
                .onTapGesture {
                    self.show.toggle()
            }
        }
    }
}
