//
//  AudioPlayButton.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import UIKit

enum AudioPlayButtonState {
    case play
    case pause
    
    var icon: UIImage? {
        switch self {
            case .play:
                return UIImage.systemIcon(named: "play.circle.fill")
            case .pause:
                return UIImage.systemIcon(named: "pause.circle.fill")
        }
    }
}

class AudioPlayButton: BaseButton {
    
    var audioState: AudioPlayButtonState = .play {
        didSet {
            setBackgroundImage(audioState.icon, for: .normal)
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
