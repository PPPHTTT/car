//
//  MusicPlayerTools.swift
//  Robot
//
//  Created by Hunter on 2019/3/19.
//  Copyright © 2019 Hunter. All rights reserved.
//


import UIKit
import AVFoundation

let kPlayFinishNotification = "playFinish"

class MusicPlayerTools: NSObject {
    
    var player: AVAudioPlayer?
    var volume: Float = 50
    override init() {
        super.init()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback,mode: AVAudioSession.Mode.default,options: AVAudioSession.CategoryOptions.allowBluetoothA2DP)//后台播放
            try session.setActive(true)
        }catch {
            print(error)
            return
        }
    }
    
    func seekToTime(_ time: TimeInterval) {
        player?.currentTime = time
    }
    
    func playMusic(_ url: String?) -> Bool {
        //guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {return}
//        if (player?.url)! == URL(string: url!)! {
//            player?.play()
//            return
//        }
        do {
            let data:Data? = try Data(contentsOf: URL(string: url!)!)
            if data == nil {
                print("播失败")
                return false
            }
            player = try AVAudioPlayer(data: data!)
            if player == nil {
                print("播失败")
                return false
            }
            //player?.data = try! Data(contentsOf: URL(string: url!)!)
            //player = try AVAudioPlayer(contentsOf: URL(string: url!)!)

            player?.delegate = self as AVAudioPlayerDelegate
            player?.enableRate = true// 设置可以速率播放
            player?.prepareToPlay()
            player?.volume = volume
            player?.play()
            //print(player?.duration)
        }catch {
            print(error)
            return false
        }
        return true
    }
    
    func pauseMusic()  {
        player?.pause()
    }
    
    func playCurrentMusic()  {
        player?.play()
    }
    
    func stopCurrentMusic() {
        player?.currentTime = 0
        player?.stop()
    }
    
    func fastforward(_ value:TimeInterval){
        player?.currentTime += value
    }
    
    func fastbackward(_ value:TimeInterval){
        player?.currentTime -= value
    }
    
    
//    func volume(_ value : Float){//1.0 is full
//        volume = value
//        player?.volume = volume
//    }
}
//监听音乐是否播放完毕
extension MusicPlayerTools: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: kPlayFinishNotification), object: nil)
        //MusicOperationTools.shareInstance.nextMusic()
    }
}
