//
//  GameLobbyViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class GameLobbyViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var lobbyTable: UITableView!
    let multiplayerManager = Multiplayer()
    
    private var lobbyUsers: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        Multiplayer.shared.advertiseAsHost()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lobbyTable.dataSource = self
        
        //DemoUsers
        lobbyUsers.append(Player(ID: "1234"))
        lobbyUsers.append(Player(ID: "5678"))

        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "gameLobbyView"
    }
    
    @IBAction func readyBtn(_ sender: Any) {
        self.lobbyUsers[0].setReadyStatus()
        self.lobbyTable.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Multiplayer.shared.ceaseAdvertisingAsHost()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lobbyUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lobbyTable.dequeueReusableCell(withIdentifier: "lobbyCell") as! LobbyTableViewCell
        
        let user = lobbyUsers[indexPath.row]
        let cellText: String
        cell.playerNameLabel.text = user.getPlayerName()
        
        //Set a given status label from ready to not ready, or vica versa
        if user.getReadyStatus() {
            cellText = "Not ready"
            cell.readyStatusLabel.textColor = UIColor(named: "militaryRed")
        } else {
            cellText = "Ready"
            cell.readyStatusLabel.textColor = UIColor(named: "lightGreen")
        }
        
        cell.readyStatusLabel.text = cellText
        cell.readyStatusIcon.isHidden = user.getReadyStatus()

        return cell
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
