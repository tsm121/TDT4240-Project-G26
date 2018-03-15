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
    @IBOutlet weak var notReadyButton: UIButton!
    
    private var lobbyUsers: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        Multiplayer.shared.advertiseAsHost()
    }
    @IBAction func isReady(_ sender: Any) {
        Multiplayer.shared.messageIsReady()
    }
    @IBAction func notReady(_ sender: Any) {
        Multiplayer.shared.messageNotReady()
    }
    
    override func viewDidLoad() {
        
        /* Register event listener for when multiplayer fires events. */
        Multiplayer.shared.addEventListener(listener: self.testListener)
                
        super.viewDidLoad()

        self.setUpScrollView()
        //DemoUsers
        lobbyUsers.append(Player(ID: "1234"))
        lobbyUsers.append(Player(ID: "5678"))

        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "gameLobbyView"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /* Un-register event listener for multiplayer. */
        Multiplayer.shared.removeEventListener(listener: self.multiplayerListener)
    }

    func multiplayerListener(message: Message) {
        // NOTE: It's possibel DispatchQueue needs to wrap everything
        if message.type == "isready"{
            // TODO: update opponent is ready UI
        }
        if message.type == "notready"{
            // TODO: update opponent is ready UI
        }
        if message.type == "startgame"{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "startGameSegue", sender: self)
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
        self.scrollViewP1.frame = CGRect(x:0, y:0, width:self.view.frame.width/2, height:self.view.frame.height*0.8)
        self.scrollViewP2.frame = CGRect(x:self.view.frame.width/2, y:0, width:self.view.frame.width/2, height:self.view.frame.height*0.8)

        let scrollViewWidth:CGFloat = self.scrollViewP1.frame.width
        let scrollViewHeight:CGFloat = self.scrollViewP1.frame.height
        
        //Create images for scrollView
        var imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "tank1")
        var imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank2")
        var imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank1")
        var imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "tank2")
        
        //Insert images to scrollView
        self.scrollViewP1.addSubview(imgOne)
        self.scrollViewP1.addSubview(imgTwo)
        self.scrollViewP1.addSubview(imgThree)
        self.scrollViewP1.addSubview(imgFour)
        
        //Create images for scrollView
        imgOne = UIImageView(frame: CGRect(x:self.view.frame.width/2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "tank1")
        imgTwo = UIImageView(frame: CGRect(x:self.view.frame.width/2+scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "tank2")
        imgThree = UIImageView(frame: CGRect(x:self.view.frame.width/2+scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "tank1")
        imgFour = UIImageView(frame: CGRect(x:self.view.frame.width/2+scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "tank2")
        
        //Insert images to scrollView
        self.scrollViewP2.addSubview(imgOne)
        self.scrollViewP2.addSubview(imgTwo)
        self.scrollViewP2.addSubview(imgThree)
        self.scrollViewP2.addSubview(imgFour)
        
        //Set content size for horizontal scrolling and set delegate
        self.scrollViewP1.contentSize = CGSize(width:self.scrollViewP1.frame.width * 4, height:1.0)
        self.scrollViewP1.delegate = self
        
        self.scrollViewP2.contentSize = CGSize(width:self.scrollViewP2.frame.width * 4, height:1.0)
        self.scrollViewP2.delegate = self
        
        //Set height and width of tankTypeLabel and pageControl
        self.tankTypeP1.frame.size.width = self.view.bounds.width/2
        self.tankTypeP1.frame.size.height = self.view.bounds.height*0.05
        self.pageControlP1.frame.size.width = self.view.bounds.width/2
        self.pageControlP1.frame.size.height = self.view.bounds.height*0.05
        
        self.tankTypeP2.frame.size.width = self.view.bounds.width/2
        self.tankTypeP2.frame.size.height = self.view.bounds.height*0.05
        self.pageControlP2.frame.size.width = self.view.bounds.width/2
        self.pageControlP2.frame.size.height = self.view.bounds.height*0.05
        
        //Set start page to 0 and send subview to back
        self.pageControlP1.currentPage = 0
        self.pageControlP2.currentPage = 0
        self.view.sendSubview(toBack: self.scrollViewP1)
        self.view.sendSubview(toBack: self.scrollViewP2)
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
        
        // Change the text accordingly to page selection
        if Int(currentPage) == 0{
            tankTypeLabel.text = "TankType 1"
        }else if Int(currentPage) == 1{
            tankTypeLabel.text = "TankType 2"
        }else if Int(currentPage) == 2{
            tankTypeLabel.text = "TankType 3"
        }else{
            tankTypeLabel.text = "TankType 4"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        Multiplayer.shared.ceaseAdvertisingAsHost()
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
