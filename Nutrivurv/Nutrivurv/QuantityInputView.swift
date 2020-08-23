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
                Button(action: {
                    self.showServingSizes.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
                        self.showQuantity.toggle()
                    }
                }) {
                    Text("Serving Sizes >")
                }.padding(.top, 10)
            }
        }
    }
}

struct QuantityInputView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityInputView(showQuantity: .constant(true), showServingSizes: .constant(false), quantity: .constant("1.0"))
    }
}
