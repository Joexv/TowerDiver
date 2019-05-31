//
//  AchieveTable.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 5/17/19.
//  Copyright © 2019 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class AchieveTable: UIViewController, UITableViewDataSource, UITableViewDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var tblView: UITableView!
    
    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //Achievements are stored in a plist as
    //A_Name
    let Descriptions: [String] = [
        "Reach Floor 50",
        "Reach Floor 100",
        "Reach Floor 200",
        "Reach the top of The Tower",
        "Escape The Tower",
        "Collect 25,000 Gold",
        "Collect 100,000 Gold",
        "Collect 1,000,000 Gold",
        "Obtain over 9000 Power",
        "Obtain 100,000 Power",
        "Obtain 1,000,000 Power",
        "Defeat Gilgamesh in a duel",
        "Unlock 'King' as a playable class",
        "Enter Hell",
        "Kill Death for the first time",
        "Kill Death 10 times in one run",
        "Kill Sock Puppet Succubus",
        "???",
        "???",
        "???",
        "Do the thing that most normal humans wouldn't do",
        "Kill The Squirrel",
        "Master the bread-y arts",
        "Max out all HP, Power and Gold"
    ]
    
    var Names: [String] = [
        "Beginner Adventurer",
        "Skilled Adventurer",
        "Determined Adventurer",
        "Master Adventurer",
        "Escape Artist",
        "Saver",
        "Accountant",
        "Master Of Coin",
        "It's Over 9000!",
        "Strongman",
        "True Power",
        "The Greatest Knight",
        "Mi' Lord",
        "The Bowels Of Hell",
        "Not Today",
        "Death Killer",
        "More Than Just A Pretty Face",
        "Flashbacks From A Better Time",
        "How Assassins Are Born",
        "A Kingly Request",
        "The Worst Kind Of Person",
        "Exterminator",
        "Toast Master",
        "I'm God Tier Bro"
    ]
    
    //"":"",
    
    let defaults = UserDefaults.standard
    func read(_ Achievement: String) -> Bool{
        return defaults.bool(forKey: "A_" + Achievement)
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var BackButt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        self.view.backgroundColor = UIColor(patternImage: scaled)
        
        tblView.backgroundColor = .clear //UIColor(patternImage: scaled)
    
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        tblView.addGestureRecognizer(swipeRight)
        
        //BackButt.layer.borderWidth = 1
        //BackButt.layer.borderColor = UIColor.white.cgColor
        
        TitleLabel.backgroundColor = .black
        TitleLabel.layer.borderWidth = 2
        TitleLabel.layer.borderColor = UIColor(red:70, green: 61, blue: 48).cgColor
    }
    
    @IBAction func respondToSwipeGesture(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Names.count
    }
    
    func GetImage(_ Name: String) -> UIImage{
        if(read(Name)){
            return UIImage(named: "Check.png") ?? UIImage(named: "QuestionMark_.png")!
        }else{
            return UIImage(named: "X.png") ?? UIImage(named: "QuestionMark_.png")!
        }
    }
    
    func AddSubView(Image: String, Tag: Int, RemoveOld: Bool = false, OldTag: Int = 100){
        if(RemoveOld){
            if let viewWithTag = self.view.viewWithTag(OldTag) {
                viewWithTag.removeFromSuperview()
            }
        }
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Image)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImage.tag = Tag
        self.view.insertSubview(backgroundImage, at: 1)
    }
    
    func resizeImage(image: UIImage, Label: UILabel) -> UIImage {
        let newWidth:CGFloat = Label.bounds.size.width
        let newHeight:CGFloat = Label.bounds.size.height
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        //image.drawInRect(CGRect(0, 0, newWidth, newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeImage(image: UIImage, Label: UITextView) -> UIImage {
        let newWidth:CGFloat = Label.bounds.size.width
        let newHeight:CGFloat = Label.bounds.size.height
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        //image.drawInRect(CGRect(0, 0, newWidth, newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func SubViewUnder(Image: String, x:CGFloat, y:CGFloat,width:CGFloat,height:CGFloat,Tag:Int){
        let labelBackground = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        labelBackground.image = UIImage(named: Image)!
        labelBackground.tag = Tag
        self.view.insertSubview(labelBackground, at: 1)
    }
    
    func DeleteSubView(_ Tag: Int){
        if let viewWithTag = self.view.viewWithTag(Tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Achievement_Cell
        cell.Name.text = Names[indexPath.item]
        cell.Description.text = Descriptions[indexPath.item]
        cell.CheckImage.image = GetImage(Names[indexPath.item])
        
        //let image = UIImage(named: "Bricks.png")
        //let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        //cell.backgroundColor = UIColor(patternImage: scaled)
        
        let labelBackground = UIImageView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height))
        labelBackground.image = UIImage(named: "Table_Cell")!
        labelBackground.contentMode = .scaleToFill
        labelBackground.tag = 101
        cell.insertSubview(labelBackground, at: 0)
        
        cell.backgroundColor = .clear
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        swipeRight.direction = .right
        cell.addGestureRecognizer(swipeRight)
        
        return cell
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        /*
        UIView.animate(withDuration: 0.25) {
            if let theWindow = self.view {
                self.view.frame = CGRect(x:theWindow.frame.width - 15 , y: theWindow.frame.height - 15, width: 10 , height: 10)
                
            }
        }
        */
        dismiss(animated: true, completion: nil)
    }

}
