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
    
    private var lobbyUsers: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        Multiplayer.shared.advertiseAsHost()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lobbyTable.dataSource = self
        
        lobbyUsers.append("Player1")
        lobbyUsers.append("Player2")
        

        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "gameLobbyView"
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
        
        let text = lobbyUsers[indexPath.row]
        cell.playerNameLabel.text = text
        cell.readyStatusLabel.text = "Not ready"
        cell.readyStatusLabel.textColor = UIColor(named: "militaryRed")

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
