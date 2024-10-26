//
//  AudioView.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import UIKit
import AVFoundation

final class AudioView: UIView {
    
    
    //MARK: - структуры и перечисления
    struct Data {
        var title: String
        var audioURL: URL?
        var duration: String? = nil
    }
    
    
    //MARK: - элементы UI
    private lazy var audioPlayer: MediaPlayer = {
        let player = MediaPlayer()
        player.stateChanged = { [weak self] state in
            guard let self = self else { return }
            updateUI(for: state)
        }
        player.durationDidLoad = { [weak self] duration in
            guard let self = self else { return }
            
            totalDurationLabel.text = data.duration ?? TimeInterval(duration).formattedString()
            audioSlider.maximumValue = Float(duration)
        }
        player.timeDidUpdate = { [weak self] currentTime in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.audioSlider.value = Float(currentTime)
                self.elapsedTimeLabel.text = TimeInterval(currentTime).formattedString()
            }
        }
        return player
    }()
    
    private lazy var playButton: AudioPlayButton = {
        let button = AudioPlayButton()
        button.audioState = .play
        button.onTap = { [weak self] button in
            guard let self = self else { return }
            
            playButtonTap?(button)
            togglePlayback()
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var audioSlider: AudioSlider = {
        let slider = AudioSlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.text = initialTimeValue
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalDurationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.text = initialTimeValue
        label.textAlignment = .right
        return label
    }()
    
    private lazy var additionallyButton: BaseButton = {
        let button = BaseButton()
        button.setImage(UIImage.systemIcon(named: "ellipsis", tintColor: .black), for: .normal)
        button.onTap = {
            [weak self] button in
            guard let self = self else { return }
            
            additionallyButtonTap?(button)
        }
        return button
    }()
    
    
    //MARK: - переменные
    var data: Data! {
        didSet {
            titleLabel.text = data.title
            audioPlayer.setupPlayer(with: data.audioURL)
        }
    }
    
    var playButtonTap: ((BaseButton)->Void)?
    var additionallyButtonTap: ((BaseButton)->Void)?
    
    private let initialTimeValue: String = "00:00"

    
    //MARK: - конструкторы
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(playButton)
        addSubview(playButton)
        addSubview(audioSlider)
        addSubview(titleLabel)
        addSubview(elapsedTimeLabel)
        addSubview(totalDurationLabel)
        addSubview(additionallyButton)
    }
    
    private func addConstraints() {
        playButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(38)
        }
        
        audioSlider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playButton.snp.trailing).offset(16)
            make.trailing.equalTo(additionallyButton.snp.leading).offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(audioSlider.snp.leading)
            make.trailing.equalTo(audioSlider.snp.trailing)
            make.bottom.equalTo(audioSlider.snp.top).offset(-6)
        }
        
        elapsedTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(audioSlider.snp.leading)
            make.top.equalTo(audioSlider.snp.bottom).offset(6)
        }
        
        totalDurationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(audioSlider.snp.trailing)
            make.top.equalTo(audioSlider.snp.bottom).offset(6)
        }
        
        additionallyButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    
    //MARK: - методы и функции
    private func updateUI(for state: MediaPlayer.PlaybackState) {
        switch state {
            case .playing:
                playButton.audioState = .pause
            case .paused:
                playButton.audioState = .play
            case .stopped:
                playButton.audioState = .play
                audioSlider.value = 0
                elapsedTimeLabel.text = initialTimeValue
        }
    }
    
    private func togglePlayback() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    @objc func sliderValueChanged() {
        audioPlayer.seek(to: Double(audioSlider.value))
    }
}
