//
//  QuantityInputView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct QuantityInputView: View {
    @Binding var showQuantity: Bool
    @Binding var showServingSizes: Bool
    
    @Binding var quantity: String
    
    @Binding var currentProgress: Bool
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        BottomSheetModal(display: $showQuantity) {
            VStack {
                Text("How much are you having?")
                    .font(.custom("QuattrocentoSans-BoldItalic", size: 18))
                TextField("Quantity", text: self.$quantity)
                    .frame(width: self.screenWidth * 0.7, alignment: .center)
                    .font(.custom("Catamaran-Bold", size: 32))
                    .multilineTextAlignment(.center)
                RoundedRectangle(cornerRadius: 1.0, style: .continuous)
                    .stroke(lineWidth: 2.0)
                    .frame(width: 150, height: 2)
                    .foregroundColor(Color(UIColor(named: "nutrivurv-blue-new")!))
                CustomInputButton(showNext: self.$showServingSizes, showSelf: self.$showQuantity, buttonText: "Serving Sizes >")
                .padding(.top, 25)
            }.onAppear {
                // Shows macros including this item
                if self.showQuantity {
                    self.currentProgress = false
                }
            }
        }
    }
}

struct QuantityInputView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityInputView(showQuantity: .constant(true), showServingSizes: .constant(false), quantity: .constant("1.0"), currentProgress: .constant(false))
    }
}
