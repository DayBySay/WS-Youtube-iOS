//
//  ViewController.swift
//  WS-Youtube
//
//  Created by Takayuki Sei on 2020/04/12.
//  Copyright © 2020 takayuki sei. All rights reserved.
//

import UIKit
import YoutubePlayerView
import Starscream

class ViewController: UIViewController {
    @IBOutlet weak var youtubeView: YoutubePlayerView!
    @IBOutlet weak var textField: UITextField!
    private var socket: WebSocket!
    private let playerVars: [String: Any] = [
        "controls": 1,
        "modestbranding": 1,
        "playsinline": 1,
        "rel": 0,
        "showinfo": 0,
        "autoplay": 1
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeView.delegate = self
        // Do any additional setup after loading the view.
        var request = URLRequest(url: URL(string: "ws://127.0.0.1:5001")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.connect()
        socket.onEvent = { [weak self] event in
            switch event {
            case .text(let string):
                self?.handleReceiveMessage(string: string)
            case .binary(let json):
                self?.handleReceiveMessage(data: json)
            default:
                break
            }
        }
    }
    
    private func handleReceiveMessage(string: String) {
    }
    
    private func handleReceiveMessage(data: Data) {
        if let message = try? JSONDecoder().decode(Message.self, from: data) {
            print(message)
            switch message.type {
            case .play:
                youtubeView.loadWithVideoId(message.val, with: playerVars)
            case .pause:
                youtubeView.pause()
            case .stop:
                youtubeView.stop()
            case .seek:
                if let to = Float(message.val) {
                    youtubeView.seek(to: to, allowSeekAhead: true)
                }
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        textField.resignFirstResponder()
        youtubeView.loadWithVideoId(textField.text!, with: playerVars)
        
        let message = Message(type: .play, val: textField.text!)
        if let json = try? JSONEncoder().encode(message) {
            socket.write(data: json, completion: nil)
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        youtubeView.pause()
        let message = Message(type: .pause, val: "")
        
        if let json = try? JSONEncoder().encode(message) {
            socket.write(data: json, completion: nil)
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        youtubeView.stop()
        let message = Message(type: .stop, val: "")
        
        if let json = try? JSONEncoder().encode(message) {
            socket.write(data: json, completion: nil)
        }
    }
    
    struct Message: Codable {
        enum `Type`: String, Codable {
            case play
            case pause
            case seek
            case stop
        }
        
        let type: Type
        let val: String
    }
}

extension ViewController: YoutubePlayerViewDelegate {
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
//        let message = Message(type: .seek, val: "\(time)")
//
//        if let json = try? JSONEncoder().encode(message) {
//            socket.write(data: json, completion: nil)
//        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
