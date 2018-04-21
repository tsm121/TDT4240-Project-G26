//
//  MainMenuViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var createGameBtn: UIButton!
    @IBOutlet weak var joinGameBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignbackground()



        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "mainMenuView"
    }
    
    @IBAction func unwindToMainMenuViewController(_ sender: UIStoryboardSegue) { }
    
    func styleBtn(button: UIButton){
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        button.layer.masksToBounds = false
    }
    
    func styleImg(image: UIImageView){
        image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        image.layer.shadowOffset = CGSize(width: 5, height: 5)
        image.layer.shadowOpacity = 1.0
        image.layer.shadowRadius = 5.0
        image.layer.masksToBounds = false
    }
    
    func assignbackground(){
        let background = UIImage(named: "MainMenuBackground.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

    @IBAction func createGame(_ sender: Any) {
        Multiplayer.shared.advertiseAsHost()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide navigation bar from MainMenuViewController
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //Remove subviews from stack
        self.navigationController?.popToRootViewController(animated: false)
        //Style buttons with shadow
        self.styleBtn(button: self.createGameBtn)
        self.styleBtn(button: self.joinGameBtn)
        self.styleImg(image: self.logo)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Show navigation bar when leaving MainMenuViewController
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
