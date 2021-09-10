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
    
    var localization: AuthorizationLocalization!
    var presenter: AuthorizationViewOutput!
    
    private lazy var button: BaseButton = {
        let button = BaseButton()
        button.setTitle("Жми сюда", for: .normal)
        button.onTap = {
            [weak self] _ in
            guard let self = self else { return }
            self.presenter.authorizationButtonTap(login: "simplesnake@mail.ru", password: "000000")
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupUI()
    }
    
    func setupUI() {
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

class X {
    var x: Int?
    
    init(x: Int) {
        self.x = x
    }
}

class Y: X {
    var y: Int?
    
    init(x: Int, y: Int) {
        super.init(x: x)
        self.y = y
    }
}
