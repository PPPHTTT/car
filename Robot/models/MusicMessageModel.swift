//
//  MusicMessageModel.swift
//  Robot
//
//  Created by Hunter on 2019/3/19.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit

class MusicMessageModel: NSObject {
    var musicM: MusicModel?
    var costTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var isPlaying: Bool = false
    var costTimeFormat: String {
        get {
            return MusicTimeTools.getFormatTime(costTime)
        }
    }
    var totalTimeFormat: String {
        get {
            return MusicTimeTools.getFormatTime(totalTime)
        }
    }
}
