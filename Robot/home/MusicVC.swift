//
//  MusicVC.swift
//  Robot
//
//  Created by Hunter on 2019/3/5.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit

class MusicVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    let SCALE = UIScreen.main.bounds.width/750 //ratio
    let tool = toolfuncs()
    
    
    @IBOutlet weak var musicTV: UITableView!
    
    
    var musicMs: [MusicModel] = [MusicModel]() {
        didSet {
            musicTV.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.musicTV.dequeueReusableCell(withIdentifier: "musicCell")! as UITableViewCell
        let seqs = cell.viewWithTag(101) as! UILabel
        let playMark = cell.viewWithTag(100) as! UIImageView
        //let musicImg = cell.viewWithTag(102) as! UIImage
        let title = cell.viewWithTag(103) as! UILabel
        let musician = cell.viewWithTag(104) as! UILabel
        let playBut = cell.viewWithTag(105) as! UIButton
        seqs.text = "\(indexPath.row+1)"
        playMark.isHidden = true
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150*SCALE
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "musicDetailVC") as! MusicDetailVC
        self.navigationController?.show(vc, sender:tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "更多歌曲"
        //get height
        let naviH = self.navigationController?.navigationBar.frame.height
        let statusbarHeight = UIApplication.shared.statusBarFrame.height //获取statusBar的高度
        //get tab bar height
        let tabbarH = self.tabBarController?.tabBar.frame.height
        let toH = statusbarHeight+naviH!
        musicTV.delegate = self
        musicTV.dataSource = self
        tool.defConstraints(musicTV,nil, toH, tabbarH!, 0, 0)
//        
    }
    
    
}

