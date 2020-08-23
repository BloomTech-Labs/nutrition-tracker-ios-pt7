//
//  ServingSizeInputView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ServingSizeInputView: View {
    @Binding var showServingSizes: Bool
    @Binding var showQuantity: Bool
    
    @Binding var selectedServingSize: String
    var servingSizes: [Measure]
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        BottomSheetModal(display: $showServingSizes) {
            VStack {
                ZStack {
                    ServingSizePicker(selectedItem: self.$selectedServingSize, data: self.servingSizes)
                    
                    Text("What's the measurement?")
                    .font(.custom("QuattrocentoSans-BoldItalic", size: 18))
                    .foregroundColor(Color(UIColor(named: "light-label")!))
                    .frame(height: 70)
                    .background(Color.white.opacity(0.8))
                    .offset(y: -55)
                    
                    Button(action: {
                        // Dismiss the keyboard when navigating to next view
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        self.showServingSizes.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
                            self.showQuantity.toggle()
                        }
                    }) {
                        Text("Serving Sizes >")
                    }
                    .frame(width: 180, height: 40)
                    .background(Color.white.opacity(0.8))
                    .offset(y: 110)
                }
                .frame(alignment: .top)
                .offset(y: -45)
            }
        }
    }
}

struct ServingSizeInputView_Previews: PreviewProvider {
    static var previews: some View {
        let servingSizes = [Measure(uri: "1", label: "Serving"), Measure(uri: "2", label: "Whole"), Measure(uri: "3", label: "Cup"), Measure(uri: "4", label: "Ounce"), Measure(uri: "5", label: "Gram")]
        
        return ServingSizeInputView(showServingSizes: .constant(true), showQuantity: .constant(false), selectedServingSize: .constant("Serving"), servingSizes: servingSizes)
    }
}
