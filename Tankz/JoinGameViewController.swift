//
//  JoinGameViewController.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import UIKit

class JoinGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data.append("Vald Bagina")
        data.append("xXPussySlayerXx")
        data.append("ibeatanorexia311")
        data.append("YoMama8932")
        data.append("Hairy Pickle")
        data.append("Ronald McDonald")
        data.append("Slaughterslut")
        data.append("giant 8llllllD")

        
        //Set datasource and delegate for table
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! GameTableViewCell //1.
        
        let text = data[indexPath.row] //2.
        cell.hostNameLabel.text = text
        cell.numPlayersLabel.text = "x/2"
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.red
        }else {
            cell.contentView.backgroundColor = UIColor.lightGray
        }
        
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
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
