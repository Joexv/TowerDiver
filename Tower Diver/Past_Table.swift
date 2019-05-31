//
//  Past_Table.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 5/19/19.
//  Copyright © 2019 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class Past_Table: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    let defaults = UserDefaults.standard
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return defaults.integer(forKey: "TotalC")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Populating Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Past_Cell
        NSLog(String(indexPath.item + 1))
        let objects = defaults.string(forKey: "CLog_" + String(indexPath.item + 1))
        NSLog(objects ?? "")
        let Carr: [String] = objects?.components(separatedBy: "::") ?? ["","","",""]
        //Name + "::" + Class + "::" + Floor + "::" + String(didEscape)
        cell.Name.text = Carr[0]
        NSLog(Carr[0])
        cell.Name.textColor = .white
        cell.ClassImage.image = GenClassImage(Carr[1])
        NSLog(Carr[1])
        cell.Details.text = "Climbed to floor " + Carr[2]
        cell.Details.textColor = .white
        NSLog(Carr[2])
        cell.DiedImage.image = didEscape(Carr[3])
        NSLog(Carr[3])
        
        let labelBackground = UIImageView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height))
        labelBackground.image = UIImage(named: "Table_Cell")!
        labelBackground.contentMode = .scaleToFill
        labelBackground.tag = 101
        cell.insertSubview(labelBackground, at: 0)
        
        cell.backgroundColor = .clear
        return cell
    }
    
    func didEscape(_ Escape: String) -> UIImage{
        switch Bool(Escape) {
        case true:
            return UIImage(named: "Live.png") ?? UIImage(named: "Check.png")!
        case false:
            return UIImage(named: "Skull.png") ?? UIImage(named: "Check.png")!
        default:
            return UIImage(named: "Skull.png") ?? UIImage(named: "Check.png")!
        }
    }
    
    func GenClassImage(_ Class: String = "0") -> UIImage{
        switch Class {
        case "0":
            return UIImage(named:"Sword.png")!
        case "1":
            return UIImage(named:"Arrow.png")!
        case "2":
            return UIImage(named:"Staff.png")!
        case "3":
            return UIImage(named:"Scythe.png")!
        case "4":
            return UIImage(named: "Scepter.png")!
        case "5":
            return UIImage(named: "Toaster.png")!
        default:
            return UIImage(named:"Dagger.png")!
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        self.view.backgroundColor = UIColor(patternImage: scaled)
        
        tblView.backgroundColor = .clear //UIColor(patternImage: scaled)
        
        //BackButt.layer.borderWidth = 1
        //BackButt.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        TitleLabel.backgroundColor = .black
        TitleLabel.layer.borderWidth = 2
        TitleLabel.layer.borderColor = UIColor(red: 70, green: 61, blue: 48).cgColor
    }
    
    func SubViewUnder(Image: String, x:CGFloat, y:CGFloat,width:CGFloat,height:CGFloat,Tag:Int){
        let labelBackground = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        labelBackground.image = UIImage(named: Image)!
        labelBackground.tag = Tag
        self.view.insertSubview(labelBackground, at: 0)
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    

    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var BackButt: UIButton!
    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
