//
//  AuthorizationViewController.swift
//  iOSDepartment
//
//  Created by Fox on 24.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation
import UIKit

class AuthorizationViewController: BaseViewController {
    

    //MARK: - архитектура
    var localization: AuthorizationLocalization!
    var presenter: AuthorizationViewOutput!
    

    //MARK: - структуры и перечисления


    //MARK: - элементы UI
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        return view
    }()
    
    lazy var scrollContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var textContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var fieldsContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var buttonsContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    var titleLabel: UILabel?
    
    var subtitleLabel: UILabel?
    
    var phoneField: MaskedTextFieldWithTitle?
    
    var emailField: BaseTextField?
    
    var passwordField: BaseTextField?
    
    var loginButton: BaseButton?
    
    
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
        scrollContainer.addSubviews(
            logoView,
            textContainer,
            fieldsContainer,
            buttonsContainer
        )
        view.addSubviews(
            scrollView
        )
        scrollView.addSubviews(
            scrollContainer
        )
    }

    func makeConstraints() {
        logoView.snp.makeConstraints { make in
           
        }
    }
    
    //MARK: - методы и функции
}
