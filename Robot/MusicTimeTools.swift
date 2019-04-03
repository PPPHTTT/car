//
//  MusicTimeTools.swift
//  Robot
//
//  Created by Hunter on 2019/3/19.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit

class MusicTimeTools: NSObject {
    class func getFormatTime(_ timeInterval: TimeInterval) -> String {
        return String(format: "%02d: %02d", Int(timeInterval) / 60, Int(timeInterval) % 60)
    }
    
    class func getTimeInterval(_ formatTime: String) -> TimeInterval {
        let minSec = formatTime.components(separatedBy: ":")
        if minSec.count != 2 {
            return 0
        }
        let min = TimeInterval(minSec[0]) ?? 0.0
        let sec = TimeInterval(minSec[1]) ?? 0.0
        return min * 60.0 + sec
    }
}
