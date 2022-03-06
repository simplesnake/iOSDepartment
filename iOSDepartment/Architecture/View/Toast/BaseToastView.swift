//
//  BaseToastView.swift
//  iOSDepartment
//
//  Created by Александр Строев on 10.09.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import UIKit

final class BaseToastView: UIView {
    
    var swipeLeft: (() -> ())?
    var swipeRight: (() -> ())?
    var onTap: (() -> ())?
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        
        view.font = appearance.fonts.regularButtonFontExample
        return view
    }()

    var text: String? {
        get {
            return self.messageLabel.text
        }

        set(text) {
            self.messageLabel.text = text ?? ""
        }
    }
    
    lazy var gestureView: UIView = {
        let view = UIView()
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeLeft))

        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeRight))
        
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        return view
    }()
    
    @objc func onSwipeLeft() { swipeLeft?() }
    @objc func onSwipeRight() { swipeRight?() }
    @objc func onTapGesture() { onTap?() }
    
    init(_ message: String){
        super.init(frame: CGRect())
        addSubview(messageLabel)
        addSubview(gestureView)
        gestureView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.left.right.equalToSuperview()
        }
        messageLabel.text = message
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class Timings {
        static let enter: TimeInterval = 0.2
        static let waiting: TimeInterval = 3
        static let exit: TimeInterval = 0.3
    }
}




