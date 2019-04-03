//
//  MusicOperationTools.swift
//  Robot
//
//  Created by Hunter on 2019/3/19.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicOperationTools: NSObject {
    static let shareInstance = MusicOperationTools()
    let tool = MusicPlayerTools()
    var musicMs: [MusicModel] = [MusicModel]()
    fileprivate var lastRow = -1
    fileprivate var artWork: MPMediaItemArtwork?
    
    fileprivate var currentPlayIndex = 0 {
        didSet {
            if currentPlayIndex < 0{
                currentPlayIndex = (musicMs.count) - 1
            }
            if currentPlayIndex > (musicMs.count) - 1{
                currentPlayIndex = 0
            }
        }
    }
    
    fileprivate var musicMessageM = MusicMessageModel()
    func getMusicMessageModel() -> MusicMessageModel {
        if musicMs == nil {
            return musicMessageM
        }
        musicMessageM.musicM = musicMs[currentPlayIndex]
        musicMessageM.costTime = (tool.player?.currentTime) ?? 0
        musicMessageM.totalTime = (tool.player?.duration) ?? 0
        musicMessageM.isPlaying = (tool.player?.isPlaying) ?? false
        return musicMessageM
    }
    
    func playMusic(_ musicM: MusicModel) {
        if tool.playMusic(musicM.url){
            currentPlayIndex = musicMs.index(of: musicM)!
        }else{
            print("fault")
            
        }
    }
    
    func playCurrentMusic() {
       let model = musicMs[currentPlayIndex]
        playMusic(model)
//        if tool.player == nil {
//            let model = musicMs[currentPlayIndex]
//            playMusic(model)
//        }else{
//            tool.playCurrentMusic()
//        }
    }
    
    func pauseCurrentMusic() {
        tool.pauseMusic()
    }
    
    func nextMusic()  {
        tool.stopCurrentMusic()
        currentPlayIndex += 1
        let model = musicMs[currentPlayIndex]
        playMusic(model)
    }
    
    func preMusic()  {
        tool.stopCurrentMusic()
        currentPlayIndex -= 1
        let model = musicMs[currentPlayIndex]
        playMusic(model)
    }
    
    func seekToTime(_ time: TimeInterval) {
        tool.seekToTime(time)
    }
    
    func forward(){
        tool.fastforward(10)
    }
    
    func backward(){
        tool.fastbackward(10)
    }
    
//    func volume(_ value : Float){
//        tool.volume(value)
//    }
    
    func setupLockMessage() {
        let musicMessageM = getMusicMessageModel()
        let center = MPNowPlayingInfoCenter.default()
        
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let costTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTime
        
        let dic: NSMutableDictionary = [
            MPMediaItemPropertyAlbumTitle: musicName,
            MPMediaItemPropertyArtist: singerName,
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime
        ]
        if artWork != nil {
            dic.setValue(artWork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        let dicCopy = dic.copy()
        center.nowPlayingInfo = dicCopy as? [String: Any]
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
}
