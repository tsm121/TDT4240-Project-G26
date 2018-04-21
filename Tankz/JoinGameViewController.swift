//
//  JoinGameViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Foundation

class JoinGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var unHostBtn: UIButton!
    @IBOutlet weak var hostBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshBtn: UIButton!
    
    public var data: [MCPeerID] = []
    private var reloadGamesList: Timer? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.data.removeAll()
        self.tableView.reloadData()
        Multiplayer.shared.lookForGames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "joinGameView"
        
        //Set datasource and delegate for table
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshListView(self)
        reloadGamesList = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JoinGameViewController.refreshListView), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        reloadGamesList?.invalidate()
        reloadGamesList = nil
        Multiplayer.shared.ceaseLookingForGames()
        
    }
    //For demo purpose
    @IBAction func unHostAction(_ sender: Any) {
    }
    
    @IBAction func hostAction(_ sender: Any) {
    }
    

    //Action for refreshing listView based on availiable hosts
    @IBAction func refreshListView(_ sender: Any) {
        self.data = Multiplayer.shared.getGames()
        self.tableView.reloadData()
    }
    //Number of section in the tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Number of rows in the tableView's section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //Formating of each cell in tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get reusable cell with ID and cast as GameTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! GameTableViewCell
        
        let peerID = data[indexPath.row]
        cell.hostNameLabel.text = peerID.displayName
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(named: "militaryGreenDark")
        }else {
            cell.contentView.backgroundColor = UIColor(named: "militaryGreenLight")
        }
        
        return cell
    }
    
    //Action based on user selection in tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Multiplayer.shared.joinGame(peerID: self.data[indexPath.row])
        performSegue(withIdentifier: "connectToGameSegue", sender: self)
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
