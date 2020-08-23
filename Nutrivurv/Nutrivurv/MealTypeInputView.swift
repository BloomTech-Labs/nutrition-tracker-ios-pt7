//
//  MealTypeInputView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct MealTypeInputView: View {
    @Binding var showMealTypes: Bool
    @Binding var selectedMeal: String
    @Binding var selectedMealIndex: Int
    
    @Binding var currentProgress: Bool
    
    var mealTypes: [MealType]
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        BottomSheetModal(display: $showMealTypes) {
            VStack {
                ZStack {
                    CustomInputPicker(selectedIndex: self.$selectedMealIndex, selectedItem: self.$selectedMeal, mealTypes: self.mealTypes)
                    
                    Text("What meal is this?")
                        .font(.custom("QuattrocentoSans-BoldItalic", size: 18))
                        .foregroundColor(Color(UIColor(named: "light-label")!))
                        .frame(width: self.screenWidth, height: 70)
                        .background(Color.white.opacity(0.8))
                        .offset(y: -55)
                    
                    Button(action: {
                        self.showMealTypes.toggle()
                    }) {
                        Text("Done")
                    }
                    .frame(width: 180, height: 40)
                    .background(Color.white.opacity(0.8))
                    .offset(y: 115)
                }
                .frame(alignment: .top)
                .offset(y: -45)
            }.onAppear {
                // Shows macros including this item
                if self.showMealTypes {
                    self.currentProgress = false
                }
            }
        }
    }
}

struct MealTypeInputView_Previews: PreviewProvider {
    static var previews: some View {
        return MealTypeInputView(showMealTypes: .constant(true), selectedMeal: .constant("Breakfast"), selectedMealIndex: .constant(0), currentProgress: .constant(false), mealTypes: MealType.allCases)
    }
}
