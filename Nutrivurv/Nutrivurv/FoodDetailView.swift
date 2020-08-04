//
//  FoodDetailView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct FoodDetailView: View {
    var body: some View {
        
        
        VStack {
            
            // Acts as the nav bar - ONLY for testing purposes
            Rectangle()
                .frame(height: 118)
                .foregroundColor(Color.gray.opacity(0.3))
            
            
            Image("avocado")
                .frame(height: 305, alignment: .top)
                .scaledToFill()
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            //                .overlay(Rectangle().foregroundColor(.red))
            
            ZStack {
                // Main card background view
                RoundedRectangle(cornerRadius: 35.0)
                .foregroundColor(.blue)
                
                HStack {
                    MacrosMealHeader(dailyMacrosModel: DailyMacros())
                        .scaleEffect(1.08)
                        .frame(width: 245, height: 43)
                    
                    Spacer()
                    
                    // Use the add meal icon
                    Image("add-meal-button-icon")
                        .frame(width: 60, height: 60)
                        .scaleEffect(1.0)
                }
                .frame(width: 365, height: 60)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 21))
                .offset(x: 0, y: -280)
                
                
                HStack {
                    VStack{
                        Text("Avocados")
                            .font(Font.custom("Catamaran-Bold", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        
                        Text("Generic Foods")
                            .font(Font.custom("QuattrocentoSans-Italic", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: -5, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Spacer()
                    
                    Image("heart-icon")
                        .frame(width: 32, height: 29)
                }
                .frame(width: 354, height: 44)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                .offset(x: 0, y: -209)
                
            }
            .frame(width: 415, height: 556, alignment: .bottom)
            .offset(x: 0, y: -36)
            
        }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView()
    }
}
