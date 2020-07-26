//
//  ActivityRingsView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ActivityProgressView: View {
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
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: caloriesColor, width: 134.5, height: 134.5, percent: caloriesPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: carbsColor, width: 103, height: 103, percent: carbsPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: proteinColor, width: 71.5, height: 71.5, percent: proteinPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: fatColor, width: 40, height: 40, percent: fatPercent)
            
            HStack {
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: caloriesColor, label: "Calories", count: "\(Int(caloriesCount)) cal", percent: "\(Int(caloriesPercent))%")
                        .offset(x: showRings ? -78 : -50)
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: carbsColor, label: "Carbs", count: "\(Int(carbsCount))g", percent: "\(Int(carbsPercent))%")
                        .offset(x: showRings ? -88 : -38)
                    
                }.offset(y: -20)
                
                
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: proteinColor, label: "Protein", count: "\(Int(proteinCount))g", percent: "\(Int(proteinPercent))%")
                        .offset(x: showRings ? 78 : 50)
                        
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: fatColor, label: "Fat", count: "\(Int(fatCount))g", percent: "\(Int(fatPercent))%")
                        .offset(x: showRings ? 88 : 38)
                    
                }.offset(y: -20)
            }
        }
    }
}

struct ActivityRingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityProgressView()
    }
}


struct RingView: View {
    @Binding var showRings: Bool
    @Binding var showMacrosDetail: Bool
    
    var uiColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var percent: CGFloat
    
    var ringAnimation = Animation.easeInOut(duration: 0.55).delay(0.15)
    var bounceAnimation = Animation.interpolatingSpring(mass: 0.26, stiffness: 1, damping: 0.775, initialVelocity: 1.8).speed(7.0)
    
    var body: some View {
        let multiplier = width / 100
        var progress = 1 - percent / 100
        
        if percent > 100 {
            progress = 0
        }
        
        return ZStack {
            Circle()
                .stroke(Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 13.5)).grayscale(0.4).brightness(0.09)
                .frame(width: width - 0.25, height: height - 0.25)
                .onTapGesture {
                    self.showRings.toggle()
                    self.showMacrosDetail.toggle()
            }
            
            Circle()
                .trim(from: showRings ? progress : 0.999, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(uiColor).opacity(0.45), Color(uiColor)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: width, height: height)
                .shadow(color: Color(uiColor).opacity(0.3), radius: 5 * multiplier, x: 2 * multiplier, y: 3 * multiplier)
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
        .scaleEffect(showRings ? 1.0 : 0.8, anchor: .center)
        .animation(bounceAnimation)
        .blur(radius: showRings ? 0 : 0.18)
    }
}


struct MacrosDetailView: View {
    @Binding var showMacrosDetail: Bool
    @Binding var showRings: Bool
    
    @State var initialOffset: CGFloat = -60.0
    
    var uiColor: UIColor
    var label: String
    var count: String
    var percent: String
    
    let bounceAnimation = Animation.interpolatingSpring(mass: 0.215, stiffness: 1, damping: 0.775, initialVelocity: 1.8).speed(6.0)
    
    var body: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(Color(uiColor).opacity(showMacrosDetail ? 0.95 : 0.85))
                .frame(width: showMacrosDetail ? 112 : 64, height: showMacrosDetail ? 46 : 21)
                .shadow(color: showMacrosDetail ? Color(uiColor).opacity(0.2) : Color.clear, radius: showMacrosDetail ? 3.5 : 0, x: 0, y: showMacrosDetail ? 4 : 0)
            
            VStack {
                Text(label)
                    .font(Font.custom("Catamaran-Bold", size: 12))
                    .foregroundColor(Color.white)
                
                if self.showMacrosDetail {
                    Text("\(count) • \(percent)")
                        .font(Font.custom("QuattrocentoSans-Italic", size: 14.0))
                        .foregroundColor(Color.white)
                        .animation(Animation.easeInOut(duration: 0.3).delay(0.4))
                }
            }
        }.onTapGesture {
            self.showMacrosDetail.toggle()
            self.showRings.toggle()
        }
        .offset(y: initialOffset)
        .onAppear {
            if self.initialOffset == -60.0 {
                return withAnimation(Animation.easeOut(duration: 3.0)) {
                    self.initialOffset += 60
                }
            }
        }
        .animation(bounceAnimation)
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

