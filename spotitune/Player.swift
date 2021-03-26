//
//  Player.swift
//  spotitune
//
//  Created by Sergio Herrera on 3/20/21.
//

import Foundation
import MediaPlayer

class Player {
    
    // avPlayer obj class property
    var avPlayer: AVPlayer!
    
    init() {
        avPlayer = AVPlayer()
    }
    
    func playStream(url: String) {
        // create url object
        let fileUrl = URL(string: url)
        
        // connect url obj to avPlayer object
        avPlayer = AVPlayer(url: fileUrl!)
        avPlayer.play()
        
        setPlayingScreen(fileUrl)
        
        print("playing stream")
    }
    
    func playAudio() {
        if (avPlayer.rate == 0 && avPlayer.error == nil) {
            avPlayer.play()
        }
    }
    
    func pauseAudio() {
        if (avPlayer.rate > 0 && avPlayer.error == nil) {
            avPlayer.pause()
        }
    }
    
    func setPlayingScreen(_ fileUrl: URL?) {
        if let url = fileUrl {
            let stringUrl = url.absoluteString
            let urlArray = stringUrl.components(separatedBy: "/")
            let name = urlArray[urlArray.endIndex-1]
            print(name)
            
            let songInfo = [
                MPMediaItemPropertyTitle: name,
                MPMediaItemPropertyArtist: "Spotitune"
            ]
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
    }
    
}
