//
//  ViewController.swift
//  spotitune
//
//  Created by Sergio Herrera on 3/20/21.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var playPauseButton: UIButton!
    // create Player class obj
    var player: Player = Player()
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setSession()
        // subscribe to remote control event
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        // handle audio interruptions
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)

        let url = "https://www.herrera741.com/music_app/reptilia.mp3"
        player.playStream(url: url)
        onChangePlayButton()
        
    }
    
    func setSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        catch {
            print(error)
        }
    }

    @IBAction func playPauseButtonClick(_ sender: Any) {
        if (player.avPlayer.rate > 0) {
            player.pauseAudio()
        } else {
            player.playAudio()
        }
        onChangePlayButton()
    }
    
    func onChangePlayButton() {
        if (player.avPlayer.rate > 0) {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEvent.EventType.remoteControl {
            if event!.subtype == UIEvent.EventSubtype.remoteControlPause {
                print("pause")
                player.pauseAudio()
            }
            else if event!.subtype == UIEvent.EventSubtype.remoteControlPlay {
                print("playing")
                player.playAudio()
            }
        }
    }
    
    @objc func handleInterruption(notification: NSNotification) {
        player.pauseAudio()
        
        let interruptionTypeAsObj = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        
        let interruptionType = AVAudioSession.InterruptionType(rawValue: UInt(interruptionTypeAsObj.uint64Value))
        
        if let type = interruptionType {
            // interruption ended and have audio control back
            if type == .ended {
                player.playAudio()
            }
        }
    }
}

