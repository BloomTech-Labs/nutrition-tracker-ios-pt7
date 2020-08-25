//
//  CustomLoadingIndicator.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import UIKit

struct LoadingView: View {
    @State var animate = false
    @Binding var loadingText: String
    
    var startColor: Color = Color(UIColor(named: "nutrivurv-cyan")!)
    var endColor: Color = Color(UIColor(named: "nutrivurv-blue-new")!)
    
    var body: some View {
        
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [startColor, endColor]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            
            Text(loadingText.lowercased() + "....").padding(.top)
                .font(Font.custom("Gaoel", size: 12))
                .frame(width: 100, alignment: .center)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
            self.animate.toggle()
        }
    }
}

struct CustomLoadingIndicator: View {
    @State var show: Bool = true
    @State var loadingText: String = "Please Wait"
    var bgOpacity: Double = 0.25
    
    var body: some View {
        ZStack {
            if self.show {
                GeometryReader { geo in
                    VStack {
                        LoadingView(loadingText: self.$loadingText)
                    }
                }
                .background(Color.black.opacity(bgOpacity).edgesIgnoringSafeArea(.all))
            }
        }
    }
}

struct CustomLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingIndicator()
    }
}
