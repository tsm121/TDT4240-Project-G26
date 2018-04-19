//
//  GameLobbyViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class GameLobbyViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var readyStatusLabelP2: UILabel!
    @IBOutlet weak var pageControlP2: UIPageControl!
    @IBOutlet weak var tankTypeP2: UILabel!
    @IBOutlet weak var scrollViewP2: UIScrollView!
    
    @IBOutlet weak var readyStatusLabelP1: UILabel!
    @IBOutlet weak var pageControlP1: UIPageControl!
    @IBOutlet weak var tankTypeP1: UILabel!
    @IBOutlet weak var scrollViewP1: UIScrollView!
    
    @IBOutlet weak var changeMapBtn: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    private var lobbyUsers: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func isReady(_ sender: Any) {
        if Multiplayer.shared.player.isReady{
            if (!Multiplayer.shared.player.isHost) {
                self.readyStatusLabelP2.text = "Not Ready"
            }
            else {
                self.readyStatusLabelP1.text = "Not Ready"
            }
            readyButton.setTitle("Ready", for: .normal)
            Multiplayer.shared.messageNotReady()
        }
        else {
            if (!Multiplayer.shared.player.isHost) {
                self.readyStatusLabelP2.text = "Ready"
            }
            else {
                self.readyStatusLabelP1.text = "Ready"
            }
            readyButton.setTitle("Not Ready", for: .normal)
            Multiplayer.shared.messageIsReady()
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
                    self.readyStatusLabelP2.text = "Ready"
                }
                else {
                    self.readyStatusLabelP1.text = "Ready"
                }
            }
        }
        if message.type == "notready"{
            DispatchQueue.main.async {
                if (Multiplayer.shared.player.isHost) {
                    self.readyStatusLabelP2.text = "Not Ready"
                }
                else {
                    self.readyStatusLabelP1.text = "Not Ready"
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
    
    override func viewDidAppear(_ animated: Bool) {

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
        imgOne.image = UIImage(named: "tank1_p1")
        var imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank2")
        var imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank3_p1")
        
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
        imgOne.image = UIImage(named: "tank1_p2")
        imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank2_p2")
        imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank3_p2")
        
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
        }
        else {
            self.pageControlP1.isHidden = true
            self.scrollViewP1.isScrollEnabled = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    //Listener for page scrolling. Set text based on selection
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        var tankTypeLabel: UILabel
        var pageControl: UIPageControl
        if scrollView.tag == 1 {
            tankTypeLabel = self.tankTypeP1
            pageControl = self.pageControlP1
        } else {
            tankTypeLabel = self.tankTypeP2
            pageControl = self.pageControlP2
        }
        
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        
        // Change indicator
        pageControl.currentPage = Int(currentPage);
        print("'herp'")
        // Change the text accordingly to page selection
        if Int(currentPage) == 0{
            tankTypeLabel.text = "TankType 1"
            Multiplayer.shared.messageSelectTank(index: 0)
        }else if Int(currentPage) == 1{
            tankTypeLabel.text = "TankType 2"
            Multiplayer.shared.messageSelectTank(index: 1)
        }else if Int(currentPage) == 2{
            tankTypeLabel.text = "TankType 3"
            Multiplayer.shared.messageSelectTank(index: 2)
        }
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
