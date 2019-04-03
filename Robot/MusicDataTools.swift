//
//  MusicDataTools.swift
//  Robot
//
//  Created by Hunter on 2019/4/1.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicMs(_ result: ([MusicModel])->()) {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([MusicModel]())
            return
        }
        guard let array = NSArray(contentsOfFile: path) else {
            result([MusicModel]())
            return
        }
        var musicMs = [MusicModel]()
        for dic in array {
            let musicM = MusicModel(dic: dic as! [String : Any])
            musicMs.append(musicM)
        }
        result(musicMs)
    }
   
}
