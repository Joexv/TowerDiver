//
//  TitleScreen.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/26/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import SwiftySound
import PopupDialog

class MusicPlayer{
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    let defaults = UserDefaults.standard
    func startBackMusic(_ SongName: String = "background"){
        stopBackgroundMusic()
        if(!defaults.bool(forKey: "Music")){
        if let bundle = Bundle.main.path(forResource: SongName, ofType: "mp3") {
            let backgroundMusic = URL(fileURLWithPath: bundle)
            Sound.play(url: backgroundMusic, numberOfLoops: -1)
            }
        }
    }
    
    func stopBackgroundMusic() {
        Sound.stopAll()
    }
    
    public func playSoundEffect(soundEffect: String) {
        if(!defaults.bool(forKey: "Music")){
        if let bundle = Bundle.main.path(forResource: soundEffect, ofType: "mp3") {
            let backgroundMusic = URL(fileURLWithPath: bundle)
            Sound.stop(for: backgroundMusic)
            Sound.play(url: backgroundMusic, numberOfLoops: 0)
            }
        }
    }
}

class TitleScreen: UIViewController {
    
    public func SetDarkMode(){
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
        pv.titleColor   = .white
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
        pv.messageColor = UIColor(white: 0.8, alpha: 1)
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.liveBlurEnabled = true
        ov.opacity         = 0.7
        ov.color           = .black
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        db.titleColor     = .white
        db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        cb.titleColor     = UIColor(white: 0.6, alpha: 1)
        cb.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
        cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
    }

    override func viewDidLoad() {
        SetDarkMode()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.white
        //Top_Button.layer.borderWidth = 2
        //Top_Button.layer.borderColor = UIColor.gray.cgColor
        SetBackground()
        try! AVAudioSession().setCategory(.ambient)
        try! AVAudioSession().setActive(true, options: .notifyOthersOnDeactivation)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        MusicPlayer().startBackMusic("ambient_menu")
        super.viewDidAppear(true)
    }
    
    func SetBackground(){
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        view.backgroundColor = UIColor(patternImage: scaled)
        //SetImage()
        //SetGIF("Mist_3")
    }
    
    func SetImage(){
        let labelBackground = UIImageView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.bounds.width, height: view.bounds.height))
        labelBackground.image = UIImage(named: "Background_Test_5.jpg")!
        labelBackground.contentMode = .scaleAspectFill
        labelBackground.tag = 101
        view.insertSubview(labelBackground, at: 0)
    }
    
    func SetGIF(_ Name: String){
        let filePath = Bundle.main.path(forResource: Name, ofType: "gif")
        let gif = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.load(gif, mimeType: "image/gif", textEncodingName: String(), baseURL: NSURL() as URL)
        webViewBG.isUserInteractionEnabled = false;
        webViewBG.tag = 100
        webViewBG.isOpaque = false
        webViewBG.backgroundColor = .clear
        
        webViewBG.frame = self.view.frame
        webViewBG.contentMode = .scaleToFill
        webViewBG.alpha = 0.4
        
        self.view.addSubview(webViewBG)
        self.view.sendSubviewToBack(webViewBG)
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
            let Title: String = "Warning"
            let Message: String = "It looks like you currently have a adventurer in the Tower, starting the tutorial will boot them out and they will have to start over! Are you sure you want to do that?"
            let popup = PopupDialog(title: Title, message: Message)
            let buttonOne = DefaultButton(title: "Nevermind") {}
            let buttonTwo = DefaultButton(title: "Take me to the tutorial") {
                self.defaults.set(true, forKey: "DoTutorial")
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "EnterDungeon", sender: nil)
                })
            }
            popup.addButtons([buttonOne, buttonTwo])
            self.present(popup, animated: true, completion: nil)
        }else{
            self.defaults.set(true, forKey: "DoTutorial")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "EnterDungeon", sender: nil)
            })
        }
    }
    
    @IBAction func InfoButton(_ sender: Any) {
        let Title: String = "Info"
        let Message: String = "v\(Version) - Beta\nMade by Joe Oliveira.\nSpecial thanks to Joseph Mooney.\n\n For a full list of credits check out our wiki page!"
        let popup = PopupDialog(title: Title, message: Message)
        let buttonOne = DefaultButton(title: "OK") {
            print("You canceled the dialog.")
        }
        let buttonTwo = DefaultButton(title: "Wiki") {
            self.GotoWiki()
        }
        popup.addButtons([buttonOne, buttonTwo])
        self.present(popup, animated: true, completion: nil)
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
    func PD_OK(Title: String, Message: String){
        let popup = PopupDialog(title: Title, message: Message)
        let buttonOne = CancelButton(title: "OK") {
            print("You canceled the dialog.")
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
    
    public func Display(Title: String, Message: String){
        // Create the dialog
        let popup = PopupDialog(title: Title, message: Message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
            print("What a beauty!")
        }
        
        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
            print("Ah, maybe next time :)")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}
