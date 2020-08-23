//
//  FoodDetailView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import SkeletonUI

struct FoodDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var currentDailyMacros: DailyMacros
    @ObservedObject var newDailyMacros: DailyMacros
    @ObservedObject var foodItemMacros: DailyMacros
    @ObservedObject var nutritionFacts: NutritionFacts
    
    var foodName: String = ""
    var brandName: String = ""
    
    @State var quantity: String = "1.0"
    @State var servingSize: String = "Serving"
    @State var mealType: String = "Breakfast"
    
    @State var showQuantityInputView: Bool = false
    @State var showServingSizeInputView: Bool = false
    @State var showMealTypeInputView: Bool = false
    
    var servingSizes: [Measure] = []
    
    var foodImage: UIImage = UIImage(named: "cutting-board")!
    
    var navigationBarTitle: String = ""
    
    @State var currentProgresss: Bool = true
    @State var showNutrients: Bool = false
    @State var bottomCardState = CGSize.zero
    
    var caloriesColor = UIColor(named: "nutrivurv-blue-new")!
    var carbsColor = UIColor(named: "nutrivurv-green-new")!
    var proteinColor = UIColor(named: "nutrivurv-orange-new")!
    var fatColor = UIColor(named: "nutrivurv-red-new")!
    
    var shadowColor = UIColor(named: "detail-view-card-shadow")!
    var bgColor = UIColor(named: "detail-view-main-bg")!
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @State var keyboardOffsetValue: CGFloat = 0
    
    var springAnimation = Animation.spring(response: 0.32, dampingFraction: 0.78, blendDuration: 0.8)
    var shiftViewAnimation = Animation.spring(response: 0.2, dampingFraction: 0.94, blendDuration: 1.0)
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image(uiImage: foodImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height / 3, alignment: .center)
                    
                    ZStack {
                        // Main card background view
                        RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                            .foregroundColor(Color(bgColor))
                            .shadow(color: Color(shadowColor), radius: 8.0, x: 0, y: -3)
                            .animation(.easeInOut)
                        
                        VStack {
                            
                            HStack {
                                TableViewSectionHeader(dailyMacrosModel: foodItemMacros)
                                    .scaleEffect(1.10)
                                    .frame(width: 245, height: 43)
                                
                                Spacer()
                                
                                Button(action: {
                                    // TODO: Add meal functionality
                                }) {
                                    Image("add-meal-button-icon")
                                        .renderingMode(.original)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color(shadowColor), radius: 8.0, x: 0, y: -3)
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .animation(.easeInOut)
                            }
                            .frame(width: UIScreen.main.bounds.width - 24, height: 60)
                            
                            
                            HStack {
                                VStack{
                                    Text(foodName)
                                        .font(Font.custom("Catamaran-Bold", size: 20))
                                        .frame(width: 280, alignment: .leading)
                                        .minimumScaleFactor(0.6)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(brandName)
                                        .font(Font.custom("QuattrocentoSans-Italic", size: 15))
                                        .frame(width: 280, alignment: .leading)
                                        .minimumScaleFactor(0.6)
                                        .lineLimit(1)
                                        .padding(.top, -5)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                Spacer()
                                
                                Image("heart-icon")
                                    .frame(width: 32, height: 29, alignment: .center)
                            }
                            .frame(width: UIScreen.main.bounds.width - 40, height: 44, alignment: .center)
                            .padding(EdgeInsets(top: -5, leading: 0, bottom: 6, trailing: 0))
                            
                            
                            MealDetailsSelectionView(selectedQuantity: $quantity, selectedServingSize: $servingSize, selectedMealType: $mealType, showQuantityInputView: $showQuantityInputView, showServingSizeInputView: $showServingSizeInputView, showMealTypeInputView: $showMealTypeInputView)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 58, alignment: .center)
                            
                            
                            ProgressSwitcherView(currentProgress: $currentProgresss)
                                .frame(width: 180, height: 60, alignment: .center)
                                .padding(EdgeInsets(top: -4, leading: 117, bottom: -2, trailing: 117))
                            
                            ZStack {
                                HStack(spacing: 20) {
                                    MacrosDetailView(count: currentProgresss ? currentDailyMacros.caloriesCount : newDailyMacros.caloriesCount, progressPercent: currentProgresss ? currentDailyMacros.caloriesPercent : newDailyMacros.caloriesPercent, macroDescription: " cals", uiColor: caloriesColor)
                                    
                                    MacrosDetailView(count: currentProgresss ? currentDailyMacros.carbsCount : newDailyMacros.carbsCount, progressPercent: currentProgresss ? currentDailyMacros.carbsPercent : newDailyMacros.carbsPercent, macroDescription: "g carbs", uiColor: carbsColor)
                                    
                                    MacrosDetailView(count: currentProgresss ? currentDailyMacros.proteinCount : newDailyMacros.proteinCount, progressPercent: currentProgresss ? currentDailyMacros.proteinPercent : newDailyMacros.proteinPercent, macroDescription: "g protein", uiColor: proteinColor)
                                    
                                    MacrosDetailView(count: currentProgresss ? currentDailyMacros.fatCount : newDailyMacros.fatCount, progressPercent: currentProgresss ? currentDailyMacros.fatPercent : newDailyMacros.fatPercent, macroDescription: "g fat", uiColor: fatColor)
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width - 58, height: 97)
                                .offset(x: -4, y: currentProgresss ? -20 : 0)
                                
                                HStack(spacing: 6) {
                                    BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 1, percentDifference: Int(newDailyMacros.caloriesPercent - currentDailyMacros.caloriesPercent))
                                    Spacer()
                                    BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 2, percentDifference: Int(newDailyMacros.carbsPercent - currentDailyMacros.carbsPercent))
                                    Spacer()
                                    BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 3, percentDifference: Int(newDailyMacros.proteinPercent - currentDailyMacros.proteinPercent))
                                    Spacer()
                                    BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 4, percentDifference: Int(newDailyMacros.fatPercent - currentDailyMacros.fatPercent))
                                }
                                .frame(width: UIScreen.main.bounds.width - 80, height: 46, alignment: .center)
                                .padding(EdgeInsets(top: 0, leading: 37, bottom: 104, trailing: 0))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .top)
                        .offset(x: 0, y: -30)
                        .animation(.easeInOut)
                        
                        NutritionFactsView(showNutrients: $showNutrients, nutritionFacts: nutritionFacts)
                            .offset(y: showNutrients ? 165 : 358)
                            .offset(y: self.bottomCardState.height)
                            .gesture(
                                DragGesture().onChanged { value in
                                    if self.showNutrients {
                                        guard value.translation.height > -60 else {
                                            withAnimation(.easeInOut) {
                                                self.bottomCardState = .zero
                                            }
                                            return
                                        }
                                        if self.bottomCardState.height > 180 {
                                            withAnimation(.easeInOut) {
                                                self.bottomCardState = .zero
                                                self.showNutrients.toggle()
                                            }
                                            return
                                        }
                                    } else {
                                        guard value.translation.height < 55 else { return }
                                    }

                                    if self.bottomCardState.height < -180 { return }
                                        withAnimation(.easeInOut) {
                                        self.bottomCardState = value.translation
                                    }
                                }
                                .onEnded { value in
                                    if self.showNutrients {
                                        if value.translation.height < 0 { return }
                                    }
                                    if self.bottomCardState.height < -120 {
                                        withAnimation(.easeInOut) {
                                            self.showNutrients = true
                                        }
                                    } else {
                                        withAnimation(.easeInOut) {
                                            self.showNutrients = false
                                        }
                                    }
                                    
                                    withAnimation(.easeInOut) {
                                        self.bottomCardState = .zero
                                    }
                            })
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .bottom)
                    .offset(y: showNutrients ? -180 : -40)
                }
                
                QuantityInputView(showQuantity: $showQuantityInputView, showServingSizes: $showServingSizeInputView, quantity: $quantity)
                    .animation(self.springAnimation)
                    
                
                BottomSheetModal(display: $showServingSizeInputView) {
                    TextField("Serving Size", text: self.$servingSize)
                }.animation(Animation.spring(response: 0.32, dampingFraction: 0.78, blendDuration: 0.8))
                
                BottomSheetModal(display: $showMealTypeInputView) {
                    TextField("Meal Type", text: self.$mealType)
                }.animation(Animation.spring(response: 0.32, dampingFraction: 0.78, blendDuration: 0.8))
                
            }
        }
        .navigationBarTitle(navigationBarTitle)
        .background(Color(UIColor(named: "bg-color")!))
        .offset(y: -keyboardOffsetValue * 0.75)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                withAnimation(self.shiftViewAnimation) {
                    self.keyboardOffsetValue = height
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                
                withAnimation(self.shiftViewAnimation) {
                    self.keyboardOffsetValue = 0
                }
            }
        }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(currentDailyMacros: DailyMacros(), newDailyMacros: DailyMacros(), foodItemMacros: DailyMacros(), nutritionFacts: NutritionFacts())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    var shadowColor = UIColor(named: "detail-view-card-shadow")!
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .shadow(color: configuration.isPressed ? Color.black.opacity(0.6) : Color(shadowColor), radius: configuration.isPressed ? 6.0 : 8.0, x: 0, y: -3)
    }
}
