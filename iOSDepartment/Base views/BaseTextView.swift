//
//  BaseTextView.swift
//  WishBoxReborn
//
//  Created by 7Winds on 17.12.2021.
//

import Foundation
import UIKit

class BaseTextView: UITextView {
    
    var shouldChangeTextInRange: ((BaseTextView, NSRange, String) -> Bool)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    
    override init(frame: CGRect = CGRect.zero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        
        textContainer?.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
