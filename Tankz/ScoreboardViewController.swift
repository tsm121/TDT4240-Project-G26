//
//  ScoreboardViewController.swift
//  Tankz
//
//  Created by Nikolai on 06/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var scoreboardTable: UITableView!
    public var playerScores: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scoreboardTable.dataSource = self
        
        playerScores.append("8432423")
        playerScores.append("72245")
        playerScores.append("542323")
        playerScores.append("2452")
        playerScores.append("51324")
        
        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "scoreboardView"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreboardTable.dequeueReusableCell(withIdentifier: "playerScoreCell") as! ScoreTableViewCell
    
    cell.opponentNameLabel.text = "xXDestroyerOfWorldzXx"
    cell.scoreLabel.text = self.playerScores[indexPath.row]
    
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
