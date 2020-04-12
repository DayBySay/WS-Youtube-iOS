//
//  ViewController.swift
//  WS-Youtube
//
//  Created by Takayuki Sei on 2020/04/12.
//  Copyright © 2020 takayuki sei. All rights reserved.
//

import UIKit
import YoutubePlayerView

class ViewController: UIViewController {
    @IBOutlet weak var youtubeView: YoutubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "rel": 0,
            "showinfo": 0,
            "autoplay": 1
        ]
        youtubeView.loadWithVideoId("1JdMxfTjkPE", with: playerVars)
    }
}

