//
//  BaseTextField.swift
//  iOSDepartment
//
//  Created by 7Winds - Sokol on 10.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    var onTextChanged: ((BaseTextField, String) -> ())? {
        didSet {
            addTarget(self, action: #selector(onTextChangedHandler), for: UIControl.Event.editingChanged)
            isUserInteractionEnabled = true
        }
    }
    
    @objc func onTextChangedHandler(textField: UITextField) {
        onTextChanged?(self, text ?? "")
    }
    
    var textFieldDidBeginEditing: ((BaseTextField, String) -> ())?
    var textFieldDidEndEditing: ((BaseTextField, String) -> ())?
    var textFieldDidChangeSelection: ((BaseTextField, String) -> ())?
    
    var limitOfSymbols: ((Int) -> Bool)?//пока не реализовано
    
    var nextTextField: UITextField?
    var onNextTextField: ((UITextField, UITextField, String) -> ())?
    var onReturn: (() -> ())?
    var onShouldChangeCharactersIn: ((UITextField, NSRange, String) -> Bool)?
    var textFieldShouldEndEditing: ((UITextField) -> Bool)?
    var onDeleteBackward: (() -> ())?
    
    override init(frame: CGRect = CGRect.zero){
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onDeleteBackward?()
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        onDeleteBackward?()
    }
}

extension BaseTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing?(self, text ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditing?(self, text ?? "")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldDidChangeSelection?(self, text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        if let nextField = nextTextField {
            onNextTextField?(self, nextField, text ?? "")
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return onShouldChangeCharactersIn?(textField, range, string) ?? true
    }
    
    func removeButtonOnKeyboard() {
        inputAccessoryView = nil
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barTintColor = .blue
        doneToolbar.isTranslucent = false
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonAction))
        done.tintColor = .black

        let items = [flexSpace, done, flexSpace]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        resignFirstResponder()
    }
    
}
