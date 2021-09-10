//
//  AuthorizationViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 07.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit
import SnapKit

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
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
}
