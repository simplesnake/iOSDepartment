//
//  VideoView.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    
    //MARK: - структуры и перечисления
    struct Data {
        var videoURL: URL?
        var showDuration: Bool = false
    }
    
    //MARK: - элементы UI
    private lazy var videoPlayer: MediaPlayer = {
        let player = MediaPlayer()
        player.durationDidLoad = { [weak self] duration in
            guard let self = self else { return }
            
            let formattedDuration = TimeInterval(duration).formattedString()
            self.durationLabel.text = formattedDuration
        }
        return player
    }()
    
    private lazy var videoPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = .white
        return view
    }()
    
    private lazy var playIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.systemIcon(named: "play.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var durationBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 13
        view.isHidden = true
        return view
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var tapButton: BaseButton = {
        let button = BaseButton()
        button.onTap = { [weak self] button in
            guard let self = self else { return }
            openVideoController()
        }
        return button
    }()
    
    
    //MARK: - переменные
    var data: Data! {
        didSet {
            setupVideoPlayer()
            playerViewController = CustomPlayerViewController(player: videoPlayer.player)
            
            if data.showDuration {
                durationBgView.isHidden = false
            }
        }
    }
    
    var playerViewController: CustomPlayerViewController?
    var onTap: ((AVPlayer, CustomPlayerViewController) -> ())?
    
    
    //MARK: - конструкторы
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - настройка UI
    private func setupUI() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(videoPreviewImageView)
        videoPreviewImageView.addSubview(activityIndicator)
        videoPreviewImageView.addSubview(playIcon)
        videoPreviewImageView.addSubview(durationBgView)
        videoPreviewImageView.addSubview(tapButton)
        durationBgView.addSubview(durationLabel)
    }
    
    private func addConstraints() {
        videoPreviewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        playIcon.snp.makeConstraints { make in
            make.height.width.equalTo(38)
            make.center.equalToSuperview()
        }
        
        durationBgView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.height.equalTo(26)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - методы и функции
    private func setupVideoPlayer() {
        guard let videoURL = data.videoURL else { return }
        
        activityIndicator.startAnimating()
        videoPlayer.generateFirstFrameOfVideo(url: videoURL) { [weak self] image in
            guard let self = self else { return }
            
            activityIndicator.stopAnimating()
            videoPreviewImageView.image = image
            playIcon.isHidden = false
            
        }
        videoPlayer.setupPlayer(with: videoURL)
    }
    
    private func openVideoController() {
        guard let player = videoPlayer.player, let playerViewController = playerViewController else { return }
        onTap?(player, playerViewController)
    }
}
