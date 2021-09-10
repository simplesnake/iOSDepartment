//
//  KeyboardService.swift
//  MediaApp
//
//  Created by Строев Александр on 13.01.2020.
//  Copyright © 2020 Строев Александр. All rights reserved.
//

import UIKit

//keyboardBeginFrame - keyboardFrameBeginUserInfoKey
//keyboardEndFrame - keyboardFrameEndUserInfoKey
//keyboardBounds - UIKeyboardBoundsUserInfoKey
typealias KeyboardServiceCompletion = (_ keyboardBeginFrame: CGRect, _ keyboardEndFrame: CGRect, _ keyboardBounds: CGRect, _ safeInsets: UIEdgeInsets) -> Void
typealias KeyboardServiceHeightCompletion = (_ height: CGFloat) -> Void

class KeyboardService: NSObject{
    
    private var onShowKeyboardCallback: KeyboardServiceCompletion?
    private var onHideKeyboardCallback: KeyboardServiceCompletion?
    private var onChangeHeightCallback: KeyboardServiceHeightCompletion?
    private var safeAreaInsets: UIEdgeInsets = .zero
    var lastHeight: CGFloat = 0.0
    
    override init() {
        super.init()
        addListner()
        //fixIssue()
        getSafeAreaInsets()
    }
    
    func onShowKeyboard(completion: @escaping KeyboardServiceCompletion){
        onShowKeyboardCallback = completion
    }
    
    func onHideKeyboard(completion: @escaping KeyboardServiceCompletion){
        onHideKeyboardCallback = completion
    }
    
    func onChangeHeight(completion: @escaping KeyboardServiceHeightCompletion){
        onChangeHeightCallback = completion
    }
    
    private func addListner(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //bellow need cuz first time keyboard appear (from start app) begin size not correct, then right after.. so we need show/hide fast keyboard for avoid this
    /*private func fixIssue(){
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }*/
    
    private func getSafeAreaInsets(){
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        }
    }
    
    @objc private func willShowKeyboard(_ notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        // Get keyboard frames
        if let keyboardBeginValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue, let keyboardEndValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let keyboardBoundsValue = userInfo["UIKeyboardBoundsUserInfoKey"] as? NSValue{
            checkHeight(bounds: keyboardBoundsValue.cgRectValue)
            onShowKeyboardCallback?(keyboardBeginValue.cgRectValue, keyboardEndValue.cgRectValue, keyboardBoundsValue.cgRectValue, safeAreaInsets)
        }
    }
    
    @objc private func willHideKeyboard(_ notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        // Get keyboard frames
        if let keyboardBeginValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue, let keyboardEndValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let keyboardBoundsValue = userInfo["UIKeyboardBoundsUserInfoKey"] as? NSValue{
            //force hide keyboard
            checkHeight(bounds: .zero)
            onHideKeyboardCallback?(keyboardBeginValue.cgRectValue, keyboardEndValue.cgRectValue, keyboardBoundsValue.cgRectValue, safeAreaInsets)
        }
    }
    
    private func checkHeight(bounds: CGRect){
        let newHeight = max(bounds.height - safeAreaInsets.bottom, 0)
        if lastHeight != newHeight{
            lastHeight = newHeight
            onChangeHeightCallback?(newHeight)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
//        print("deinit - KeyboardService(Helpers 5)")
    }
}

