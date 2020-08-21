//
//  ServingSizeSelectionView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ServingSizeSelectionView: View {
    @Binding var selectedQuantity: Double
    @Binding var selectedServingSize: String
    @Binding var selectedMealType: String
    
    var quantityLabel = "Quantity"
    var servingSizeLabel = "Serving Size"
    var mealTypeLabel = "Meal Type"
    
    var body: some View {
        HStack {
            FoodDetailsInputViewDouble(label: quantityLabel, inputDouble: $selectedQuantity)
            Spacer()
            FoodDetailsInputViewString(label: servingSizeLabel, inputString: $selectedServingSize)
            Spacer()
            FoodDetailsInputViewString(label: mealTypeLabel, inputString: $selectedMealType)
        }
    }
}

struct ServingSizeSelection_Previews: PreviewProvider {
    static var previews: some View {
        ServingSizeSelectionView(selectedQuantity: .constant(1.0), selectedServingSize: .constant("Whole"), selectedMealType: .constant("Breakfast"))
    }
}


struct FoodDetailsInputViewString: View {
    var label: String
    @Binding var inputString: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(Font.custom("QuattrocentoSans-Italic", size: 12))
                .frame(height: 13)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 0))
            
            Text(inputString)
                .font(Font.custom("Catamaran-SemiBold", size: 16))
                .frame(width: 90, height: 31)
            
            RoundedRectangle(cornerRadius: 1.0, style: .continuous)
                .stroke(lineWidth: 1.0)
                .foregroundColor(Color(UIColor(named: "nutrivurv-blue-new")!))
                .frame(width: 58, height: 0.5).padding(EdgeInsets(top: -16, leading: 0, bottom: 0, trailing: 0))
        }.frame(width: 100, height: 50)
    }
}

struct FoodDetailsInputViewDouble: View {
    var label: String
    @Binding var inputDouble: Double

    var body: some View {
        VStack {
            Text(label)
                .font(Font.custom("QuattrocentoSans-Italic", size: 12))
                .frame(height: 13)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 0))

            Text("\(String(format: "%.1f", inputDouble))")
                .font(Font.custom("Catamaran-SemiBold", size: 16))
                .frame(width: 90, height: 31)

            RoundedRectangle(cornerRadius: 1.0, style: .continuous)
                .stroke(lineWidth: 1.0)
                .foregroundColor(Color(UIColor(named: "nutrivurv-blue-new")!))
                .frame(width: 58, height: 0.5).padding(EdgeInsets(top: -16, leading: 0, bottom: 0, trailing: 0))
        }.frame(width: 100, height: 50)
    }
}
