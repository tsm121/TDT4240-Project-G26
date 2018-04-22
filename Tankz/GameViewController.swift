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
    //@IBOutlet weak var oppTurnTemp: UIButton!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var fireBtn: UIButton!
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var powerPicker: UIPickerView!
    @IBOutlet weak var anglePicker: UIPickerView!
    
    var currentGame: GameScene!
    var sceneView: SKView!
    
    private var angleData: Array<Int> = Array(0...90)
    private var powerData: Array<Int> = Array(0...100)
    weak var timer: Timer?
    
    var myTank: Tank!
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    func messageListener(message: Message) {
        NSLog("%@", "messageListener \(message.type)")
        if message.type == "fire"{
            self.currentGame.fire(power: message.power, angle: message.angle)
        }
        if message.type == "moveleft" {
            self.currentGame.moveTankLeft();
        }
        if message.type == "moveright" {
            self.currentGame.moveTankRight()
        }
        if message.type == "opponentdisconnected" {
            let alert = UIAlertController(title: "Opponent Disconnected", message: "Your opponent disconnected.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                Multiplayer.shared.disconnect()
                self.performSegue(withIdentifier: "exitGameSegue", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if message.type == "anglecanon" {
            self.currentGame.currentTank.rotateCanon(angle: CGFloat(message.angle))
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
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.controlsView.frame.height))
        sceneView.backgroundColor = UIColor.black
        self.view.addSubview(sceneView)

        /* Attach multiplayerListener */
        NSLog("%@", "Adding Event Listener")
        Multiplayer.shared.addEventListener(listener: self.messageListener)
        NSLog("%@", "Event Listener Added")
        
        self.view.bringSubview(toFront: self.controlsView)
        self.view.bringSubview(toFront: self.exitBtn)
        //TempBtn, DELETE later
        //self.view.bringSubview(toFront: self.oppTurnTemp)
        
        
        
    }
    
    //For test purposes only. DELETE later
    @IBAction func oppTurnActionTest(_ sender: Any) {
        if currentGame.currentTank !== currentGame.getMyTank() {
            Multiplayer.shared.handleMessage(message: Message(type: "fire", power: 50, angle: 45))
        }
    }
    func gameHasEnded(){
        if (myTank.getCurrentHealth() <= 0) {
            let alert = UIAlertController(title: "Defeat", message: "Your tank was destroyed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                Multiplayer.shared.disconnect()
                self.performSegue(withIdentifier: "exitGameSegue", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Victory", message: "Your opponent's tank was destroyed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                Multiplayer.shared.disconnect()
                self.performSegue(withIdentifier: "exitGameSegue", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        // TODO: Move to scoreboard instead
    }
    /**
     Fires a projectile with angle and power chosen in the `UIPicker`s
     - Parameters:
        - sender: Any
     */
    @IBAction func fireAction(_ sender: Any) {
        
        let power = Float(self.getPowerValue())
        let angle = Float(self.getAngleValue())
        Multiplayer.shared.messageFire(power: power, angle: angle);
        self.currentGame.fire(power: power, angle: angle)
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
        self.view.bringSubview(toFront: self.disableView)
    }
    
    /**
     Sets the fuel label to users tank fuel status
     */
    public func setFuelLabel(){
        fuelLabel.text = String(Int(self.myTank.getCurrentFuel()))
    }
    
    /**
    `IBAction` for left arrow `UIButton`. Moves the tank to the left
     - Parameters:
        - sender: Any
     */
    @IBAction func moveLeftAction(_ sender: Any) {
        self.currentGame.moveTankLeft()
        Multiplayer.shared.messageMoveLeft()
    }
    
    /**
     `IBAction` for right arrow `UIButton`. Moves the tank to the right
     - Parameters:
        - sender: Any
     */
    @IBAction func moveRightAction(_ sender: Any) {
        self.currentGame.moveTankRight()
        Multiplayer.shared.messageMoveRight()
    }
    
    /**
     Getter for the chosen power value in the `UIPicker`
     - Returns:
     `Int`: Chosen power value
     */
    private func getPowerValue() -> Int {
        return self.powerPicker.selectedRow(inComponent: 0)
    }
    
    /**
     Getter for the chosen angle value in the `UIPicker`
     - Returns:
     `Int`: Chosen power angle
     */
    private func getAngleValue() -> Int {
        return self.anglePicker.selectedRow(inComponent: 0)
    }
    

    //get values from the pickers. NOT DONE!
    private func getSelectedValue(){
        let timer = Timer(timeInterval: 0.1, repeats: true) { [unowned self] timer in
            let row1 = self.anglePicker.selectedRow(inComponent: 0)
            let row2 = self.powerPicker.selectedRow(inComponent: 0)
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
        
        self.anglePicker.selectRow(45, inComponent: 0, animated: true)
        self.powerPicker.selectRow(45, inComponent: 0, animated: true)
    
    }
    
    // Default function for the UIPicker: The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Default function for the UIPicker: The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.angleData.count
        } else {
            return self.powerData.count
        }
    }
    
    // Default function for the UIPicker: The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return String(angleData[row])
        } else {
            return String(powerData[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === self.anglePicker {
            self.myTank.rotateCanon(angle: CGFloat(angleData[row]))
            Multiplayer.shared.messageAngleCanon(angle: Float(self.myTank.getCurrentAngle()))
        }
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
    @IBAction func exitBtnTouch(_ sender: Any) {
        Multiplayer.shared.disconnect()
        self.performSegue(withIdentifier: "exitGameSegue", sender: self)
    }
    private func prepareScene() {
        if let view = self.sceneView as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // START OF HACKY SHIT TO MAKE SCENE SCALE
                // Kanskje æ huske ka æ gjorde hvis du spør meg - Clas
                scene.size = CGSize(width: 1280, height: 1280)
                scene.scaleMode = .aspectFill
                scene.anchorPoint = (CGPoint(x: 0, y: 0))
                let camera = SKCameraNode()
                let viewHeight = self.view.frame.height - self.controlsView.frame.height
                let sceneViewRelationship = 1280 / view.frame.width
                let cameraAdjust = (viewHeight * sceneViewRelationship) / 2
                camera.position.x = CGFloat(640)
                camera.position.y = cameraAdjust
                scene.camera = camera
                scene.addChild(camera)
                
                // END OF HACKY SHIT TO MAKE SCENE SCALE
                
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
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
