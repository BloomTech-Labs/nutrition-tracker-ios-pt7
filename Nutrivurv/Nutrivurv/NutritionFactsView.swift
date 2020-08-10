//
//  NutritionFactsView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct NutritionFactsView: View {
    @Binding var showNutrients: Bool
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.blue)
            
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: 50, height: 6)
                    .foregroundColor(Color.black.opacity(0.2))
                    .offset(y: 10)
                
                ScrollView {
                    VStack(spacing: 10) {
                        Text("nutrition Facts")
                            .font(Font.custom("Gaoel", size: 16))
                            .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                        
                        NutrientView(name: "Calories", count: 120, unit: "", pct: nil)
                        
                        Text("% Daily Value *")
                            .font(Font.custom("QuattrocentoSans-Italic", size: 12))
                            .frame(width: UIScreen.main.bounds.width - 60, alignment: .trailing)
                        
                        // Maximum of 10 components per view
                        VStack(spacing: 10) {
                            NutrientView(name: "Total Fat", count: 0.4, unit: "g", pct: 0)
                            
                            NutrientView(name: "Sodium", count: 1.2, unit: "mg", pct: 0)
                            
                            NutrientView(name: "Total Carbohydrate", count: 26.4, unit: "g", pct: 8)
                            
                            NutrientView(name: "Cholesterol", count: 0, unit: "mg", pct: 0)
                            
                            NutrientView(name: "Sugar", count: 14.2, unit: "g", pct: nil)
                            
                            NutrientView(name: "Protein", count: 1.3, unit: "g", pct: nil)
                            
                            NutrientView(name: "Vitamin D", count: 0, unit: "µg", pct: 0)
                            
                            NutrientView(name: "Calcium", count: 5.8, unit: "mg", pct: 0)
                            
                            NutrientView(name: "Iron", count: 0.3, unit: "mg", pct: 1)
                            
                            NutrientView(name: "Potassium", count: 414.2, unit: "mg", pct: 8)
                        }
                    }
                    Spacer()
                }
                .frame(alignment: .top)
                .offset(y: 20)
            }
        }.onTapGesture {
            withAnimation(.easeInOut) {
                self.showNutrients.toggle()
            }
        }
    }
}


struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactsView(showNutrients: .constant(true))
    }
}

struct NutrientView: View {
    var name: String
    var count: Double?
    var unit: String
    var pct: Double?
    
    var body: some View {
        var countLabel = "-"
        var pctLabel = "0"
        var unitLabel = ""
        
        if let count = count {
            if count != 0 {
                countLabel = String(format: "%.1f", count)
                unitLabel = unit
            }
            
            if name == "Calories" {
                countLabel = String(format: "%.0f", count)
            }
        }
        
        if let pct = pct {
            if pct != 0 {
                pctLabel = String(format: "%.1f", pct)
            }
        }
        
        return HStack {
            Text(name)
                .font(Font.custom("QuattrocentoSans-Italic", size: 16))
            Spacer()
            Text("\(countLabel)\(unitLabel)")
                .font(Font.custom("QuattrocentoSans-Italic", size: 16))
            
            // Edamam does not provide percent values for calories, sugar, and protein properties
            // This if statement ensures the percent label is not displayed for these properties
            if pct != nil {
                Text("\(pctLabel)%")
                    .font(Font.custom("QuattrocentoSans-Italic", size: 16))
            }
            
        }.frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
    }
}
