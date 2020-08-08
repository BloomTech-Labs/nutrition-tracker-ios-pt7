//
//  ServingSizeSelectionView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ServingSizeSelectionView: View {
    var quantityLabel = "Quantity"
    var servingSizeLabel = "Serving Size"
    var mealTypeLabel = "Meal Type"
    
    var selectedQuantity: String = "1.0"
    var selectedServingSize: String = "Whole"
    var selectedMealType: String = "Breakfast"
    
    var body: some View {
        HStack {
            FoodDetailsInputView(label: quantityLabel, input: selectedQuantity)
            Spacer()
            FoodDetailsInputView(label: servingSizeLabel, input: selectedServingSize)
            Spacer()
            FoodDetailsInputView(label: mealTypeLabel, input: selectedMealType)
        }
    }
}

struct ServingSizeSelection_Previews: PreviewProvider {
    static var previews: some View {
        ServingSizeSelectionView()
    }
}


struct FoodDetailsInputView: View {
    @State var label: String
    @State var input: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(Font.custom("QuattrocentoSans-Italic", size: 12))
                .frame(height: 13)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 0))
            
            Text(input)
                .font(Font.custom("Catamaran-SemiBold", size: 16))
                .frame(width: 90, height: 31)
            
            RoundedRectangle(cornerRadius: 1.0, style: .continuous)
                .stroke(lineWidth: 1.0)
                .foregroundColor(Color(UIColor(named: "nutrivurv-blue-new")!))
                .frame(width: 58, height: 0.5).padding(EdgeInsets(top: -16, leading: 0, bottom: 0, trailing: 0))
        }.frame(width: 100, height: 50)
    }
}
