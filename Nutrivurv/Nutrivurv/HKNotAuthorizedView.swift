//
//  HKNotAuthorizedView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct HKNotAuthorizedView: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                VStack {
                    Image("favor_1")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.pink)
                        .frame(width: 80, height: 80, alignment: .center)
                        .padding(.bottom)
                    
                    Text("No Health Data")
                        .font(Font.custom("QuattrocentoSans-Bold", size: 22))
                        .multilineTextAlignment(.center)
                        .frame(width: 180)
                    
                    Text("Grant Nutrivurv access to your health data in the settings app, then start logging your meals to track your progress!")
                        .font(Font.custom("QuattrocentoSans", size: 16))
                        .multilineTextAlignment(.center)
                        .frame(width: 210)
                        .padding(.top)
                }
                .frame(width: 220, height: 240)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
            }
            .background(Color.black.opacity(0.4))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct HKNotAuthorizedView_Previews: PreviewProvider {
    static var previews: some View {
        HKNotAuthorizedView()
    }
}
