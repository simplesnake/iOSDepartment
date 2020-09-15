//
//  AuthorizationViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit
import SnapKit

extension AuthorizationViewController {
    
    struct Appearance {
        let buttonBottomMargin: CGFloat = 40
    }
    
    private var appearance: Appearance { return Appearance() }
}

class AuthorizationViewController: BaseViewController {
    
    weak var localization: AuthorizationLocalization!
    weak var presenter: AuthorizationViewOutput!
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Жми сюда", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .red
        addSubviews()
        makeConstraints()
    }
    
    func addSubviews() {
        self.view.addSubview(button)
    }

    func makeConstraints() {
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(appearance.buttonBottomMargin)
            make.centerX.equalToSuperview()
        }
    }
}
