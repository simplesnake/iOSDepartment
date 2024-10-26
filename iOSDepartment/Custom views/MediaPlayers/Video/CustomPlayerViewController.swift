//
//  CustomPlayerViewController.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import AVKit

class CustomPlayerViewController: AVPlayerViewController {
    
    // MARK: - UI элементы
    private lazy var secureTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    // MARK: - конструкторы
    init(player: AVPlayer?) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - жизненный цикл контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSecureTextField()
        addSwipeToDismissGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopVideo()
    }
    
    
    // MARK: - настройка UI
    private func setupAppearance() {
        allowsPictureInPicturePlayback = false
        modalPresentationStyle = .overFullScreen
    }
    
    private func setupSecureTextField() {
        view.addSubview(secureTextField)
        secureTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - методы и функции
    func stopVideo() {
        player?.seek(to: .zero)
        player?.pause()
    }
}
