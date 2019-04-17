//
//  MusicDetailVC.swift
//  Robot
//
//  Created by Hunter on 2019/3/11.
//  Copyright © 2019 Hunter. All rights reserved.
//
import UIKit
import SnapKit

class MusicDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var musicImg: UIImageView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var singerName: UILabel!
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var maxTime: UILabel!
    @IBOutlet weak var curTime: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    
    fileprivate var updateTimesTimer: Timer?
    let tool = toolfuncs()
    //弹出菜单
    var menuView : UIView = UIView()
    var menuControlView : UIView = UIView()
    var menuTV : UITableView = UITableView()
    var menuCloseButton : UIButton = UIButton()
    var playSequenceImage : UIImageView = UIImageView()
    var playSequenceText : UILabel = UILabel()
    var musicCount : UILabel = UILabel()
    var playSequenceButton : UIButton = UIButton()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(MusicOperationTools.shareInstance.musicMs.count)
        return MusicOperationTools.shareInstance.musicMs.count
    }
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return 100*tool.WSCALE
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let playMark = UIImageView()
        let musicName = UILabel()
        let album = UILabel()
        //init
        playMark.image = UIImage(named: "5_播放")
        cell.addSubview(playMark)
        musicName.text = "《\(MusicOperationTools.shareInstance.musicMs[indexPath.row].name!)》 \(MusicOperationTools.shareInstance.musicMs[indexPath.row].singer!)"
        musicName.font = UIFont.init(name: "PingFangSC", size: 28*tool.HSCALE)
        musicName.font = UIFont.systemFont(ofSize: 28*tool.HSCALE, weight: UIFont.Weight.regular)
        cell.addSubview(musicName)
        album.text = "- 郭德纲相声"
        album.font = UIFont.init(name: "PingFangSC", size: 24*tool.HSCALE)
        album.font = UIFont.systemFont(ofSize: 24*tool.HSCALE, weight: UIFont.Weight.regular)
        cell.addSubview(album)
        //约束
        playMark.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(28*tool.HSCALE)
            make.width.equalTo(23*tool.HSCALE)
            make.left.equalTo(cell.snp.left).offset(30*tool.WSCALE)
            make.centerY.equalTo(cell.snp.centerY)
        }
        if MusicOperationTools.shareInstance.getCurIndex() == indexPath.row {
            musicName.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(playMark.snp.right).offset(20*tool.WSCALE)
                make.centerY.equalTo(cell.snp.centerY)
            }
            musicName.textColor = UIColor(red: 0x37/255, green: 0x88/255, blue: 0xe4/255, alpha: 1)
            album.textColor = UIColor(red: 0x37/255, green: 0x88/255, blue: 0xe4/255, alpha: 1)
        }else{
            playMark.isHidden = true
            musicName.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(cell.snp.left).offset(30*tool.WSCALE)
                make.centerY.equalTo(cell.snp.centerY)
            }
            musicName.textColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1)
            album.textColor = UIColor(red: 0x99/255, green: 0x99/255, blue: 0x99/255, alpha: 1)
        }
        album.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(cell.snp.centerY)
            make.left.equalTo(musicName.snp.right).offset(10*tool.WSCALE)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        menuTV.delegate = self
        menuTV.dataSource = self
        musicSlider.value = 0
        curTime.text = "00:00"
        addTimer()
        
        //注册点击事件
        musicSlider.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(MusicDetailVC.handleTap(sender:))))
        playSequenceButton.addTarget(pthread_self(), action: #selector(MusicDetailVC.changeSeq(sender:)), for: .touchUpInside)
        menuCloseButton.addTarget(self, action: #selector(MusicDetailVC.closeMenu), for: UIControl.Event.touchUpInside)
        //z播放结束自动下一曲
        NotificationCenter.default.addObserver(self, selector: #selector(MusicDetailVC.nextMusic), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    //加载时执行
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOnce()
        addTimer()
    }
    //关闭时执行
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    /// 响应滑块拖动时的事件
    @IBAction func sliderValueChange(_ sender: Any) {
        //print("value:\((sender as! UISlider).value)")
        let costTime = MusicOperationTools.shareInstance.getMusicMessageModel().totalTime * TimeInterval(musicSlider.value)
        curTime.text = MusicTimeTools.getFormatTime(costTime)//更新已播放时长
        
    }
    @IBAction func touchDown() {
//print("touchDown")
         removeTimer()
    }
    @IBAction func touchUp() {
       // print("touchUp")
        addTimer()
        let costTime = MusicOperationTools.shareInstance.getMusicMessageModel().totalTime * TimeInterval(musicSlider.value)
        MusicOperationTools.shareInstance.seekToTime(costTime)//跳到指定时间点播放
    }
//    //bug exist?????????????????
//    @IBAction func tap(_ sender: UITapGestureRecognizer) {
//        print("tap")
//        sender.numberOfTapsRequired = 1
//        let value = sender.location(in: sender.view).x / (sender.view?.frame.width)!
//        musicSlider.value = Float(value)
//
//        let totalTime = MusicOperationTools.shareInstance.getMusicMessageModel().totalTime
//        let costTime = totalTime * TimeInterval(value)
//        MusicOperationTools.shareInstance.seekToTime(costTime)//跳到指定时间点播放
//      //  let totalTime = QQMusicOperationTool.shareInstance.getMusicMessageModel().totalTime
//       // let costTime = totalTime * TimeInterval(value)
//        //QQMusicOperationTool.shareInstance.seekToTime(costTime)//跳到指定时间点播放
//    }
    //--------------------------------------------------------------------//
    //对应方法
    //--------------------------------------------------------------------//
    @objc func handleTap(sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 1
        let value = sender.location(in: sender.view).x / (sender.view?.frame.width)!
        musicSlider.value = Float(value)
        
        let totalTime = MusicOperationTools.shareInstance.getMusicMessageModel().totalTime
        let costTime = totalTime * TimeInterval(value)
        MusicOperationTools.shareInstance.seekToTime(costTime)//跳到指定时间点播放
    }
    @objc func changeSeq(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            playSequenceImage.image = UIImage(named: "倒序")
            playSequenceText.text = "倒序播放"
        }else{
            playSequenceImage.image = UIImage(named: "顺序")
            playSequenceText.text = "顺序播放"
        }
        ///
        ///
        ///
        menuTV.reloadData()
    }
    //close menu button action
    @objc func closeMenu(){
        //动画
        UIView.animate(withDuration: 1, animations: {
            //也可以用改变的约束不多，也可以用snp_updateConstraints方法
            self.menuView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.bodyView.snp.bottom).offset(0)
            })
            //用来立即刷新布局（不写无法实现动画移动，会变成瞬间移动）
            self.view.layoutIfNeeded()
        })
        //menuView.isHidden = true
    }
    //5buttions
    @IBAction func likeMusic(_ sender: UIButton) {
    }
    @IBAction func preMusic(_ sender: UIButton) {
        MusicOperationTools.shareInstance.preMusic()
        updateOnce()
    }
    
    @IBAction func nextMusic(_ sender: UIButton) {
        MusicOperationTools.shareInstance.nextMusic()
        updateOnce()
    }
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            MusicOperationTools.shareInstance.playCurrentMusic()
        }else {
            MusicOperationTools.shareInstance.pauseCurrentMusic()
        }
    }
    
    @IBAction func menu(_ sender: Any) {
        menuView.isHidden = false
        //动画
        UIView.animate(withDuration: 1, animations: {
            //也可以用改变的约束不多，也可以用snp_updateConstraints方法
            self.menuView.snp.remakeConstraints({ (make) in
                make.width.equalTo(750*self.tool.WSCALE)
                make.height.equalTo(953*self.tool.HSCALE)
                make.bottom.equalTo(self.bodyView.snp.bottom).offset(0)
            })
            //用来立即刷新布局（不写无法实现动画移动，会变成瞬间移动）
            self.view.layoutIfNeeded()
        })
        
    }
    //初始化按钮约束和图片
    func initButtons(){
        playButton.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(maxTime.snp.bottom).offset(95*tool.HSCALE)
            make.centerX.equalTo(musicSlider)
            make.width.height.equalTo(124*tool.WSCALE)
        }
        
        previousButton.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(playButton.snp.left).offset(0-90*tool.WSCALE)
            make.centerY.equalTo(playButton)
            make.width.equalTo(34*tool.WSCALE)
            make.height.equalTo(38*tool.WSCALE)
        }
        
        nextButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(playButton.snp.right).offset(90*tool.WSCALE)
            make.centerY.equalTo(playButton)
            make.width.equalTo(34*tool.WSCALE)
            make.height.equalTo(38*tool.WSCALE)
        }
        likeButton.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(previousButton.snp.left).offset(0-80*tool.WSCALE)
            make.centerY.equalTo(playButton)
            make.width.equalTo(47*tool.WSCALE)
            make.height.equalTo(40*tool.WSCALE)
        }
        menuButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(nextButton.snp.right).offset(80*tool.WSCALE)
            make.centerY.equalTo(playButton)
            make.width.equalTo(48*tool.WSCALE)
            make.height.equalTo(38*tool.WSCALE)
        }
        likeButton.setBackgroundImage(UIImage(named: "喜欢1"), for: .normal)
        previousButton.setBackgroundImage(UIImage(named: "上一曲"), for: .normal)
        playButton.setBackgroundImage(UIImage(named: "4_播放1"), for: .normal)
        playButton.setBackgroundImage(UIImage(named: "暂停"), for: .selected)
        playButton.isSelected = true
        nextButton.setBackgroundImage(UIImage(named: "下一曲"), for: .normal)
        menuButton.setBackgroundImage(UIImage(named: "菜单"), for: .normal)
    }
    func initView(){
        /*********************************************************/
        //init view
        /*********************************************************/
        musicImg.layer.cornerRadius = 10
        //get height
        let naviH = self.navigationController?.navigationBar.frame.height
        let statusbarHeight = UIApplication.shared.statusBarFrame.height //获取statusBar的高度
        //get tab bar height
        let tabbarH = self.tabBarController?.tabBar.frame.height
        let toH = statusbarHeight+naviH!
        tool.defConstraints(bodyView,nil,toH,tabbarH!,0,0)
        musicImg.image = tool.scaleImage(musicImg.image!, 640, 640)
        musicImg.snp.makeConstraints{(make) -> Void in
            make.width.height.equalTo(640*tool.WSCALE)
            make.top.equalTo(bodyView.snp.top).offset(40*tool.HSCALE)
            make.centerX.equalTo(bodyView)
        }
        //tool.defConstraints(musicImg,nil,40*tool.HSCALE,nil,55*tool.WSCALE,55*tool.WSCALE)
        let topToImg:NSLayoutConstraint = NSLayoutConstraint(item: musicName, attribute: .top, relatedBy:.equal, toItem:musicImg, attribute:.bottom, multiplier:1.0, constant:44*tool.HSCALE)
        musicName.superview!.addConstraint(topToImg)
        let topToName:NSLayoutConstraint = NSLayoutConstraint(item: singerName, attribute:.top, relatedBy:.equal, toItem:musicName, attribute:.bottom, multiplier:1.0, constant:20*tool.HSCALE)
        singerName.superview!.addConstraint(topToName)
        //设置滑块的图片
        musicSlider.setThumbImage(UIImage(named:"播放条3"),for: .normal)
        let topToSinger:NSLayoutConstraint = NSLayoutConstraint(item: musicSlider, attribute:.top, relatedBy:.equal, toItem:singerName, attribute:.bottom, multiplier:1.0, constant:50*tool.HSCALE)
        singerName.superview!.addConstraint(topToSinger)
        musicSlider.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(singerName)
            make.width.equalTo(622*tool.WSCALE)
            make.height.equalTo(12*tool.WSCALE)
        }
        //        musicSlider.minimumTrackTintColor = UIColor(red: 171, green: 199, blue: 231, alpha: 1.0)
        maxTime.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(musicSlider.snp.right)
            make.top.equalTo(musicSlider.snp.bottom).offset(28*tool.HSCALE)
        }
        curTime.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(musicSlider.snp.left)
            make.top.equalTo(musicSlider.snp.bottom).offset(28*tool.HSCALE)
        }
        //---------------------------------------------------------//
        //end
        //---------------------------------------------------------//
        
        
        /*********************************************************/
        //init menu
        /*********************************************************/
        menuView.addSubview(menuControlView)
        menuView.addSubview(menuTV)
        menuView.addSubview(menuCloseButton)
        self.view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(750*tool.WSCALE)
            make.height.equalTo(953*tool.HSCALE)
            make.bottom.equalTo(bodyView.snp.bottom).offset(0)
        }
        menuControlView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(750*tool.WSCALE)
            make.height.equalTo(121*tool.HSCALE)
            make.top.equalTo(menuView.snp.top).offset(0)
        }
        menuControlView.backgroundColor = UIColor.white
        /////////////////////////////////////////////////////////////////////////////////
        menuControlView.addSubview(playSequenceImage)
        menuControlView.addSubview(playSequenceButton)
        menuControlView.addSubview(playSequenceText)
        menuControlView.addSubview(musicCount)
        playSequenceImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37*tool.WSCALE)
            make.height.equalTo(36*tool.WSCALE)
            make.left.equalTo(menuControlView.snp.left).offset(40*tool.WSCALE)
            make.centerY.equalTo(menuControlView.snp.centerY)
        }
        playSequenceText.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(playSequenceImage.snp.right).offset(20*tool.WSCALE)
            make.centerY.equalTo(menuControlView.snp.centerY)
        }
        playSequenceButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37*tool.WSCALE)
            make.height.equalTo(34*tool.WSCALE)
            make.right.equalTo(menuControlView.snp.right).offset(-45*tool.WSCALE)
            make.centerY.equalTo(menuControlView.snp.centerY)
        }
        musicCount.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(playSequenceText.snp.right).offset(20*tool.WSCALE)
            make.centerY.equalTo(menuControlView.snp.centerY)
        }
        playSequenceImage.image = UIImage(named: "顺序")
        playSequenceText.text = "顺序播放"
        musicCount.text = "\(MusicOperationTools.shareInstance.musicMs.count)"
        playSequenceButton.setBackgroundImage(UIImage(named: "倒序"), for: .normal)
        playSequenceButton.setBackgroundImage(UIImage(named: "顺序"), for: .selected)
        playSequenceText.font = UIFont.init(name: "PingFangSC", size: 28*tool.HSCALE)
        playSequenceText.font = UIFont.systemFont(ofSize: 28*tool.HSCALE, weight: UIFont.Weight.regular)
        playSequenceText.textColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1)
        musicCount.font = UIFont.init(name: "PingFangSC", size: 28*tool.HSCALE)
        musicCount.font = UIFont.systemFont(ofSize: 28*tool.HSCALE, weight: UIFont.Weight.regular)
        musicCount.textColor = UIColor(red: 0x99/255, green: 0x99/255, blue: 0x99/255, alpha: 1)
        ///////////////////////////////////////////////////////////////////////////////////
        menuTV.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(750*tool.WSCALE)
            make.top.equalTo(menuControlView.snp.bottom).offset(0*tool.HSCALE)
            make.bottom.equalTo(menuView.snp.bottom).offset(-98*tool.HSCALE)
        }
        menuCloseButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(750*tool.WSCALE)
            make.top.equalTo(menuTV.snp.bottom).offset(0)
            make.bottom.equalTo(menuView.snp.bottom).offset(0)
        }
        menuCloseButton.setTitle("关闭", for: .normal)
        menuCloseButton.setTitleColor(UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1), for: .normal)
        menuCloseButton.titleLabel?.font = UIFont.init(name: "PingFangSC", size: 36*tool.HSCALE)
        menuCloseButton.titleLabel?.font = UIFont.systemFont(ofSize: 36*tool.HSCALE, weight: UIFont.Weight.regular)
        menuCloseButton.layer.borderWidth = 0.5
        menuCloseButton.layer.borderColor = UIColor(red: 0xd5/255, green: 0xd5/255, blue: 0xd5/255, alpha: 1).cgColor
       // menuView.isHidden = true
        //---------------------------------------------------------//
        //end menu
        //---------------------------------------------------------//
        
        
        /*********************************************************/
        //init buttons and fonts
        /*********************************************************/
        initButtons()
        musicName.font = UIFont.systemFont(ofSize: 36*tool.HSCALE, weight: UIFont.Weight.medium)
        singerName.font = UIFont.systemFont(ofSize: 24*tool.HSCALE, weight: UIFont.Weight.medium)
        maxTime.font = UIFont.systemFont(ofSize: 24*tool.HSCALE, weight: UIFont.Weight.medium)
        curTime.font = UIFont.systemFont(ofSize: 24*tool.HSCALE, weight: UIFont.Weight.medium)
        //---------------------------------------------------------//
        //end button
        //---------------------------------------------------------//
    }

    
    func addTimer() {
        updateTimesTimer = Timer(timeInterval: 1, target: self, selector: #selector(MusicDetailVC.updateTimes), userInfo: nil, repeats: true)
        RunLoop.current.add(updateTimesTimer!, forMode: RunLoop.Mode.common)
    }
    
    func removeTimer() {
        updateTimesTimer?.invalidate()
        updateTimesTimer = nil
    }
    func updateOnce() {
        let musicMessageM = MusicOperationTools.shareInstance.getMusicMessageModel()
        guard let musicM = musicMessageM.musicM else {return}
        musicImg.image = UIImage(data: try! Data(contentsOf: URL(string: musicM.image!)!))
        musicName.text = musicM.name
        singerName.text = musicM.singer
        maxTime.text = musicMessageM.totalTimeFormat

    }
    @objc func updateTimes() {//UISlider的播放进度更新，频率比低
        let musicMessageM = MusicOperationTools.shareInstance.getMusicMessageModel()
        musicSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        curTime.text =  musicMessageM.costTimeFormat//TimeTool.getFormatTime(musicMessageM.costTime)
        
        maxTime.text = musicMessageM.totalTimeFormat
        playButton.isSelected = musicMessageM.isPlaying
    }
    override func remoteControlReceived(with event: UIEvent?) {//远程事件
        switch (event?.subtype)! {
        case .remoteControlPlay:
            MusicOperationTools.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            MusicOperationTools.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            MusicOperationTools.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            MusicOperationTools.shareInstance.preMusic()
        default:
            print("...")
        }
        updateOnce()
    }
}
