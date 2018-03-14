//
//  GameViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var powerPicker: UIPickerView!
    @IBOutlet weak var anglePicker: UIPickerView!
    
    var currentGame: GameScene!
    var sceneView: SKView!
    
    private var pickerData: Array<Int> = Array(1...100)
    weak var timer: Timer?
    
    var myTank: Tank!
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "gameView"
        self.setUpPickers()
        //self.getSelectedValue()

        //Set up SKScene inside SKView
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.90))
        sceneView.backgroundColor = UIColor.black
        self.view.addSubview(sceneView)
        
    }
    
    //Setting number of moves
    public func setFuelLabel(){
        fuelLabel.text = String(self.myTank.fuel)
    }
    
    //Listener for left move button
    @IBAction func moveLeftAction(_ sender: Any) {
        self.currentGame.moveTankLeft()
    }
    
    //Listener for right move button
    @IBAction func moveRightAction(_ sender: Any) {
        self.currentGame.moveTankRight()
    }
    

    
    //get values from the pickers. NOT DONE!
    private func getSelectedValue(){
        let timer = Timer(timeInterval: 0.1, repeats: true) { [unowned self] timer in
            let row1 = self.anglePicker.selectedRow(inComponent: 0)
            let row2 = self.powerPicker.selectedRow(inComponent: 0)
            print("anglePicker: \(row1), \(self.anglePicker.tag)")
            print("powerPicker: \(row2), \(self.powerPicker.tag)")
        }
        
        // You need to add the timer to UITrackingRunLoopMode so it fires while scrolling the picker
        let runLoop = RunLoop.current
        runLoop.add(timer, forMode: .commonModes)
        runLoop.add(timer, forMode: .UITrackingRunLoopMode)
        
        self.timer = timer
    }
    
    //Set up pickers with deleagte, data and tag
    private func setUpPickers() {
        self.anglePicker.delegate = self
        self.anglePicker.dataSource = self
        
        self.powerPicker.delegate = self
        self.powerPicker.dataSource = self
        
        self.anglePicker.tag = 1
        self.powerPicker.tag = 2
        
        self.anglePicker.selectRow(49, inComponent: 0, animated: true)
        self.powerPicker.selectRow(49, inComponent: 0, animated: true)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide navigation bar from MainMenuViewController
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.prepareScene()
        self.myTank = self.currentGame.getMyTank()
        self.setFuelLabel()
        
        

    }
    
    //Generate SKScene and add to view
    private func prepareScene() {
        if let view = self.sceneView as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as! GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
