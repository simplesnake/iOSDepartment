//
//  UIAlertController+Extensions.swift
//  iOSDepartment
//
//  Created by 7Winds - Sokol on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import UIKit

public extension UIAlertController {
    private static var globalPresentationWindow: UIWindow?
    
    private static var textColor: UIColor { .white }
    private static var backgroundColor: UIColor { .black }
     
    func show() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
            return
        }
    }
    
    
     
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIAlertController.globalPresentationWindow?.isHidden = true
        UIAlertController.globalPresentationWindow = nil
    }
    
    static func showOkDailog(title: String, message: String, onOk: (() -> ())? = nil) {
        let alert = getDarkDialog(title: title, message: message)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { alert in onOk?() }))
        alert.show()
    }
    
    static func getDarkDialog(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .dark
        }
        
        if let bgView = alert.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = backgroundColor
        }

        alert.view.tintColor = textColor
        
        if let title = title {
            let attributedTitle = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : BaseFont().get(.regular, 13),
                NSAttributedString.Key.foregroundColor : textColor
            ])
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }

        if let message = message {
            let attributedMessage = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.font : BaseFont().get(.regular, 13),
                NSAttributedString.Key.foregroundColor : textColor
            ])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
        }
        
        return alert
    }
    
    static func showYesNoDialog(title: String, message: String, onYes: (() -> ())?, onNo: (() -> ())? = nil, yesTitle: String = "Да", noTitle: String = "Нет") {
        let alert = getDarkDialog(title: title, message: message)

        alert.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: { (action: UIAlertAction!) in
            onNo?() ?? alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: yesTitle, style: .default, handler: { (action: UIAlertAction!) in
            onYes?() ?? alert.dismiss(animated: true, completion: nil)
        }))

        alert.show()
    }
    
    static func getDarkDialogList(title: String? = nil, message: String? = nil) -> UIAlertController {
        let alert = getDarkDialog(title: title, message: message, preferredStyle: .actionSheet)
        
        if let title = title {
            let attributedTitle = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : BaseFont().get(.regular, 13),
                NSAttributedString.Key.foregroundColor : textColor
            ])
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        return alert
    }
}

extension UIView {
    private struct AssociatedKey {
        static var subviewsBackgroundColor = "subviewsBackgroundColor"
    }

    @objc dynamic var subviewsBackgroundColor: UIColor? {
        get {
          return objc_getAssociatedObject(self, &AssociatedKey.subviewsBackgroundColor) as? UIColor
        }

        set {
          objc_setAssociatedObject(self,
                                   &AssociatedKey.subviewsBackgroundColor,
                                   newValue,
                                   .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
          subviews.forEach { $0.backgroundColor = newValue }
        }
    }
}

