//
//  GameLobbyViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

//Extension used to transition UILabels for statuses
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

import UIKit

class GameLobbyViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var readyStatusLabelP2: UILabel!
    @IBOutlet weak var pageControlP2: UIPageControl!
    @IBOutlet weak var scrollViewP2: UIScrollView!
    
    @IBOutlet weak var readyStatusLabelP1: UILabel!
    @IBOutlet weak var pageControlP1: UIPageControl!
    @IBOutlet weak var scrollViewP1: UIScrollView!
    
    @IBOutlet weak var changeMapBtn: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    private var lobbyUsers: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.styleBtn(button: self.readyButton)
        self.styleBtn(button: self.changeMapBtn)
    }
    
    func styleBtn(button: UIButton){
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 3.0
        button.layer.masksToBounds = false
    }
    
    @IBAction func isReady(_ sender: Any) {
        if Multiplayer.shared.player.isReady{
            if (!Multiplayer.shared.player.isHost) {
                self.readyStatusLabelP2.fadeTransition(0.4)
                self.readyStatusLabelP2.text = "Not Ready"
                self.readyStatusLabelP2.backgroundColor = UIColor(named: "militaryRed")
                
            }
            else {
                self.readyStatusLabelP1.fadeTransition(0.4)
                self.readyStatusLabelP1.text = "Not Ready"
                self.readyStatusLabelP1.backgroundColor = UIColor(named: "militaryRed")
            }
            readyButton.setTitle("Ready", for: .normal)
            Multiplayer.shared.messageNotReady()
        }
        else {
            if (!Multiplayer.shared.player.isHost) {
                self.readyStatusLabelP2.fadeTransition(0.4)
                self.readyStatusLabelP2.text = "Ready"
                self.readyStatusLabelP2.backgroundColor = UIColor(named:"militaryGreenLight" )
            }
            else {
                self.readyStatusLabelP1.fadeTransition(0.4)
                self.readyStatusLabelP1.text = "Ready"
                self.readyStatusLabelP1.backgroundColor = UIColor(named:"militaryGreenLight" )
            }
            readyButton.setTitle("Not Ready", for: .normal)
            Multiplayer.shared.messageIsReady()
        }
        
    }
    
    @IBAction func ChangeMap(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose Map", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 120)
        
        let pickEarthAction = UIAlertAction(title: "Earth", style: .default, handler: {(alert: UIAlertAction!) in Multiplayer.shared.messageSelectMap(index: MapType.earth.rawValue)})
        
        let pickMoonAction = UIAlertAction(title: "Moon", style: .default, handler: {(alert: UIAlertAction!) in Multiplayer.shared.messageSelectMap(index: MapType.moon.rawValue)})
        
        let pickMarsAction = UIAlertAction(title: "Mars", style: .default, handler: {(alert: UIAlertAction!) in Multiplayer.shared.messageSelectMap(index: MapType.mars.rawValue)})
        
        alertController.addAction(pickEarthAction)
        
        alertController.addAction(pickMoonAction)
        
        alertController.addAction(pickMarsAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
    }
    override func viewDidLoad() {
        
        /* Register event listener for when multiplayer fires events. */
        Multiplayer.shared.addEventListener(listener: self.multiplayerListener)
        super.viewDidLoad()
    
        /* Custom Back Button */
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title:
            "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameLobbyViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        self.setUpScrollView()
        //DemoUsers
        lobbyUsers.append(Player(ID: "1234"))
        lobbyUsers.append(Player(ID: "5678"))

        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "gameLobbyView"
    }

    @objc func back(sender: UIBarButtonItem) {
        Multiplayer.shared.disconnect();
        _ = navigationController?.popViewController(animated: true)
    }

    func multiplayerListener(message: Message) {
        // NOTE: It's possibel DispatchQueue needs to wrap everything
        if message.type == "isready"{
            DispatchQueue.main.async {
                if (Multiplayer.shared.player.isHost) {
                    self.readyStatusLabelP2.fadeTransition(0.4)
                    self.readyStatusLabelP2.text = "Ready"
                    self.readyStatusLabelP2.backgroundColor = UIColor(named:"militaryGreenLight" )
                }
                else {
                    self.readyStatusLabelP1.fadeTransition(0.4)
                    self.readyStatusLabelP1.text = "Ready"
                    self.readyStatusLabelP1.backgroundColor = UIColor(named:"militaryGreenLight" )
                }
            }
        }
        if message.type == "notready"{
            DispatchQueue.main.async {
                if (Multiplayer.shared.player.isHost) {
                    self.readyStatusLabelP2.fadeTransition(0.4)
                    self.readyStatusLabelP2.text = "Not Ready"
                    self.readyStatusLabelP2.backgroundColor = UIColor(named: "militaryRed")
                }
                else {
                    self.readyStatusLabelP1.fadeTransition(0.4)
                    self.readyStatusLabelP1.text = "Not Ready"
                    self.readyStatusLabelP1.backgroundColor = UIColor(named: "militaryRed")
                }
            }
        }
        if message.type == "startgame"{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "startGameSegue", sender: self)
            }
        }
        if message.type == "opponentdisconnected" {
            if Multiplayer.shared.player.isHost {
                let alert = UIAlertController(title: "Opponent Disconnected", message: "Your opponent disconnected.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    self.readyStatusLabelP2.text = "Not Ready"
                    Multiplayer.shared.opponent = nil;
                    Multiplayer.shared.advertiseAsHost();
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Host Disconnected", message: "Your host disconnected.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    Multiplayer.shared.disconnect();
                    _ = self.navigationController?.popViewController(animated: true)
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        if message.type == "selecttank" {
            if Multiplayer.shared.player.isHost {
                self.scrollViewP2.setContentOffset(CGPoint(x: scrollViewP2.frame.width * CGFloat(message.index), y: 0), animated: true)
            }
            
            else {
                self.scrollViewP1.setContentOffset(CGPoint(x: scrollViewP1.frame.width * CGFloat(message.index), y: 0), animated: true)
            }
        }
    }
    
    //Setup for a given scrollView
    func setUpScrollView() {
        
        //Set scrollViewTag
        self.scrollViewP1.tag = 1
        self.scrollViewP2.tag = 2
        
        //Set scrollView to correct size
        /*self.scrollViewP1.frame = CGRect(x:0, y:0, width:self.view.frame.width/2, height:self.view.frame.height*0.8)
        self.scrollViewP2.frame = CGRect(x:self.view.frame.width/2, y:0, width:self.view.frame.width/2, height:self.view.frame.height*0.8)*/

        var scrollViewWidth:CGFloat = self.scrollViewP1.frameLayoutGuide.layoutFrame.width
        var scrollViewHeight:CGFloat = self.scrollViewP1.frame.height
        
        //Create images for scrollView
        var imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "tank2_slider")
        var imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank3_slider")
        var imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank1_slider")
        
        self.scrollViewP1.contentSize = CGSize(width:scrollViewWidth * 3, height:scrollViewHeight)
        self.scrollViewP1.delegate = self

        //Insert images to scrollView
        self.scrollViewP1.addSubview(imgOne)
        self.scrollViewP1.addSubview(imgTwo)
        self.scrollViewP1.addSubview(imgThree)
        

    
        scrollViewWidth = self.scrollViewP2.frameLayoutGuide.layoutFrame.width
        scrollViewHeight = self.scrollViewP2.frame.height
        
        //Create images for scrollView
        imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "tank2_slider")
        imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank3_slider")
        imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank1_slider")
        
        //Insert images to scrollView
        self.scrollViewP2.addSubview(imgOne)
        self.scrollViewP2.addSubview(imgTwo)
        self.scrollViewP2.addSubview(imgThree)
        
        //Set content size for horizontal scrolling and set delegate
        self.scrollViewP2.contentSize = CGSize(width:scrollViewWidth * 3, height:scrollViewHeight)
        self.scrollViewP2.delegate = self
        
        //Set start page to 0 and send subview to back
        self.pageControlP1.currentPage = 0
        self.pageControlP2.currentPage = 0
        self.view.sendSubview(toBack: self.scrollViewP1)
        self.view.sendSubview(toBack: self.scrollViewP2)
        
        if Multiplayer.shared.player.isHost {
            self.pageControlP2.isHidden = true
            self.scrollViewP2.isScrollEnabled = false
            self.scrollViewP2.alpha = 0.7
        }
        else {
            self.pageControlP1.isHidden = true
            self.scrollViewP1.isScrollEnabled = false
            self.scrollViewP1.alpha = 0.7
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    //Listener for page scrolling. Set text based on selection
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        var pageControl: UIPageControl
        if scrollView.tag == 1 {
            pageControl = self.pageControlP1
        } else {
            pageControl = self.pageControlP2
        }
        
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        
        // Change indicator
        pageControl.currentPage = Int(currentPage);
    }

    override func viewWillDisappear(_ animated: Bool) {
        if Multiplayer.shared.player.isHost{
            Multiplayer.shared.ceaseAdvertisingAsHost()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
