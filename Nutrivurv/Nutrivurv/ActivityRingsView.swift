//
//  ActivityRingsView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ActivityRingsView: View {
    @State var showRings = false
    @State var showMacrosDetail = false
    
    var caloriesColor = UIColor(named: "nutrivurv-blue")!
    var caloriesCount: CGFloat = 1734
    var caloriesPercent: CGFloat = 76
    
    var carbsColor = UIColor(named: "nutrivurv-green-2")!
    var carbsCount: CGFloat = 180
    var carbsPercent: CGFloat = 88
    
    var proteinColor = UIColor(named: "nutrivurv-orange")!
    var proteinCount: CGFloat = 92
    var proteinPercent: CGFloat = 54
    
    var fatColor = UIColor(named: "nutrivurv-red-2")!
    var fatCount: CGFloat = 47
    var fatPercent: CGFloat = 68
    
    
    var body: some View {
        ZStack {
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: caloriesColor, width: 120, height: 120, percent: caloriesPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: carbsColor, width: 95.6, height: 95.6, percent: carbsPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: proteinColor, width: 75.84, height: 75.84, percent: proteinPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: fatColor, width: 59.53, height: 59.53, percent: fatPercent)
            
            HStack {
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: caloriesColor, label: "Calories", count: "\(Int(caloriesCount)) cal", percent: "\(Int(caloriesPercent))%")
                        .offset(x: showRings ? -60 : -40).animation(.easeInOut)
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: carbsColor, label: "Carbs", count: "\(Int(carbsCount))g", percent: "\(Int(carbsPercent))%")
                        .offset(x: showRings ? -70 : -28).animation(.easeInOut)
                    
                }.offset(y: -20)
                
                
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: proteinColor, label: "Protein", count: "\(Int(proteinCount))g", percent: "\(Int(proteinPercent))%")
                        .offset(x: showRings ? 60 : 40).animation(.easeInOut)
                        
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: fatColor, label: "Fat", count: "\(Int(fatCount))g", percent: "\(Int(fatPercent))%")
                        .offset(x: showRings ? 70 : 28).animation(.easeInOut)
                    
                }.offset(y: -20)
                
            }
        }
    }
}

struct ActivityRingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingsView()
    }
}


struct RingView: View {
    @Binding var showRings: Bool
    @Binding var showMacrosDetail: Bool
    
    var uiColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var percent: CGFloat
    
    var ringAnimation = Animation.easeInOut(duration: 0.8).delay(0.25)
    
    var body: some View {
        let multiplier = width / 100
        var progress = 1 - percent / 100
        
        if percent > 100 {
            progress = 0
        }
        
//        var complete: Bool = false
//
//        if percent >= 100 {
//            complete = true
//            progress = 1 - (percent - 100) / 100
//        }
        
        return ZStack {
            Circle()
//                .stroke(complete ? Color(uiColor).opacity(show ? 0.8 : 0.25) : Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 9 * multiplier)).grayscale(0.4).brightness(0.09)
                .stroke(Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 9 * multiplier)).grayscale(0.4).brightness(0.09)
                .frame(width: width - 1 * multiplier, height: height - 1 * multiplier)
                .onTapGesture {
                    self.showRings.toggle()
                    self.showMacrosDetail.toggle()
            }
            
            Circle()
                .trim(from: showRings ? progress : 0.999, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(uiColor).opacity(0.45), Color(uiColor)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 10 * multiplier, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: width, height: height)
//                .shadow(color: complete ? Color(uiColor).opacity(0.6) : Color(uiColor).opacity(0.3), radius: 3 * multiplier, x: 2 * multiplier, y: -3 * multiplier)
                .shadow(color: Color(uiColor).opacity(0.3), radius: 3 * multiplier, x: 2 * multiplier, y: 3 * multiplier)
                .animateRing(using: ringAnimation) {
                    self.showRings = true
                    self.showMacrosDetail = false
            }
            .animation(ringAnimation)
            .onTapGesture {
                self.showRings.toggle()
                self.showMacrosDetail.toggle()
            }
        }
    }
}


struct MacrosDetailView: View {
    @Binding var showMacrosDetail: Bool
    @Binding var showRings: Bool
    
    var uiColor: UIColor
    var label: String
    var count: String
    var percent: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(Color(uiColor).opacity(showMacrosDetail ? 0.95 : 0.85))
                .frame(width: showMacrosDetail ? 108 : 60, height: showMacrosDetail ? 40 : 15)
                .shadow(color: showMacrosDetail ? Color(uiColor).opacity(0.2) : Color.clear, radius: showMacrosDetail ? 3.5 : 0, x: 0, y: showMacrosDetail ? 4 : 0)
            
            VStack {
                Text(label)
                    .font(Font.custom("Muli-Bold", size: 10))
                    .foregroundColor(Color.white)
                
                if self.showMacrosDetail {
                    Text("\(count) • \(percent)")
                        .font(Font.custom("Muli-MediumItalic", size: 12.0))
                        .foregroundColor(Color.white)
                }
            }
        }.onTapGesture {
            self.showMacrosDetail.toggle()
            self.showRings.toggle()
        }
    }
}


extension View {
    func animateRing(using animation: Animation, _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}
