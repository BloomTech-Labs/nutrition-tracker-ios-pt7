//
//  ServingSizePicker.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ServingSizePicker: UIViewRepresentable {
    
    @State var selectedIndex: Int = 0
    @Binding var selectedItem: String
    var data: [Measure] = []
    
    func makeCoordinator() -> ServingSizePicker.Coordinator {
        return ServingSizePicker.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ServingSizePicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<ServingSizePicker>) {
        uiView.selectRow(selectedIndex, inComponent: 0, animated: true)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: ServingSizePicker
        
        init(parent1: ServingSizePicker) {
            parent = parent1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data.count
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.4, height: 36))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            
            label.text = self.parent.data[row].label
            label.textAlignment = .center
            label.font = UIFont(name: "QuattrocentoSans-Bold", size: 18)
            label.textColor = .white
            
            view.backgroundColor = UIColor(named: "nutrivurv-blue-new")
            
            view.addSubview(label)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 2
            view.layer.cornerCurve = .continuous
            
            pickerView.subviews[1].isHidden = true
            pickerView.subviews[2].isHidden = true
            
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            guard !self.parent.data.isEmpty else { return }
            self.parent.selectedItem = self.parent.data[row].label
            self.parent.selectedIndex = row
        }
    }
}
