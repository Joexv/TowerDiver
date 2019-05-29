//
//  Achievement_TableViewController.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 5/17/19.
//  Copyright © 2019 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class Achievement_TableViewController: UITableViewController {
    
    //Name:Description
    //Achievements are stored in a plist as
    //Name:Bool
    let Achievements: [String : String] = [
        "Beginner Adventurer":"Reach Floor 50",
        "Skilled Adventurer":"Reach Floor 100",
        "Determined Adventurer":"Reach Floor 200",
        "Master Adventurer":"Reach the top of The Tower",
        "Escape Artist":"Escape The Tower",
        "Saver":"Collect 25,000 Gold",
        "Accountant":"Collect 100,000 Gold",
        "It's Over 9000!":"Obtain over 9000 Power",
        "True Power":"Obtain 1,000,000 Power",
        "The Greatest Knight":"Defeat Gilgamesh in a duel",
    ]
    
    var Names: [String] = []
    
    //"":"",
    
    let defaults = UserDefaults.standard
    func read(_ Achievement: String) -> Bool{
        return defaults.bool(forKey: "A_" + Achievement)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in Achievements.keys{
            Names.append(item)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Achievements.count
    }
    
    func GetImage(_ Name: String) -> UIImage{
        if(read(Name)){
            return UIImage(named: "Check.png")!
        }else{
            return UIImage(named: "X.png")!
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Achievement_Cell
        cell.Name.text = Names[indexPath.item]
        cell.Description.text = Achievements[Names[indexPath.item]]
        cell.CheckImage.image = GetImage(Names[indexPath.item])
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
