//
//  MySkillVC.swift
//  Robot
//
//  Created by Hunter on 2019/2/24.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit

class MySkillVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title="我的技能详情"
        //方法三： 异步加载网络图片
        //创建URL对象
        let url = URL(string:"http://qukufile2.qianqian.com/data2/pic/10be98302963b47c27939cf3440e6efb/608130795/608130795.jpg@s_1,w_224,h_224")!
        //创建请求对象
        // 从url上获取内容
        // 获取内容结束才进行下一步
        let data = try? Data(contentsOf: url)
        
        if data != nil {
            let image = UIImage(data: data!)
            //let imgg = UIImage(named: "9_背景")
            self.img.image = image
    }
    }
    
}
