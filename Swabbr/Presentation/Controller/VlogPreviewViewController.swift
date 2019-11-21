//
//  VlogPreviewViewController.swift
//  Swabbr
//
//  Created by James Bal on 08-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class VlogPreviewViewController: UIViewController, BaseViewProtocol {
    
    let playerView = UIView()
    let player: AVPlayer!
    
    let slider = UISlider(frame: .zero)
    let duration = UILabel()
    let currentDuration = UILabel()
    let pausePlayButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    var isPlaying = false
    
    // testing purposes
    init() {
        player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(url: URL) {
        player = AVPlayer(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(deniedToUpload))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(agreedToUpload))
        
        initElements()
        applyConstraints()

    }
    
    func initElements() {
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        playerView.layer.addSublayer(playerLayer)
        
        view.addSubview(playerView)
        view.addSubview(slider)
        view.addSubview(duration)
        view.addSubview(currentDuration)
        view.addSubview(pausePlayButton)
        
        slider.minimumValue = 0
        slider.maximumValue = Float(player.currentItem!.asset.duration.seconds)
        slider.isContinuous = false
        
        duration.text = stringFromSeconds(Int64(CMTimeGetSeconds(player.currentItem!.asset.duration)))
        currentDuration.text = "00:00"
        
        pausePlayButton.addTarget(self, action: #selector(clickedPlayButton), for: .touchUpInside)
        
        slider.addTarget(self, action: #selector(handlePlayheadSlideTouchBegin), for: .touchDown)
        slider.addTarget(self, action: #selector(handlePlayheadSlideTouchEnd), for: .touchUpInside)
        slider.addTarget(self, action: #selector(handlePlayheadSlideTouchEnd), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(handlePlayheadSlideValueChanged), for: .valueChanged)
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1,preferredTimescale: 1), queue: DispatchQueue.main, using: { [unowned self] time -> Void in
            if self.player.currentItem?.status == .readyToPlay {
                let time: Float64 = CMTimeGetSeconds(self.player.currentTime())
                self.slider.value = Float(time)
                self.currentDuration.text = self.stringFromSeconds(Int64(self.slider.value))
            }
        })
        
        player.play()
        isPlaying = true
    }
    
    func applyConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        currentDuration.translatesAutoresizingMaskIntoConstraints = false
        pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            pausePlayButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            pausePlayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            duration.leftAnchor.constraint(equalTo: pausePlayButton.rightAnchor),
            duration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            currentDuration.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            currentDuration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            slider.leftAnchor.constraint(equalTo: duration.rightAnchor),
            slider.rightAnchor.constraint(equalTo: currentDuration.leftAnchor),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            slider.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    @objc private func agreedToUpload() {
        
    }
    
    @objc private func deniedToUpload() {
        
    }
    
    private func stringFromSeconds(_ _seconds: Int64) -> String {
        let seconds = _seconds % 60
        let minutes = Int(_seconds / 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func clickedPlayButton() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    @objc func handlePlayheadSlideTouchBegin() {
        player.pause()
        isPlaying = false
    }
    
    @objc func handlePlayheadSlideValueChanged(_ sender: UISlider) {
        let seconds: Int64 = Int64(sender.value)
        currentDuration.text = stringFromSeconds(seconds)
    }
    
    @objc func handlePlayheadSlideTouchEnd(_ sender: UISlider) {
        let seconds: Int64 = Int64(sender.value)
        let seekToTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: seekToTime)
    }
    
}
