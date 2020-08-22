//
//  ServingSizeSelectionView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ServingSizeSelectionView: View {
    @Binding var selectedQuantity: String
    @Binding var selectedServingSize: String
    @Binding var selectedMealType: String
    
    @Binding var showQuantityInputView: Bool
    @Binding var showServingSizeInputView: Bool
    @Binding var showMealTypeInputView: Bool
    
    var quantityLabel = "Quantity"
    var servingSizeLabel = "Serving Size"
    var mealTypeLabel = "Meal Type"
    
    var body: some View {
        HStack {
            FoodDetailsInputViewString(label: quantityLabel, inputString: $selectedQuantity).onTapGesture {
                self.showQuantityInputView.toggle()
            }
            Spacer()
            FoodDetailsInputViewString(label: servingSizeLabel, inputString: $selectedServingSize).onTapGesture {
                self.showServingSizeInputView.toggle()
            }
            Spacer()
            FoodDetailsInputViewString(label: mealTypeLabel, inputString: $selectedMealType).onTapGesture {
                self.showMealTypeInputView.toggle()
            }
        }
    }
}

struct ServingSizeSelection_Previews: PreviewProvider {
    static var previews: some View {
        ServingSizeSelectionView(selectedQuantity: .constant("1.0"), selectedServingSize: .constant("Whole"), selectedMealType: .constant("Breakfast"), showQuantityInputView: .constant(false), showServingSizeInputView: .constant(false), showMealTypeInputView: .constant(false))
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
