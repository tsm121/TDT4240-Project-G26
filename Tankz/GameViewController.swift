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
    
    //Just for testing, DELETE later
    @IBOutlet weak var oppTurnTemp: UIButton!
    
    @IBOutlet weak var fireBtn: UIButton!
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var powerPicker: UIPickerView!
    @IBOutlet weak var anglePicker: UIPickerView!
    
    var currentGame: GameScene!
    var sceneView: SKView!
    
    private var pickerData: Array<Int> = Array(1...100)
    weak var timer: Timer?
    
    var myTank: Tank!
    
    func messageListener(message: Message) {
        NSLog("%@", "messageListener \(message.type)")
        if message.type == "fire"{
            self.currentGame.gameListener(fireVector: CGVector(dx: CGFloat(message.power), dy: CGFloat(message.angle)), ammoType: .missile, moveAction: (self.currentGame.tank2.moveLeft, "moveLeft") )
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Set if it's players turn */

        view.accessibilityIdentifier = "gameView"
        self.setUpPickers()
        //self.getSelectedValue()

        //Set up SKScene inside SKView
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.90))
        sceneView.backgroundColor = UIColor.black
        self.view.addSubview(sceneView)
        
        /* Attach multiplayerListener */
        NSLog("%@", "Adding Event Listener")
        Multiplayer.shared.addEventListener(listener: self.messageListener)
        NSLog("%@", "Event Listener Added")
        
        //TempBtn, DELETE later
        self.view.bringSubview(toFront: self.oppTurnTemp)
        
    }
    
    //For test purposes only. DELETE later
    @IBAction func oppTurnActionTest(_ sender: Any) {

        self.currentGame.gameListener(fireVector: CGVector(dx: -300, dy: 200), ammoType: .missile, moveAction: (self.currentGame.tank2.moveLeft, "moveLeft") )
        
    }
    
    /**
     Fires a projectile with angle and power chosen in the `UIPicker`s
     - Parameters:
        - sender: Any
     */
    @IBAction func fireAction(_ sender: Any) {
        
        let power = self.getPowerValue()
        let angle = self.getAngleValue()
        let vector = CGVector(dx: power * 10 , dy: angle * 10)
        Multiplayer.shared.messageFire(vector: vector);
        self.currentGame.fire(ammoType: .missile, fireVector: vector, tank: self.currentGame.tank1)
        self.currentGame.finishTurn()
    }
    
    /**
     Enables the UI controls by moving the `disableView` to back
     */
    public func enableControls() {
        self.view.sendSubview(toBack: self.disableView)
    }
    
    /**
     Disable the UI controls by moving the `disableView` to front
     */
    public func disableControls() {
        print("Disable controls")
        self.view.bringSubview(toFront: self.disableView)
    }
    
    /**
     Sets the fuel label to users tank fuel status
     */
    public func setFuelLabel(){
        fuelLabel.text = String(self.myTank.fuel)
    }
    
    /**
    `IBAction` for left arrow `UIButton`. Moves the tank to the left
     - Parameters:
        - sender: Any
     */
    @IBAction func moveLeftAction(_ sender: Any) {
        self.currentGame.moveTankLeft()
    }
    
    /**
     `IBAction` for right arrow `UIButton`. Moves the tank to the right
     - Parameters:
        - sender: Any
     */
    @IBAction func moveRightAction(_ sender: Any) {
        self.currentGame.moveTankRight()
    }
    
    /**
     Getter for the chosen power value in the `UIPicker`
     - Returns:
     `Int`: Chosen power value
     */
    private func getPowerValue() -> Int {
        return self.anglePicker.selectedRow(inComponent: 0)
    }
    
    /**
     Getter for the chosen angle value in the `UIPicker`
     - Returns:
     `Int`: Chosen power angle
     */
    private func getAngleValue() -> Int {
        return self.powerPicker.selectedRow(inComponent: 0)
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
    
    /**
     Setter for the `UIPicker`s and set their delegate, datasource and tag.
     */
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
    
    // Default function for the UIPicker: The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Default function for the UIPicker: The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    // Default function for the UIPicker: The data to return for the row and component (column) that's being passed in
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
    
    /**
     Generates a `SKScene` and adds it to the current `view`
     */
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
        if Multiplayer.shared.player.isHost {
            self.enableControls()
        }
        else {
            self.disableControls()
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
