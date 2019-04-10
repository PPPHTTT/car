//
//  HomeVC.swift
//  Robot
//
//  Created by Hunter on 2019/2/17.
//  Copyright © 2019 Hunter. All rights reserved.
//
import UIKit

class HomeVC: UIViewController ,URLSessionDelegate,UITableViewDataSource,UITableViewDelegate{
    let SCREENW = UIScreen.main.bounds.width
    let SCALE = UIScreen.main.bounds.width/750 //ratio
    var musicMs: [MusicModel] = [MusicModel]()
    let AUDIOS = "http://192.168.0.110:8081/CRUD/Listaudios"
    let MUSICS = "http://192.168.0.110:8081/CRUD/Listaudios"
    @IBOutlet weak var tableview: UITableView!
    var session: URLSession!
    required init?(coder aDecoderL: NSCoder){
        super.init(coder :aDecoderL)
        
        /*create config*/
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0
        
        /* create task session*/
        session = URLSession(configuration: configuration, delegate:self, delegateQueue: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        /*download url*/
        //let strUrl :String = String(format: "https://www.sojson.com/open/api/weather/json.shtml?city=%@","成都")
       // let charSet :CharacterSet = CharacterSet.init(charactersIn: strUrl)
        
      
        //let url = URL(string: strUrl.addingPercentEncoding(withAllowedCharacters: charSet)!)!
          //print(url)
        
    }
    

    

    /*tableviw*/
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "MainCell")! as UITableViewCell
//        let cellData = cellDatas[indexPath.row] as DataModel
//        let image = cell.viewWithTag(101) as! UIImageView
        let title = cell.viewWithTag(101) as! UILabel
        //get title
        let title1 = cell.viewWithTag(103) as! UILabel
        let title2 = cell.viewWithTag(105) as! UILabel
        let title3 = cell.viewWithTag(107) as! UILabel
        //get button
        let button1 = cell.viewWithTag(102) as! UIButton
        let button2 = cell.viewWithTag(104) as! UIButton
        let button3 = cell.viewWithTag(106) as! UIButton
        if indexPath.row == 1{
            title.text = "推荐新闻"
            //get news
            //getNews(title1,title2,title3,button1,button2,button3,AUDIOS)
        }else if indexPath.row == 2{
            title.text = "经典相声"
        }else if indexPath.row == 0{
            title.text = "猜你喜欢"
           // getMusics(title1,title2,title3,button1,button2,button3,MUSICS)
            let m1:MusicModel = MusicModel()
            m1.name = "明智之举"
            m1.image = "http://qukufile2.qianqian.com/data2/pic/a78755077b72153b3b7c084c9eed4e92/612150690/612150690.jpg@s_2,w_300,h_300"
            m1.url = "http://qukufile2.qianqian.com/data2/video/ee0df9b95100b183493af0e3fc104235/607962659/607962659.mp4"
            m1.singer = "许嵩"
            
            let m2:MusicModel = MusicModel()
            m2.name = "如约而至"
            m2.image = "http://qukufile2.qianqian.com/data2/pic/a78755077b72153b3b7c084c9eed4e92/612150690/612150690.jpg@s_2,w_300,h_300"
            m2.url = "http://183.222.102.77/cache/hc.yinyuetai.com/uploads/videos/common/C7A7015FF86A691D2B17F01FF2E7F6CA.mp4?sc=f865957889392976&amp;ich_args2=396-10104004017503_71d4dace04d5f0243aca04298d3431f2_10307403_9c896128dfc5f5d19632518939a83798_9d8085767bc01272cb215bb68592a4c5"
            m2.singer = "许嵩"
            let m3:MusicModel = MusicModel()
            m3.name = "庐州月"
            m3.image = "http://qukufile2.qianqian.com/data2/pic/5e85a56aea07840c0fec9b743fe44648/612258065/612258065.jpg@s_2,w_300,h_300"
            m3.url = "http://fs.w.kugou.com/201903201452/873cd9036900b38201d00e1d0a2cdf47/G006/M00/14/01/poYBAFS8u2iAclsoAD5mXxPRhCQ530.mp3"
            m3.singer = "许嵩"
            
            musicMs.append(m1)
            musicMs.append(m2)
            musicMs.append(m3)
            //init musicMs
            MusicOperationTools.shareInstance.musicMs = musicMs
            
            do{
                title1.text = musicMs[0].name
                button1.setBackgroundImage(UIImage(data: try Data(contentsOf: URL(string: musicMs[0].image!)!)), for: .normal)
                title2.text = musicMs[1].name
                button2.setBackgroundImage(UIImage(data: try Data(contentsOf: URL(string: musicMs[1].image!)!)), for: .normal)
                title3.text = musicMs[2].name
                button3.setBackgroundImage(UIImage(data: try Data(contentsOf: URL(string: musicMs[2].image!)!)), for: .normal)
            }catch{
                print(error)
                return cell
            }
            
        }
        
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380*SCALE
    }
  //when selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            //music
            //实例化将要跳转的controller
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "musicVC") as! MusicVC
            //            vc.imageUrl = URL1
            //            vc.deHeadImage = head1
            //            vc.talkID = phone
            //跳转
            self.navigationController?.show(vc, sender:tableView)
        }else if indexPath.row == 1{
            //news
        }else if indexPath.row == 2{
            //others
        }
    }
    
    ////////action
    //button action
    @IBAction func MusicClickAction_1(_ sender: UIButton) {
        //get button indexrow
        let  cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let  path:IndexPath = self.tableview.indexPath(for: cell)!
        if path.row == 0{
            //music
            //实例化将要跳转的controller
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "musicDetailVC") as! MusicDetailVC
            
            //若当前未播放音乐或所播放音乐不同，则重新播放
            if (MusicOperationTools.shareInstance.tool.player == nil)||MusicOperationTools.shareInstance.getCurIndex() != 0{
                MusicOperationTools.shareInstance.playMusic(musicMs[0])
            }
           // MusicOperationTools.shareInstance.playMusic(musicMs[0])
            //跳转
           self.navigationController?.show(vc, sender: sender)
        }else if path.row == 1{
            //news
        }else if path.row == 2{
            //others
        }
        //(tableview.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath)?.viewWithTag(102) as! UIButton).setBackgroundImage(UIImage(named: "暂停"), for: UIControl.State.normal)
    }
    //cell click action
    
    

    
    
    
    
    
    
    
    
    
    //fun
    func getNews(_ t1:UILabel,_ t2:UILabel,_ t3:UILabel,_ b1:UIButton,_ b2:UIButton,_ b3:UIButton,_ url:String){
        //get json from url  
        let jsonData = getJsonFromUrl(url)
        print("start---------------------------")
        print(jsonData!)
        print("done----------------------")
////////////////////
    }
    func getMusics(_ t1:UILabel,_ t2:UILabel,_ t3:UILabel,_ b1:UIButton,_ b2:UIButton,_ b3:UIButton,_ url:String){
        //get json from url
        let jsonData = getJsonFromUrl(url)
        print("start---------------------------")
        print(jsonData!)
        print("done----------------------")
        ////////////////////
    }
    //get json
    func getJsonFromUrl(_ url:String)->JSON?{
        var jsonData = JSON.init()
        let u = URL(string: url)
        let task = session.dataTask(with: u!, completionHandler: { [weak self](data:Data!,response: URLResponse!,error:Error!)->() in
            if(data != nil){
                 jsonData = JSON.init(data)
            }else{
                print("empty")
            }
            self!.session.finishTasksAndInvalidate()
        })
        print("-----------------------------------------")
        print(jsonData)
        print("----------------------------------")
        task.resume()
        return jsonData
    }
}
