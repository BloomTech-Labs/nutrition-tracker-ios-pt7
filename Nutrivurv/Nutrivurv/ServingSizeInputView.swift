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
    @Binding var showMealTypes: Bool
    
    @Binding var selectedServingSize: String
    @Binding var selectedIndex: Int
    var edamamMeasures: [Measure]
    var nutrivurvBackendMeasurements: [Measurement]
    
    @Binding var currentProgress: Bool
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        BottomSheetModal(display: $showServingSizes) {
            VStack {
                ZStack {
                    CustomInputPicker(selectedIndex: self.$selectedIndex, selectedItem: self.$selectedServingSize, edamamMeasures: self.edamamMeasures, nutrivurvBackendMeasurements: self.nutrivurvBackendMeasurements)
                    
                    Text("What's the measurement?")
                    .font(.custom("QuattrocentoSans-BoldItalic", size: 18))
                    .foregroundColor(Color(UIColor(named: "light-label")!))
                        .frame(width: self.screenWidth, height: 70)
                    .background(Color(UIColor(named: "bubble-bg-color")!))
                    .offset(y: -55)
                    
                    HStack {
                        CustomInputButton(showNext: self.$showQuantity, showSelf: self.$showServingSizes, buttonText: "< Quantity")
                            .frame(width: 180, height: 40)
                            .background(Color(UIColor(named: "bubble-bg-color")!))
                        
                        CustomInputButton(showNext: self.$showMealTypes, showSelf: self.$showServingSizes, buttonText: "Meal Types >")
                            .frame(width: 180, height: 40)
                            .background(Color(UIColor(named: "bubble-bg-color")!))
                        
                    }.offset(y: 115)
                }
                .frame(alignment: .top)
                .offset(y: -45)
            }.onAppear {
                // Shows macros including this item
                if self.showServingSizes {
                    self.currentProgress = false
                }
            }
        }
    }
}

struct ServingSizeInputView_Previews: PreviewProvider {
    static var previews: some View {
        let edamamMeasures = [Measure(uri: "1", label: "Serving"), Measure(uri: "2", label: "Whole"), Measure(uri: "3", label: "Cup"), Measure(uri: "4", label: "Ounce"), Measure(uri: "5", label: "Gram")]
        let nutrivurvMeasurements = [Measurement(uri: "1", label: "Serving"), Measurement(uri: "2", label: "Whole"), Measurement(uri: "3", label: "Cup"), Measurement(uri: "4", label: "Ounce"), Measurement(uri: "5", label: "Gram")]
        
        return ServingSizeInputView(showServingSizes: .constant(true), showQuantity: .constant(false), showMealTypes: .constant(false), selectedServingSize: .constant("Serving"), selectedIndex: .constant(0), edamamMeasures: edamamMeasures, nutrivurvBackendMeasurements: nutrivurvMeasurements, currentProgress: .constant(false))
    }
}
