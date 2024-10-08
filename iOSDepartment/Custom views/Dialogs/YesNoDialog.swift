//
//  YesNoDialog.swift
//  Mobilization
//
//  Created by on 21.06.2021.
//
import UIKit

//Пример кастомного диалога
final class YesNoDialog: UIView {
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = appearance.colors.dark_main
        view.textAlignment = .center
        view.numberOfLines = 0
        
        view.font = appearance.fonts.regularButtonFontExample
        return view
    }()
    var shadow: UIView?
    lazy var yesButton: BaseButton = {
        let view = BaseButton()
        view.text = "Да"
        view.layer.borderWidth = 2
        view.layer.borderColor = appearance.colors.dark_main.cgColor
        view.backgroundColor = appearance.colors.white
        view.setTitleColor(appearance.colors.dark_main, for: .normal)
        view.onTap = {
            [weak self] _ in
            self?.remove()
            (self?.yesTap ?? { return })()
        }
        return view
    }()

    lazy var noButton: BaseButton = {
        let view = BaseButton()
        view.text = "Нет"
        view.onTap = {
            [weak self] _ in
            self?.remove()
            (self?.noTap ?? { return })()
        }
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

    var yesTap: (()->())?
    var noTap: (()->())?
    
    func remove(){
        UIView.animate(withDuration: 0.1, animations:  {
            self.shadow?.alpha = 0
            self.alpha = 0
        }, completion: { _ in
        self.removeFromSuperview()
        self.shadow?.removeFromSuperview()
        })
    }
    
    init(message: String, onYesTap: (()->())?,onNoTap: (()->())?){
        super.init(frame: CGRect())
        addSubview(messageLabel)
        addSubview(noButton)
        addSubview(yesButton)
        messageLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
        }
        yesButton.snp.makeConstraints{ make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(12)
            make.width.equalTo(snp.width).dividedBy(2).offset(-20)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(48)
        }
        noButton.snp.makeConstraints{ make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(yesButton.snp.right).offset(20)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(48)
        }
        backgroundColor = appearance.colors.white
        messageLabel.text = message
        layer.cornerRadius = 2
        yesTap = onYesTap
        noTap = onNoTap
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
