//
//  MediaPlayer.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import AVFoundation
import UIKit

class MediaPlayer: NSObject {
    
    //MARK: - структуры и перечисления
    enum PlaybackState {
        case playing
        case paused
        case stopped
    }
    
    
    // MARK: - свойства
    private(set) var player: AVPlayer?
    private(set) var playerItem: AVPlayerItem?
    
    private var durationObserver: NSKeyValueObservation?
    private var timeObserverToken: Any?
    
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    var durationDidLoad: ((Double) -> Void)?
    var timeDidUpdate: ((Double) -> Void)?
    var stateChanged: ((PlaybackState) -> Void)?
    
    
    // MARK: - настройка аудио/видео плеера
    func setupPlayer(with url: URL?) {
        guard let url else { return }
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        setupObservers()
    }
    
    func generateFirstFrameOfVideo(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVURLAsset(url: url)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.apertureMode = .encodedPixels
        
        let startTime = CMTime(seconds: 0, preferredTimescale: 600)
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: startTime)]) {
            [weak self] _, cgImage, _, _, error in
            guard self != nil else { return }
            
            if let error {
                print("Error generating image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let cgImage else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(cgImage: cgImage))
            }
        }
    }
    
    
    // MARK: - управление воспроизведением
    func play() {
        player?.play()
        stateChanged?(.playing)
    }
    
    func pause() {
        player?.pause()
        stateChanged?(.paused)
    }
    
    func stop() {
        player?.seek(to: .zero)
        pause()
        stateChanged?(.stopped)
    }
    
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: time)
    }
    
    
    // MARK: - настройка наблюдателей
    private func setupObservers() {
        setupDidFinishPlayingObserver()
        setupTimeObserver()
        setupDurationObserver()
    }
    
    private func setupDidFinishPlayingObserver() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            stop()
        }
    }
    
    private func setupTimeObserver() {
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            timeDidUpdate?(time.seconds)
        }
    }
    
    private func setupDurationObserver() {
        guard let playerItem else { return }
        
        durationObserver = playerItem.observe(\.duration, options: [.new, .initial]) { [weak self] item, _ in
            guard let self = self else { return }
            
            let duration = item.duration.seconds
            guard !duration.isNaN else { return }
            
            DispatchQueue.main.async {
                self.durationDidLoad?(duration)
            }
        }
    }
    
    
    // MARK: - Удаление наблюдателей
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
        durationObserver?.invalidate()
        durationObserver = nil
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
    }
    
    deinit {
        removeObservers()
    }
}
