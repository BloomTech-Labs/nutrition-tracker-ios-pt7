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
            RingView(show: $showCaloriesStroke, uiColor: blueColor, width: 120, height: 120, percent: 85)
            RingView(show: $showCaloriesStroke, uiColor: greenColor, width: 95.6, height: 95.6, percent: 100)
            RingView(show: $showCaloriesStroke, uiColor: yellowColor, width: 75.84, height: 75.84, percent: 54)
            RingView(show: $showCaloriesStroke, uiColor: redColor, width: 59.53, height: 59.53, percent: 74)
            
            HStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4.0)
                            .fill(Color(blueColor).opacity(0.9))
                            .frame(width: 60, height: 15)
                        
                        Text("Calories")
                            .font(Font.custom("Muli-Bold", size: 10.0))
                            .foregroundColor(Color.white)
                    }.offset(x: -50)
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4.0)
                            .fill(Color(greenColor).opacity(0.9))
                            .frame(width: 60, height: 15)
                        
                        Text("Carbs")
                            .font(Font.custom("Muli-Bold", size: 10.0))
                            .foregroundColor(Color.white)
                    }.offset(x: -60)
                }.offset(y: -20)
                
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4.0)
                            .fill(Color(yellowColor).opacity(0.9))
                            .frame(width: 60, height: 15)
                        
                        Text("Protein")
                            .font(Font.custom("Muli-Bold", size: 10.0))
                            .foregroundColor(Color.white)
                    }.offset(x: 50)
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4.0)
                            .fill(Color(redColor).opacity(0.9))
                            .frame(width: 60, height: 15)
                        
                        Text("Fat")
                            .font(Font.custom("Muli-Bold", size: 10.0))
                            .foregroundColor(Color.white)
                    }.offset(x: 60)
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
    @Binding var show: Bool
    
    var uiColor: UIColor
    var width: CGFloat
    var height: CGFloat
    var percent: CGFloat
    
    var ringAnimation = Animation.easeInOut(duration: 0.8).delay(0.25)
    
    var body: some View {
        let multiplier = width / 100
        let progress = 1 - percent / 100
        
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
//                .shadow(color: complete ? Color(uiColor).opacity(0.6) : Color(uiColor).opacity(0.3), radius: 3 * multiplier, x: 2 * multiplier, y: -3 * multiplier)
                .shadow(color: Color(uiColor).opacity(0.3), radius: 3 * multiplier, x: 2 * multiplier, y: 3 * multiplier)
                .animateRing(using: ringAnimation) {
                    self.show = true
            }
            .animation(ringAnimation)
            .onTapGesture {
                self.show.toggle()
            }
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
