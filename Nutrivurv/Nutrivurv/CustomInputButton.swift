//
//  CustomInputButton.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import UIKit

struct CustomInputButton: View {
    @Binding var showNext: Bool
    @Binding var showSelf: Bool
    var lastInputView: Bool = false
    var buttonText: String = "Done"
    
    var textColor = UIColor(named: "light-label")!
    var bgColor = UIColor(named: "bg-color")!
    
    var body: some View {
        Button(action: {
            // Dismiss the keyboard when navigating to next view
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            if !self.lastInputView {
                self.showNext.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
                self.showSelf.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 120, height: 30)
                    .foregroundColor(Color(bgColor))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
                Text(buttonText)
                    .foregroundColor(Color(textColor))
                    .font(Font.custom("Catamaran-Bold", size: 14))
            }
        }
    }
}

struct CustomInputButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputButton(showNext: .constant(true), showSelf: .constant(false))
    }
}
