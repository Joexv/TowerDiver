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
        self.view.backgroundColor = UIColor.white
        Top_Button.layer.borderWidth = 2
        Top_Button.layer.borderColor = UIColor.gray.cgColor
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        
        view.backgroundColor = UIColor(patternImage: scaled)
    }
    
    func SetBackground(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "TitleScreen.png")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
    }
    @IBAction func Button(_ sender: Any) {
    }
    
    @IBOutlet weak var Top_Button: UIButton!
    @IBAction func Start_Button(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "EnterDungeonSegue", sender: nil)
        })
    }
    @IBAction func InfoButton(_ sender: Any) {
        //DisplayAlert(title: "Info", message: "v0.0.2 - Alpha" + "\n" + "Made by Joe Oliveira" + "\n" + "Testing and Art by Joseph Mooney", button: "OK")
        let alert = UIAlertController(title: "Info", message: "v0.0.2 - Alpha" + "\n" + "Made by Joe Oliveira" + "\n" + "Testing and Art by Joseph Mooney", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "How To Play", style: .default, handler: { action in
            self.GotoWiki()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func GotoWiki(){
        let url = URL(string: "https://github.com/Joexv/SwipeRPG/wiki")
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
