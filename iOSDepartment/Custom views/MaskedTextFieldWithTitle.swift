//
//  MaskedTextFieldWithTitle.swift
//  iOSDepartment
//
//  Created by 7winds on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import UIKit

class MaskedTextFieldWithTitle: UIView {
    
    private var maskedHolder: ((UITextField, NSRange, String) -> ())?
    
    var modifyBorders: (() -> ())?
    var isValid = false
    var rangeOfSymbols: [Int] {
        var ranges: [Int] = []
        var i = 0
        for ch in maskHolder{
            if ch != maskSymbol{
                ranges.append(i)
            }
            i += 1
        }
        return ranges
    }
    var maskColor: UIColor = .black{
        didSet{
            maskTextField.textColor = maskColor
        }
    }
    var maskHolder:String = "(000)000 00 00"
    var maskSymbol:String.Element = "0"
    var regExForMask = "[^0-9]"
    var text: String {
        get {
            return (staticLabel.text ?? "") + (textField.text ?? "")
        }
        set {
            textField.text = newValue
        }
    }
    var title: String = "" {
        didSet{
            titleLabel.text = title
        }
    }
    
    func setErrorState(){
        container.layer.borderColor = appearance.colors.red.cgColor
        container.layer.borderWidth = 2
        
    }
    
    func setNormalState(){
        container.layer.borderColor = UIColor.clear.cgColor
    }
    var staticTitle: String = "" {
        didSet{
            staticLabel.text = staticTitle
            staticLabel.snp.makeConstraints{ make in
                make.centerY.equalToSuperview()
                
                if (staticLabel.text?.count ?? 0) > 0 {
                    make.left.equalToSuperview().offset(7)
                let size: CGSize = (staticLabel.text ?? "").size(withAttributes: [NSAttributedString.Key.font : staticLabel.font ?? UIFont.systemFont(ofSize: 0)])
                make.width.equalTo(size.width + 1)
                } else {
                    make.left.equalToSuperview()
                    make.width.equalTo(7)
                }
                make.height.equalToSuperview()
            }
        }
    }
    var afterMaskCheck: (() -> ())?
    
   private lazy var staticLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
//        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.font = BaseFont().get(.medium, 16)
        view.text = ""
        return view
    }()
    
   lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = BaseFont().get(.medium, 16)
   
        view.textColor = appearance.colors.dark_main
        return view

    }()
    
    
    lazy var container:UIView = {
        let view = UIView()
        view.backgroundColor = appearance.colors.dark_main
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    lazy var textField: BaseTextField = {
        let view = BaseTextField()
        view.isUserInteractionEnabled = true
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        view.rightViewMode = .always
        view.autocapitalizationType = .none
        view.font = BaseFont().get(.medium, 16)
        view.keyboardType = .numberPad
        view.textColor = appearance.colors.dark_main
        view.delegate = self
        maskedHolder = {
            [weak self] textField, range, string in
            self?.checkMask(textField, range, string)
            
            (self?.afterMaskCheck ?? { return })()
        }
        
        return view
    }()
    
    func setMaskedText(newText: String){
        textField.text = newText
        maskedHolder?(textField, NSRange(location: 0, length: newText.count), newText)
    }
    
    lazy var maskTextField: BaseTextField = {
        let view = BaseTextField()
        view.textColor = maskColor
//        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.font = BaseFont().get(.medium, 16)
        view.textAlignment = .left
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        view.rightViewMode = .always
        view.autocapitalizationType = .none
        return view
    }()
    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        maskColor = appearance.colors.gray
        text = titleLabel.text ?? ""
        addSubview(container)
        addSubview(titleLabel)
        container.addSubview(staticLabel)
        container.addSubview(maskTextField)
        container.addSubview(textField)
        makeConstr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func makeConstr(){
        staticLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            
            if (staticLabel.text?.count ?? 0) > 0 {
                make.left.equalToSuperview().offset(7)
            let size: CGSize = (staticLabel.text ?? "").size(withAttributes: [NSAttributedString.Key.font : staticLabel.font ?? UIFont.systemFont(ofSize: 0)])
            make.width.equalTo(size.width + 1)
            } else {
                make.left.equalToSuperview()
                make.width.equalTo(0)
            }
            make.height.equalToSuperview()
        }
        maskTextField.snp.makeConstraints{ make in
            make.left.equalTo(staticLabel.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        textField.snp.makeConstraints{ make in
            make.left.equalTo(staticLabel.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{ make in
            make.left.right.equalTo(container)
            make.bottom.equalTo(textField.snp.top).offset(-3)
        }
        
        container.snp.makeConstraints{ make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func checkMask(_ textField: UITextField, _ range: NSRange, _ string: String){
        guard let text = textField.text else { return }
        var rangeForEdit: NSRange
        if rangeOfSymbols.filter({ ($0 == range.location) && ($0 > 0) }).count > 0 && range.length == 1 {
            rangeForEdit = NSRange(location: range.location - 1, length: 1)
        } else {
            rangeForEdit = range
        }
        let mask = maskHolder
        let newString = (text as NSString).replacingCharacters(in: rangeForEdit, with: string)
        let numbers = newString.replacingOccurrences(of: regExForMask, with: "", options: .regularExpression)
        var result = ""
        var attRes = ""
        
        var index = numbers.startIndex
        for ch in mask where index < mask.endIndex {
            if ch == maskSymbol && index < numbers.endIndex {
                
                    result.append(numbers[index])
                    attRes.append(numbers[index])
                
                index = numbers.index(after: index)
            } else {
                attRes.append(ch)
                if index < numbers.endIndex{
                result.append(ch)
                }
            }
        }

        let attributedString = NSMutableAttributedString(string:attRes)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: appearance.colors.white , range: NSRange(location: 0, length: result.count))
        maskTextField.attributedText = attributedString
        if result.count == 0{
            maskTextField.text = ""
        }
        textField.text = result
        
        var arbitraryValue: Int
        if (rangeOfSymbols.filter({ ($0 == range.location) }).count > 0) && range.length == 0 {
            arbitraryValue = rangeForEdit.location + 2
        } else {
            arbitraryValue = rangeForEdit.location + 1
        }
        if range.length == 1 {
            arbitraryValue = rangeForEdit.location
        }
        

        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: arbitraryValue) {

            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        if (textField.text?.count ?? 0) > 0 {
            staticLabel.textColor = appearance.colors.dark_main
        } else {
            staticLabel.textColor = .lightGray
        }
        if (textField.text?.count ?? 0) == maskHolder.count {
            isValid = true
        } else {
            isValid = false
        }
//        setNormalState()
        modifyBorders?()
    }
    
    func addRedMark(){
        let mark = UILabel()
        mark.textColor = .red
        mark.text = "*"
        mark.font = BaseFont().get(.medium, 16)
        addSubview(mark)
        mark.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.top).offset(-7)
            make.left.equalTo(titleLabel).offset(-7)
        }
    }
  
}

extension MaskedTextFieldWithTitle: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if maskedHolder == nil {
                return true
            }
            maskedHolder?(textField, range, string)
            return false
        }
}
