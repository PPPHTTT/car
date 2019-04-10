//
//  MusicVC.swift
//  Robot
//
//  Created by Hunter on 2019/3/5.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit
import SnapKit

class MusicVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //let SCALE = UIScreen.main.bounds.width/750 //ratio
    let tool = toolfuncs()
    
    
    @IBOutlet weak var musicTV: UITableView!
    
    
    var musicMs: [MusicModel] = [MusicModel]() {
        didSet {
            musicTV.reloadData()
        }
    }
 
    @IBAction func playButton(_ sender: UIButton) {
        let  cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let  path:IndexPath = musicTV.indexPath(for: cell)!
        if sender.isSelected {
            //pause
            MusicOperationTools.shareInstance.pauseCurrentMusic()
        }else{
            //play
            //若当前未播放音乐或所播放音乐不同，则重新播放
            if (MusicOperationTools.shareInstance.tool.player == nil)||MusicOperationTools.shareInstance.getCurIndex() != path.row{
                MusicOperationTools.shareInstance.playMusic(musicMs[path.row])
            }else{                
                MusicOperationTools.shareInstance.playCurrentMusic()
            }
        }
        //sender.isSelected = !sender.isSelected
        musicTV.reloadData()
    }
    
    //设置行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicOperationTools.shareInstance.musicMs.count
    }
    //设置每个cell返回的内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.musicTV.dequeueReusableCell(withIdentifier: "musicCell")! as UITableViewCell
        let seqs = cell.viewWithTag(101) as! UILabel
        let playMark = cell.viewWithTag(100) as! UIImageView
        let musicImg = cell.viewWithTag(102) as! UIImageView
        let title = cell.viewWithTag(103) as! UILabel
        let musician = cell.viewWithTag(104) as! UILabel
        let playBut = cell.viewWithTag(105) as! UIButton
        seqs.text = "\(indexPath.row+1)"
        musicImg.image = UIImage(data: try! Data(contentsOf: URL(string: musicMs[indexPath.row].image!)!))
        title.text = musicMs[indexPath.row].name
        musician.text = musicMs[indexPath.row].singer
        
        playBut.setBackgroundImage(UIImage(named: "播放3"), for: .normal)
        playBut.setBackgroundImage(UIImage(named: "播放2"), for: .selected)
        //根据是否正在播放现实不同图片
        if indexPath.row == MusicOperationTools.shareInstance.getCurIndex()&&MusicOperationTools.shareInstance.getMusicMessageModel().isPlaying{
            playBut.isSelected = true
            playMark.isHidden = false
            seqs.isHidden = true
        }else{
            playBut.isSelected = false
            playMark.isHidden = true
            seqs.isHidden = false
        }
        
        //进行约束控制
        seqs.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(cell.snp.left).offset(30*tool.WSCALE)
            make.centerY.equalTo(cell)
        }
        seqs.font = UIFont.systemFont(ofSize: 33*tool.WSCALE, weight: UIFont.Weight.regular)
        playMark.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(cell.snp.left).offset(30*tool.WSCALE)
            make.width.equalTo(23*tool.WSCALE)
            make.height.equalTo(28*tool.WSCALE)
            make.centerY.equalTo(cell)
        }
        musicImg.snp.makeConstraints{ (make) -> Void  in
            make.width.height.equalTo(90*tool.WSCALE)
            make.centerY.equalTo(cell)
            make.left.equalTo(cell.snp.left).offset(80*tool.WSCALE)
        }
        title.snp.makeConstraints { (make) -> Void  in
            //make.size.equalTo(32*tool.WSCALE)
            make.left.equalTo(musicImg.snp.right).offset(30*tool.WSCALE)
            make.top.equalTo(cell.snp.top).offset(35*tool.WSCALE)
        }
        title.font = UIFont.systemFont(ofSize: 32*tool.WSCALE, weight: UIFont.Weight.regular)
        musician.snp.makeConstraints{ (make) -> Void  in
            //make.size.equalTo(24*tool.WSCALE)
            make.left.equalTo(musicImg.snp.right).offset(30*tool.WSCALE)
            make.top.equalTo(title.snp.bottom).offset(15*tool.WSCALE)
        }
        musician.font = UIFont.systemFont(ofSize: 24*tool.WSCALE, weight: UIFont.Weight.regular)
        
        playBut.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(54*tool.WSCALE)
            make.right.equalTo(cell.snp.right).offset(-30*tool.WSCALE)
            make.centerY.equalTo(cell.snp.centerY)
        }
        return cell
    }
    //返回自适应高度
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150*tool.WSCALE
    }
    //设置点击事件
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "musicDetailVC") as! MusicDetailVC
        //若当前未播放音乐或所播放音乐不同，则重新播放
        if (MusicOperationTools.shareInstance.tool.player == nil)||MusicOperationTools.shareInstance.getCurIndex() != indexPath.row{
            MusicOperationTools.shareInstance.playMusic(musicMs[indexPath.row])
        }
        self.navigationController?.show(vc, sender:tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView()
        musicMs = MusicOperationTools.shareInstance.musicMs
        
//        
    }
    //加载界面时执行，为了使在子界面播放/暂停/切换 音乐后保持同步
    override func viewWillAppear(_ animated: Bool) {
        musicTV.reloadData()
    }
    
    //将部分初始化视图的j语句提取出来
    func initView(){
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
    
        
    }
    
    
}

