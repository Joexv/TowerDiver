//
//  TitleScreen.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/26/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit
import SafariServices

class TitleScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.white
        //Top_Button.layer.borderWidth = 2
        //Top_Button.layer.borderColor = UIColor.gray.cgColor
        SetBackground()
    }
    
    func SetBackground(){
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        view.backgroundColor = UIColor(patternImage: scaled)
    }
    @IBAction func Button(_ sender: Any) {
    }
    let defaults = UserDefaults.standard
    @IBOutlet weak var Top_Button: UIButton!
    @IBAction func Start_Button(_ sender: Any) {
        let hasCharacter: Bool = defaults.bool(forKey: "hasCharacter")
        //DisplayAlert(title: "Hmm", message: String(hasCharacter), button: "OK")
        if(hasCharacter){
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "EnterDungeon", sender: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "FirstTime", sender: nil)
            })
        }
    }
    
    @IBAction func Tutorial(_ sender: Any) {
        let hasCharacter: Bool = defaults.bool(forKey: "hasCharacter")
        if(hasCharacter){
            let alert = UIAlertController(title: "Warning", message: "It looks like you currently have a adventurer in the Tower, starting the tutorial will boot them out and they will have to start over! Are you sure you want to do that?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Take me to the Tutorial", style: .default, handler: { action in
                self.defaults.set(true, forKey: "DoTutorial")
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "EnterDungeon", sender: nil)
                })
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.defaults.set(true, forKey: "DoTutorial")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "EnterDungeon", sender: nil)
            })
        }
    }
    
    @IBAction func InfoButton(_ sender: Any) {
        //DisplayAlert(title: "Info", message: "v0.0.2 - Alpha" + "\n" + "Made by Joe Oliveira" + "\n" + "Testing and Art by Joseph Mooney", button: "OK")
        let alert = UIAlertController(title: "Info", message: "v" + Version + " - Alpha" + "\n" + "Made by Joe Oliveira" + "\n" + "With help from Joseph Mooney" + "\n" + "For a full list of credits check out our wiki page!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "How To Play", style: .default, handler: { action in
            self.GotoWiki()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    let Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    func GotoWiki(){
        let url = URL(string: "http://towerdiver.wikidot.com/")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    
    func DisplayAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //@IBOutlet var View: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
