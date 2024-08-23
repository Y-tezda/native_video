//
//  ViewController.swift
//  Runner
//
//  Created by Ichin Wilder on 22/08/24.
//

import UIKit
import AVFoundation
import AVKit


extension AVPlayerViewController {
    func disableGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: nil)
        self.view.addGestureRecognizer(panGesture)
    }
}


class ViewController: UIViewController {

    
    var _url:String = ""
    let container = UIView()

    func setUrl(url:String)
    {
        _url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        playLocalVideo()
     
    }
    
    
    
    func playLocalVideo() {

        print("working with video link")
        
        let url = URL(string:"https://cdn.flowplayer.com/a30bd6bc-f98b-47bc-abf5-97633d4faea0/hls/de3f6ca7-2db3-4689-8160-0f574a5996ad/playlist.m3u8")!
        let player = AVPlayer(url: url)
       
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.videoGravity = .resizeAspectFill
        playerController.disableGesture()
        playerController.entersFullScreenWhenPlaybackBegins = false
        
        container.addSubview(playerController.view)
            NSLayoutConstraint.activate([
            playerController.view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            playerController.view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            playerController.view.widthAnchor.constraint(equalTo: container.widthAnchor),
            playerController.view.heightAnchor.constraint(equalTo: container.heightAnchor)
           ])

        present(playerController, animated: true) {
            player.play()
        }
        
        
    }
}
