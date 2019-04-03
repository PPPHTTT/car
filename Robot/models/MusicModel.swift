//
//  MusicModel.swift
//  Robot
//
//  Created by Hunter on 2019/3/19.
//  Copyright © 2019 Hunter. All rights reserved.
//


import UIKit

class MusicModel: NSObject {
    var name: String?
    var url: String?
    //var lrcname: String?
    var singer: String?
    var image: String?
    
    override init() {
        super.init()
    }
    
    init(dic: [String: Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
