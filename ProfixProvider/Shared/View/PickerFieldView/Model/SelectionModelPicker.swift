//
//  SelectionModelPicker.swift
//  Profix
//
//  Created by Haneen on 10/12/2025.
//

protocol SelectionModelPicker {
    var pickerId: Int { get }
    var pickerName: String { get }
}


protocol SelectionPopUpDelegate: AnyObject {
    func onsSelectedItem(items: SelectionModelPicker)
}

enum PickerType {
    case city
    case category
    case service
}
