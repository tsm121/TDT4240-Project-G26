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
    
    @IBOutlet weak var powerPicker: UIPickerView!
    @IBOutlet weak var anglePicker: UIPickerView!
    
    var currentGame: GameScene!
    var sceneView: SKView!
    
    private var pickerData: Array<Int> = Array(1...100)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpPickers()


        
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.90))
        sceneView.backgroundColor = UIColor.black
        self.view.addSubview(sceneView)
        
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
        view.accessibilityIdentifier = "gameView"
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
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(String(self.pickerData[row]))
        print(String(pickerView.tag))
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
