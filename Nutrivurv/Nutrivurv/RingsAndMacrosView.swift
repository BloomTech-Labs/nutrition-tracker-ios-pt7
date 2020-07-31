//
//  RingsAndMacrosView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import Combine

struct RingsAndMacrosView: View {
    @State var showRings = false
    @State var showMacrosDetail = false
    
    @ObservedObject var dailyMacrosModel: DailyMacros
    
    var caloriesColor = UIColor(named: "nutrivurv-blue-new")!
    var carbsColor = UIColor(named: "nutrivurv-green-new")!
    var proteinColor = UIColor(named: "nutrivurv-orange-new")!
    var fatColor = UIColor(named: "nutrivurv-red-new")!
    
    var body: some View {
        ZStack {
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: caloriesColor, width: 134.5, height: 134.5, progressPercent: dailyMacrosModel.caloriesPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: carbsColor, width: 103, height: 103, progressPercent: dailyMacrosModel.carbsPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: proteinColor, width: 71.5, height: 71.5, progressPercent: dailyMacrosModel.proteinPercent)
            RingView(showRings: $showRings, showMacrosDetail: $showMacrosDetail, uiColor: fatColor, width: 40, height: 40, progressPercent: dailyMacrosModel.fatPercent)
            
            HStack {
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: caloriesColor, label: "calories", count: "\(Int(dailyMacrosModel.caloriesCount)) cal", progressPercent: "\(Int(dailyMacrosModel.caloriesPercent))%")
                        .offset(x: showRings ? -78 : -50)
                        Spacer()
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: carbsColor, label: "carbs", count: "\(Int(dailyMacrosModel.carbsCount))g", progressPercent: "\(Int(dailyMacrosModel.carbsPercent))%")
                        .offset(x: showRings ? -88 : -38)
                    
                }
                .offset(y: -20)
                .frame(maxHeight: showMacrosDetail ? 105 : 52)
                
                
                VStack {
                    
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: proteinColor, label: "protein", count: "\(Int(dailyMacrosModel.proteinCount))g", progressPercent: "\(Int(dailyMacrosModel.proteinPercent))%")
                        .offset(x: showRings ? 78 : 50)
                    Spacer()
                    MacrosDetailView(showMacrosDetail: $showMacrosDetail, showRings: $showRings, uiColor: fatColor, label: "fat", count: "\(Int(dailyMacrosModel.fatCount))g", progressPercent: "\(Int(dailyMacrosModel.fatPercent))%")
                        .offset(x: showRings ? 88 : 38)
                    
                }
                .offset(y: -20)
                .frame(maxHeight:  showMacrosDetail ? 105 : 52)
            }
        }
    }
}

struct ActivityRingsView_Previews: PreviewProvider {
    static var previews: some View {
        RingsAndMacrosView(dailyMacrosModel: DailyMacros())
    }
}


struct RingView: View {
    @Binding var showRings: Bool
    @Binding var showMacrosDetail: Bool
    
    var uiColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var progressPercent: CGFloat
    
    var ringAnimation = Animation.easeInOut(duration: 0.55).delay(0.15)
    var bounceAnimation = Animation.interpolatingSpring(mass: 0.26, stiffness: 1, damping: 0.775, initialVelocity: 1.8).speed(7.0)
    
    var body: some View {
        let multiplier = width / 100
        var progress = 1 - (progressPercent / 100)
        
        // As percentages approach 100 the rings appear to be completed before they actually are - due to the rounded line caps
        // If over 75 percent, each percentage mark of a ring will be represented as a fraction of percentage less than the actual value
        if progressPercent > 75 {
            progress = 1 - (0.75 + ((0.92 * (progressPercent - 75)) / 100))
        }
        
        if progressPercent >= 100 {
            // 0 Represents the entire circle being filled
            progress = 0
        }
        
        return ZStack {
            Circle()
                .stroke(Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 13.5)).grayscale(0.4).brightness(0.09)
                .frame(width: width - 0.25, height: height - 0.25)
                .onTapGesture {
                    self.showRings.toggle()
                    self.showMacrosDetail.toggle()
                    haptic()
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
                haptic()
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
    var progressPercent: String
    
    let bounceAnimation = Animation.interpolatingSpring(mass: 0.215, stiffness: 1, damping: 0.775, initialVelocity: 1.8).speed(6.0)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: showMacrosDetail ? 23 : 10.5, style: .continuous)
                .fill(Color(uiColor).opacity(showMacrosDetail ? 0.95 : 0.85))
                .frame(width: showMacrosDetail ? 112 : 64, height: showMacrosDetail ? 46 : 21)
                .shadow(color: showMacrosDetail ? Color(uiColor).opacity(0.2) : Color.clear, radius: showMacrosDetail ? 3.5 : 0, x: 0, y: showMacrosDetail ? 4 : 0)
            
            VStack {
                Text(label)
                    .font(Font.custom("Gaoel", size: 9.5))
                    .foregroundColor(Color.white)
                    .frame(minWidth: 48, minHeight: 18)
                
                if self.showMacrosDetail {
                    Text("\(count) • \(progressPercent)")
                        .font(Font.custom("QuattrocentoSans-Italic", size: 14.0))
                        .foregroundColor(Color.white)
                        .animation(Animation.easeInOut(duration: 0.3).delay(0.4))
                }
            }.frame(minWidth: 58)
        }.onTapGesture {
            self.showMacrosDetail.toggle()
            self.showRings.toggle()
            haptic()
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

// MARK: - Haptic Feedback Functionality

func haptic() {
    UINotificationFeedbackGenerator().notificationOccurred(.success)
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

