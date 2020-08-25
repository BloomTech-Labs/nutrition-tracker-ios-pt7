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
            
            Text("Please Wait....").padding(.top)
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
    @State var show: Bool = false
    
    var body: some View {
        ZStack {
            Button(action: {
                self.show.toggle()
            }) {
                Text("Custom Loading")
            }
            
            if self.show {
                GeometryReader { geo in
                    VStack {
                        LoadingView()
                    }
                }
                .background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
                .onTapGesture {
                    self.show.toggle()
                }
            }
        }
    }
}

struct CustomLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingIndicator()
    }
}
