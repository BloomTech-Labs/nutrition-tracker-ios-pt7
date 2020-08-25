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
                        .frame(width: 80, height: 80, alignment: .center)
                        .padding(.bottom)
                    
                    Text("We need permission to access you health data")
                }
                .frame(width: 200, height: 200)
                .padding()
                .background(Color.white)
            }
            .background(Color.black.opacity(0.5))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct HKNotAuthorizedView_Previews: PreviewProvider {
    static var previews: some View {
        HKNotAuthorizedView()
    }
}
