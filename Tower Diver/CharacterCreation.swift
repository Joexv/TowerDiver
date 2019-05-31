//
//  CharacterCreation.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/21/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class CharacterCreation: UIViewController {

    
    var NewLine = "\n"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClassDescriptionLabel.text = "   -Warriors tend to find more weapons, but will also find more enemies. They also feature a high starting health!"
        // Do any additional setup after loading the view.
        
        //let image = UIImage(named: "Bricks.png")
        //let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        //view.backgroundColor = UIColor(patternImage: scaled)
        KingUnlocked = defaults.bool(forKey: "KingUnlocked")
        HauntedUnlocked = defaults.bool(forKey: "HauntedUnlocked")
        ToastUnlocked = defaults.bool(forKey: "ToasterUnlocked")
        let FirstToast: Bool = defaults.bool(forKey: "FirstToast")
        if(ToastUnlocked){
            ClassStepper.maximumValue = 5
            if(!FirstToast){
            ClassStepper.value = 5
            ClassLabel.text = "Toaster"
                ClassDescriptionLabel.text = "   -Quad slot toasting power for maximum toast capacity. 100 different power settings. 99 settings cause burnt toast and the perfect setting changes everytime you use it. Like wtf. Why do toasters do that."
                defaults.set(true, forKey: "FirstToast")
            }
        }
        SetBackground()
        
        ClassStepper.setDecrementImage(UIImage(named: "Arrow_Left"), for: .normal)
        ClassStepper.setIncrementImage(UIImage(named: "Arrow_Right"), for: .normal)
        
        ClassStepper.setDecrementImage(UIImage(named: "Arrow_Left_"), for: .highlighted)
        ClassStepper.setIncrementImage(UIImage(named: "Arrow_Right_"), for: .highlighted)
        
        ClassStepper.setDecrementImage(UIImage(named: "Arrow_Left_"), for: .focused)
        ClassStepper.setIncrementImage(UIImage(named: "Arrow_Right_"), for: .focused)
        
        ClassStepper.setDecrementImage(UIImage(named: "Arrow_Left_"), for: .selected)
        ClassStepper.setIncrementImage(UIImage(named: "Arrow_Right_"), for: .selected)
    }
    
    func GenClassImage(Class: String = "0") -> String{
        switch Class {
        case "0":
            return "Smol_Sword.png"
        case "1":
            return "Smol_Arrow.png"
        case "2":
            return "Smol_Staff.png"
        case "3":
            return "Smol_Scythe.png"
        case "4":
            return "Smol_Crown.png"
        case "5":
            return "Smol_Toaster.png"
        default:
            return "Smol_Dagger.png"
        }
    }
    
    func SetBackground(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        
        if let beginImage = CIImage(image: UIImage(named: GenClassImage(Class: String(Int(ClassStepper.value))))!){
            if let filter = CIFilter(name: "CIColorInvert"){
                filter.setValue(beginImage, forKey: kCIInputImageKey)
                var invertedImage = UIImage(ciImage: filter.outputImage!).alpha(0.3)
                invertedImage = resizeImage(image: invertedImage, newWidth: 200)
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.image = invertedImage
                backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
                backgroundImage.tag = 100
                self.view.insertSubview(backgroundImage, at: 0)
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        //image.drawInRect(CGRect(0, 0, newWidth, newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    var KingUnlocked: Bool = false
    var HauntedUnlocked: Bool = false
    var ToastUnlocked: Bool = false
    
    @IBAction func ClassStepper_OnChange(_ sender: Any) {
        AdjustClass()
    }
    
    func AdjustClass(){
        if(ClassStepper.value == 0){
            MusicPlayer().playSoundEffect(soundEffect: "Click")
            ClassLabel.text = "Warrior"
            ClassDescriptionLabel.text = "   -Warriors tend to find more weapons, but will also find more enemies. They also feature a high starting health!"}
        
        if(ClassStepper.value == 1){
            MusicPlayer().playSoundEffect(soundEffect: "Click")
            ClassLabel.text = "Ranger"
            ClassDescriptionLabel.text = "   -Rangers are immune to traps and find lots of gold, but they gain less power from weapons."}
        
        if(ClassStepper.value == 2){
            MusicPlayer().playSoundEffect(soundEffect: "Click")
            ClassLabel.text = "Mage"
            ClassDescriptionLabel.text = "   -Mages have a higher chance of finding potions, lower chance of finding curses, and they gain a small amount of power for each potion they drink, but they feature a very low starting health."}
        
        if(ClassStepper.value == 3 && HauntedUnlocked){
            MusicPlayer().playSoundEffect(soundEffect: "Click")
            ClassLabel.text = "The Haunted"
            ClassDescriptionLabel.text = "   -The Haunted is a class that is not strong against nor weak against any other class. They begin with only 5 Adjustment points for their base stats and they begin with 0 stats."
        }else if(ClassStepper.value == 3 && !HauntedUnlocked){
            ClassStepper.value += 1
        }
        
        if(ClassStepper.value == 4 && KingUnlocked){
            MusicPlayer().playSoundEffect(soundEffect: "Click")
            ClassLabel.text = "King"
            ClassDescriptionLabel.text = "   -As the King you control all the gold in the land. You begin with 7500 Gold and will find larger stacks of gold. As the King you are also not trained in teh art of war and your power starts at 50 and cannot be increased with Adjustments. As the King you have knowledge of all of secrets and tactics of your kingdom and will not fall for traps."
        }else if(ClassStepper.value == 4 && !KingUnlocked){
            if(ToastUnlocked){
                MusicPlayer().playSoundEffect(soundEffect: "Click")
                ClassStepper.value = 5
                ClassLabel.text = "Toaster"
                ClassDescriptionLabel.text = "   -Quad slot toasting power for maximum toast capacity. 100 different power settings. 99 settings cause burnt toast and the perfect setting changes everytime you use it. Like wtf. Why do toasters do that."
            }else{
                MusicPlayer().playSoundEffect(soundEffect: "Click")
                ClassStepper.value = 0
                ClassLabel.text = "Warrior"
                ClassDescriptionLabel.text = "   -Warriors tend to find more weapons, but will also find more enemies. They also feature a high starting health!"
            }
        }
        
        if(ClassStepper.value == 5){
            ClassLabel.text = "Toaster"
            ClassDescriptionLabel.text = "   -Quad slot toasting power for maximum toast capacity. 100 different power settings. 99 settings cause burnt toast and the perfect setting changes everytime you use it. Like wtf. Why do toasters do that."}
        
        SetBackground()
    }
    
    @IBAction func NextPage_Button(_ sender: Any) {
        if(nameBox.text == ""){
            defaults.set("Unknown Adventurer", forKey: "Name")
        }else{
            defaults.set(nameBox.text, forKey: "Name")
        }

        defaults.set(EasyMode_Switch.isOn, forKey: "isEasyMode")
        defaults.set(ClassStepper.value, forKey: "Class")
        if(ClassStepper.value == 3 && !HauntedUnlocked){
            DisplayAlert(title: "", message: "You have not unlocked this class!", button: "OK")
        }
        else if(ClassStepper.value == 4 && !KingUnlocked){
            DisplayAlert(title: "", message: "You have not unlocked this class!", button: "OK")
        }
        else{
            MusicPlayer().playSoundEffect(soundEffect: "Confirm")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "StatsPageSegue", sender: nil)
            })
        }
    }
    
    func DisplayAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var ClassLabel: UILabel!
    @IBOutlet weak var ClassStepper: UIStepper!
    @IBOutlet weak var ClassDescriptionLabel: UILabel!
    @IBOutlet weak var EasyMode_Switch: UISwitch!
}


extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @IBAction func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
