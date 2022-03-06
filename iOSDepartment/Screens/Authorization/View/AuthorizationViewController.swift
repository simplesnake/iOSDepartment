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
    
    //MARK: - архитектура
    var localization: AuthorizationLocalization!
    var presenter: AuthorizationViewOutput!
    
    //MARK: - структуры и перечисления
    
    
    //MARK: - элементы UI
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
    
    //MARK: - переменные
    
    
    //MARK: - жизненный цикл контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: - настройка UI
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
    
    //MARK: - методы и функции
}
