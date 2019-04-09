//
//  ViewController.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/21/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit
import SideMenu
import XLActionController

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    let Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    var MaxHP: Double = 0
    var CurrentHP: Double  = 0
    var Power: Double = 0
    var Gold: Double  = 0
    var Potions: Double  = 0
    var Floor: Int = 0
    var HighestFloor: Int = 0
    var Name: String = "Bob"
    var Class: Int = 0
    
    var AfterDeath: Int = 1
    var SquirrelMark: Bool = false
    var hasKilledDeath: Bool = false
    var hasESP: Bool = false
    var isEasyMode: Bool = false
    
    var FloorTenths: Int = 0
    
    var CurseImmunity: Bool = false
    
    let MonsterArray: [String] = ["Slime,60,2", "Green Slime,60,1", "Goblin,30,0", "Spider,50,1", "Knight,100,0","Wizard,80,2", "Behemoth,245,0", "Ghost,90,2", "Snake,40,1", "Giant,110,0", "Imp,60,1", "Rat,45,0", "Cleric,140,2", "Minotaur,130,0", "Lamia,160,2", "Skeleton,180,0", "Paladin,200,0", "Fire Spirit,150,2", "Dragon,250,1", "Bat,80,1", "Chimera,200,0", "Cockatrice,135,1", "Demon,220,2", "Zombie,100,0", "Bandit,45,1"]

    let BossArray: [String] = ["Dragon,250,1", "Demon,220,2", "Chimera,200,0", "Behemoth,245,0", "Gilgamesh,300,0"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)        
        MainView.backgroundColor = UIColor(patternImage: scaled)
        //AddSubView(Image: "Test_Background.png", Tag: 100)
        let hasCharacter: Bool = defaults.bool(forKey: "hasCharacter")
        if(!hasCharacter){
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "CharacterCreationSegue", sender: nil)
            })
        }
        else{            
            MainImage.image = UIImage(named: "QuestionMark_.png")
            defaults.set(false, forKey: "DisplaySetup")
            LoadingOverlay.shared.showOverlay(view: self.view)
        }
    }
    
    func SetIcon(Label: UILabel, Image: String){
        let TempString: String = Label.text!
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:Image)
        //Set bound to reposition
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 20, height: 20)
        //imageAttachment.image!.size.width
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: TempString)
        completeText.append(textAfterIcon)
        Label.textAlignment = .center
        Label.attributedText = completeText
    }
    
    @IBAction func DisplayHP(){
                let ClassString: String = GenClassName()
        var HealthString: String = "Current HP: " + DoubleString(Input: CurrentHP) + "\n" + "Max HP: " + DoubleString(Input: MaxHP) + "\n" + "Class: " + ClassString
        if(isBleeding){
            HealthString = HealthString + "\n" + "Bleeding: " + String(10 - BleedingCounter) + " events until recovered."
        }
        if(isConfused){
            HealthString = HealthString + "\n" + "Confusion: " + String(10 - ConfusionCounter) + " events until recovered."
        }
        if(hasESP){
            HealthString = HealthString + "\n" + "Has ESP"
        }
        if(SquirrelMark){
            HealthString = HealthString + "\n" + "Has the Mark of The Squirrel."
        }
        if(hasKilledDeath){
            HealthString = HealthString + "\n" + "Has killed Death."
        }
        DisplayAlert(title: "Health", message: HealthString, button: "OK")
    }
    
    @IBAction func DisplayGold(){
     DisplayAlert(title: "Gold", message: DoubleString(Input: Gold), button: "OK")
    }
    
    @IBAction func DisplayPower(){
        var PowerString: String = "Power: " + DoubleString(Input: Power)
        
        if(isEasyMode){
            PowerString = PowerString + "\n" + "-Easy Mode-"
        }
        DisplayAlert(title: "Power", message: PowerString, button: "OK")
    }
    
    func GenClassName() -> String{
        var ClassString: String = ""
        switch Class{
        case 0:
            ClassString = "Warrior"
        case 1:
            ClassString = "Ranger"
        case 2:
            ClassString = "Mage"
        case 3:
            ClassString = "The Haunted"
        case 4:
            ClassString = "King"
        case 5:
            ClassString = "Toaster"
        default:
            ClassString = "Boop"
        }
        return ClassString
    }
    
    @IBOutlet weak var Side_Button: UIButton!
    
    let MaxValue: Double = 5000000000000000
    let OverFlowed: Double = -100000000000000
    
    func FixOverflowMaybe(){
        if(Power >= MaxValue || Power < OverFlowed){
            Power = MaxValue
        }
        if(MaxHP >= MaxValue || MaxHP < OverFlowed){
            MaxHP = MaxValue
        }
        if(CurrentHP >= MaxValue || CurrentHP < OverFlowed){
            CurrentHP = MaxValue
        }
        if(Gold >= MaxValue || Gold < OverFlowed){
            Gold = MaxValue
        }
    }
    
    func FixStats(){
        FixOverflowMaybe()
        Power = Power.rounded(toPlaces: 0)
        CurrentHP = CurrentHP.rounded(toPlaces: 0)
        MaxHP = MaxHP.rounded(toPlaces: 0)
        Gold = Gold.rounded(toPlaces: 0)
        Potions = Potions.rounded(toPlaces: 0)
        
        if(Power < 1){
            Power = 0}
        if(Gold < 1){
            Gold = 0}
        if(Potions < 1){
            Potions = 0}
        if(CurrentHP < 1 && CurrentHP > -100000000000){
            Dead()
        }
    }
    
    var KingUnlocked: Bool = false
    var HauntedUnlocked: Bool = false
    
    func SetLabels(){
        //Name_Label.text = Name
        Name_Label.text = "Floor: " + String(Floor)
        HP_Label.text = "HP: " + CutLabel(CurrentHP) + "\\" + CutLabel(MaxHP)
        Power_Label.text = CutLabel(Power)
        Gold_Label.text = CutLabel(Gold)
        Potion_Label.text = CutLabel(Potions)
        
        if(CurrentHP < MaxHP / 2){
            HP_Label.backgroundColor = UIColor.red
        }else{
            HP_Label.backgroundColor = UIColor(rgb: 0x65ca45)
        }
        
        SetIcon(Label: Power_Label, Image: GenClassImage(Class: String(Class)))
        SetIcon(Label: Gold_Label, Image: "Gold_Icon")
        SetIcon(Label: Potion_Label, Image: "Potion_Icon")
        
        //Potion_Label.set(image: UIImage(named: "Potion_Icon")!, with: Potion_Label.text!)
        
        if(CurrentHP < 1 && !inHell){
            Dead()
        }
        
        if(!KingUnlocked && Gold >= 75000){
            defaults.set(true, forKey: "KingUnlocked")
            KingUnlocked = true
            DisplayAlert(title: "Unlocked Character!", message: "You unlocked 'King' as a playable class!", button: "OK")
        }
    }
    
    func CutLabel(_ Input: Double) -> String{
        var Letter: String = ""
        var Number = DoubleString(Input: Input)
        if(Input >= 1000000000000000){
            Letter = "q"
            Number.removeLast(15)
        }else if(Input >= 1000000000000 && Input < 1000000000000000){
            Letter = "t"
            Number.removeLast(12)
        }else if(Input >= 10000000000 && Input < 1000000000000){
            Letter = "b"
            Number.removeLast(9)
        }else if(Input >= 10000000 && Input < 10000000000){
            Letter = "m"
            Number.removeLast(6)
        }else if(Input >= 100000 && Input < 10000000){
            Letter = "k"
            Number.removeLast(3)
        }
        return String(Number) + Letter
    }
    
    func DoubleString(Input: Double) -> String{
        var TempString: String = String(Input.rounded(toPlaces: 1))
        TempString.removeLast(2)
        TempString = TempString.replacingOccurrences(of: ".", with: "")
        return TempString
    }
    
    func ReadStats(){
        Name = PullString(Stat: "Name")
        Class = PullInt(Buff: "Class")
        MaxHP = PullDouble(Stat: "MaxHP")
        CurrentHP = PullDouble(Stat: "CurrentHP")
        Power = PullDouble(Stat: "Power")
        Gold = PullDouble(Stat: "Gold")
        Potions = PullDouble(Stat: "Potions")
        Floor = PullInt(Buff: "Floor")
        HighestFloor = PullInt(Buff: "HighestFloor")
        
        AfterDeath = PullInt(Buff: "AfterDeath")
        
        hasESP = PullBool(Stat: "hasESP")
        hasKilledDeath = PullBool(Stat: "hasKilledDeath")
        SquirrelMark = PullBool(Stat: "SquirrelMark")
        CurseImmunity = PullBool(Stat: "isCrazy")
        isEasyMode = PullBool(Stat: "isEasyMode")
        KingUnlocked = PullBool(Stat: "KingUnlocked")
        HauntedUnlocked = PullBool(Stat: "HauntedUnlocked")
        
        isBleeding = PullBool(Stat: "isBleeding")
        isConfused = PullBool(Stat: "Confused")
        BattlePredict = PullBool(Stat: "BattlePredict")
        
        Theme = PullString(Stat: "MonsterTheme")
    }
    var BattlePredict: Bool = false
    func PullString(Stat: String) -> String{
    let result = defaults.object(forKey: Stat)
    return result as? String ?? "Bob"
    }
    
    func PullDouble(Stat: String) -> Double{
        let result = defaults.object(forKey: Stat)
        return result as? Double ?? 0
    }
    
    func PullInt(Buff: String) -> Int{
        let result = defaults.object(forKey: Buff)
        return result as? Int ?? 0
    }
    
    func PullBool(Stat: String) -> Bool{
        let result = defaults.object(forKey: Stat)
        return result as? Bool ?? false
    }
    
    func Next(){
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        
        MainView.backgroundColor = UIColor(patternImage: scaled)
        
        topEvent("Continue", #selector(GenerateEventButton))
        bottomEvent("Continue", #selector(GenerateEventButton))
        SaveStats()
    }
    
    func disablePotions(){
        Potion_Label.isUserInteractionEnabled = false
    }
    
    func enablePotions(){
        Potion_Label.isUserInteractionEnabled = true
    }
    
    func Dead(){
        disablePotions()
        AdventureLog.text = "You died!" + "\n" + "You made it to floor: " + String(Floor) + "!"
        MainImage.image = UIImage(named: "Dead.png")
        
        topEvent("Well Shucks", #selector(Restart))
        bottomEvent("Well Shucks", #selector(Restart))
    }
    
    @IBAction func Restart(_ sender: Any){
        enablePotions()
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "CharacterCreationSegue", sender: nil)
        })
    }
    
    @IBAction func Top_Button(_ sender: Any) {
        GenEvent()
    }
    
    @IBAction func Bottom_Button(_ sender: Any) {
        GenEvent()
    }
    
    @IBAction func GenerateEventButton(_Sender:Any){
        NSLog("Generating Event...")
        GenEvent()
    }
    
    var CurseChance: Int = 8
    var EnemyChance: Int = 20
    var FindItemChance: Int = 34
    var MerchantChance: Int = 14
    var ElevatorChance: Int = 3
    var FallChance: Int = 3
    var MiscEventChance: Int = 10
    var CampChance: Int = 3
    
    var EnhancedChance: Int = 8
    var BossChance: Int = 5
    
    var BadMerchantChance: Int = 5
    
    var WeaponChance: Int = 50
    var GoldChance: Int = 20
    var PotionChance: Int = 15
    
    var CursedWeaponChance: Int = 10
    
    var MimicChance: Int = 10
    
    func LoadChances() -> UInt32{
        CurseChance = 10
        EnemyChance = 25
        FindItemChance = 35
        MerchantChance = 13
        ElevatorChance = 2
        FallChance = 2
        MiscEventChance = 10
        CampChance = 5
        
        EnhancedChance = 15
        BossChance = 5
        BadMerchantChance = 5
        WeaponChance = 50
        GoldChance = 20
        PotionChance = 15
        CursedWeaponChance = 10
        MimicChance = 10
        
        
        CurseChance += PullInt(Buff: "CurseChance")
        EnemyChance += PullInt(Buff: "EnemyChance")
        FindItemChance += PullInt(Buff: "FindItemChance")
        MerchantChance += PullInt(Buff: "MerchantChance")
        ElevatorChance += PullInt(Buff: "ElevatorChance")
        FallChance += PullInt(Buff: "FallChance")
        MiscEventChance += PullInt(Buff: "MiscEventChance")
        CampChance += PullInt(Buff: "CampChance")
        
        EnemyChance += CurseChance
        FindItemChance += EnemyChance
        MerchantChance += FindItemChance
        ElevatorChance += MerchantChance
        FallChance += ElevatorChance
        MiscEventChance += FallChance
        CampChance += MiscEventChance
        
        let _ = LoadItemChances()
        
        return UInt32(CampChance)
    }
    
    func LoadItemChances() -> UInt32{
        WeaponChance += PullInt(Buff: "WeaponChance")
        GoldChance += PullInt(Buff: "GoldChance")
        PotionChance += PullInt(Buff: "PotionChance")
        
        CursedWeaponChance += PullInt(Buff: "CursedWeaponChance")
        
        MimicChance += PullInt(Buff: "MimicChance")
        
        GoldChance += WeaponChance
        PotionChance += GoldChance
        
        return UInt32(PotionChance)
    }
    func Save(Input: Any, Key: String){
        defaults.set(Input, forKey: Key)
    }
    
    
    func SaveStats(){
        Save(Input: Name, Key: "Name")
        Save(Input: Class, Key: "Class")
        Save(Input: MaxHP, Key: "MaxHP")
        Save(Input: CurrentHP, Key: "CurrentHP")
        Save(Input: Power, Key: "Power")
        Save(Input: Gold, Key: "Gold")
        Save(Input: Potions, Key: "Potions")
        Save(Input: Floor, Key: "Floor")
        Save(Input: HighestFloor, Key: "HighestFloor")
        
        Save(Input: AfterDeath, Key: "AfterDeath")
        
        Save(Input: hasESP, Key: "hasESP")
        Save(Input: hasKilledDeath, Key: "hasKilledDeath")
        Save(Input: SquirrelMark, Key: "SquirrelMark")
        Save(Input: CurseImmunity, Key: "isCrazy")
        Save(Input: isEasyMode, Key: "isEasyMode")
        
        Save(Input: KingUnlocked, Key: "KingUnlocked")
        Save(Input: HauntedUnlocked, Key: "HauntedUnlocked")
        
        Save(Input: isBleeding, Key: "isBleeding")
    }
    
    func DoBleedDamage(){
        if(isBleeding){
            CurrentHP -= CurrentHP * (1 / 10)
            BleedingCounter += 1
            if(BleedingCounter >= 10){
                BleedingCounter = 0
                isBleeding = false
            }
            
            if(CurrentHP < 1){
                Dead()
                AdventureLog.text = AdventureLog.text + "\nYour injuries were too great and you bled out!"
            }
        }
    }
    
    func SwapButtons(){
        if(isConfused){
            if(ConfusionCounter >= 10){
                isConfused = false
                ConfusionCounter = 0
                Top_Button.frame.origin.x = TopButtonX
                Top_Button.frame.origin.y = TopButtonY
                
                Bottom_Button.frame.origin.x = BottomButtonX
                Bottom_Button.frame.origin.y = BottomButtonY
                
            }else{
                ConfusionCounter += 1
                Top_Button.frame.origin.x = BottomButtonX
                Top_Button.frame.origin.y = BottomButtonY

                Bottom_Button.frame.origin.x = TopButtonX
                Bottom_Button.frame.origin.y = TopButtonY
            }
        }
    }
    
    let MaxToast: Double = 100000000000000
    
    func DoToasterChange_Old(){
        if(Class == 5){
            let TempMax: Double = (MaxToast * 5) / 320
            Power = Double.random(in: 32...TempMax)
            let HPPercent = CurrentHP / MaxHP
            MaxHP = Double.random(in: 32...TempMax)
            CurrentHP = MaxHP * HPPercent
            Gold = Double.random(in: 23...TempMax)
        }
    }
    
    func DoToasterChange(){
        if(Class == 5){
            let Max: Double = Double(Floor * 200) * Double(arc4random_uniform(32)) + 100
            var Gen: Double = Double.random(in: 1...Max)
            NSLog(String(Gen))
            AdjustHP(Gen, Add: Bool.random())
            Gen = Double.random(in: 1...Max)
            NSLog(String(Gen))
            AdjustGold(Gen, Add: Bool.random())
            Gen = Double.random(in: 1...Max)
            NSLog(String(Gen))
            Adjustpower(Gen, Add: Bool.random())
            Gen = Double.random(in: 1...Max)
            NSLog(String(Gen))
            AdjustPotions(Gen, Add: Bool.random())
            if(CurrentHP < 1){
                CurrentHP = 1
            }
            if(Power < 1){
                Power = 1
            }
            if(MaxHP < 1){
                MaxHP = 1
            }
            
            if(CurrentHP > MaxHP){
                CurrentHP = MaxHP
            }
        }
    }
    
    var DecensionAdjustment: Int = 1
    
    func Escape(){
        MainImage.image = UIImage(named: "DoubleDoors.png")
        AdventureLog.text = "You finally see the entrance to this dreadful Tower.... It's within your grasps..."
        topEvent("...", #selector(Escape_2))
        bottomEvent("...", #selector(Escape_2))
    }
    
    
    //Added in these two function in order to clean up the code a little and to be able to more easily change button colors on the go
    // for the Event selector put #Selector(Your Event)
    func topEvent(_ Title: String, _ Event: Selector){
        if(isConfused){
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle(Title, for: .normal)
            Bottom_Button.setTitleColor(UIColor.white, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: Event, for: .touchUpInside)
        }else{
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle(Title, for: .normal)
            Top_Button.setTitleColor(UIColor.white, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: Event, for: .touchUpInside)
        }
    }
    
    func bottomEvent(_ Title: String, _ Event: Selector){
        if(isConfused){
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle(Title, for: .normal)
            Top_Button.setTitleColor(UIColor.white, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: Event, for: .touchUpInside)
        }else{
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle(Title, for: .normal)
            Bottom_Button.setTitleColor(UIColor.white, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: Event, for: .touchUpInside)
        }
    }
    
    @IBAction func Escape_2(){
        MainImage.image = UIImage(named: "Outside.png")
        AdventureLog.text = "You push open the doors. Fresh air and sunlight feel like the greatest things to ever have graced your face. You are finally free..."
        
        topEvent("...", #selector(Escape_3))
        bottomEvent("...", #selector(Escape_3))
    }
    
    @IBAction func Escape_3(){
        MainImage.image = nil
        AdventureLog.text = "As you take your first step outside, you feel something is off... You brush it off as probably dehydration... But who cares, you're finally free." + "\n" + "Once you get to your house, you find something truely horrifying... you forgot to feed your squirrel! You see his body laying in his little squirrel bed... Cold... Lifeless.... What was the point of escaping that nightmare to just go into another?"
        
        topEvent("...", #selector(Escape_4))
        bottomEvent("...", #selector(Escape_4))
    }
    
    @IBAction func Escape_4(){
        AdventureLog.text = "You wander until you return back to your home.. But it is as you left it.. Burnt to the ground..The bodies of bandits lie fallen across the ground.. Inside all that's left are the charred remains of what was once your family..."
        
        topEvent("...", #selector(Escape_5))
        bottomEvent("...", #selector(Escape_5))
    }
    
    @IBAction func Escape_5(){
        AdventureLog.text = "What was the point of escaping that nightmare to just go into another?"
        
        topEvent("The End?", #selector(Restart))
        bottomEvent("The End?", #selector(Restart))
    }
    
    func GenEvent(){
        NSLog("Toaster Stat Change")
        DoToasterChange()
        NSLog("Checking for Bleeding")
        DoBleedDamage()
        NSLog("Checking for confusion")
        //SwapButtons()
        //Confusion event is now handled when setting button events
        NSLog("Saving Stats")
        SaveStats()
        NSLog("Fixing stats")
        FixStats()
        NSLog("Setting Labels")
        SetLabels()
        
        NSLog("Wiping images and setting main to QuestionMark_.png")
        TypeImage.image = nil
        ClassImage.image = nil
        MainImage.image = UIImage(named: "QuestionMark_.png")
        AdventureLog.text = "Generating Event"
        
        if(!defaults.bool(forKey: "ReturnTrip")){
            FloorTenths += 1
            if(FloorTenths >= 6){
                Floor += 1
                FloorTenths = 0
            }
            NSLog("Floor: " + String(Floor))
            NSLog("Floor Tenths: " + String(FloorTenths))
            if(Floor > HighestFloor){
                NSLog("Setting highest floor")
                defaults.set(Floor, forKey: "HighestFloor")
                defaults.set(GenClassName(), forKey: "HF_Class")
                defaults.set(Power, forKey: "HF_Power")
                defaults.set(hasKilledDeath, forKey: "HF_KilledDeath")
                defaults.set(SquirrelMark, forKey: "HF_SquirrelMark")
            }
            if(Floor < 1){
                Floor = 1
            }
        }else{
            FloorTenths += 1
            if(FloorTenths >= 6){
                Floor -= 1
                FloorTenths = 0
            }
            
            DecensionAdjustment = 4200 - Floor
            NSLog(String(DecensionAdjustment))
        }
        if(Floor <= 1 && FloorTenths > 4 && defaults.bool(forKey: "ReturnTrip")){
            Escape()
        }else if(Floor >= 251 && !defaults.bool(forKey: "ReturnTrip")){
            FinalFloor()
        }else{
        Name_Label.text = "Floor: " + String(Floor)
        MainImage.image = nil
        
        let Total: UInt32 = LoadChances() + 1
        let Result: Int = Int(arc4random_uniform(Total)) + 5
        NSLog("Total: " + String(Total))
        NSLog("Generated Number: " + String(Result))
        if(Result >= 0 && Result <= CurseChance ){
            NSLog("Curse")
            Curse(useString: true, isEvent: true, isBagCurse: false, ConfusionCurse: false)
        }else if(Result > CurseChance && Result <= EnemyChance){
            NSLog("Battle")
            Battle()
        }else if(Result > EnemyChance && Result <= FindItemChance){
            NSLog("Find Item")
            FindItem()
        }else if(Result > FindItemChance && Result <= MerchantChance){
            NSLog("Find Merchant")
            FindMerchant()
        }else if(Result > MerchantChance && Result <= ElevatorChance){
            NSLog("Find Elevator")
            FindElevator()
        }else if(Result > ElevatorChance && Result <= FallChance && Floor > 10){
            NSLog("Fall")
            Fall()
        }else if(Result > FallChance && Result <= MiscEventChance){
            NSLog("Generating Misc Event")
            GenMiscEvent()
        }else if(Result > MiscEventChance && Result <= CampChance){
            NSLog("Find Camp")
            FindCamp()
        }else{
            NSLog("FindNothing")
            DoNothing()
        }
        }
    }
    
    func FinalFloor(){
        AdventureLog.text = "As you advance up the flight of stairs to the next floor, you're blinded by a bright light. You walk towards the light up to a majestic set of double doors."
        
        MainImage.image = UIImage(named: "DoubleDoors.png")
        topEvent("Open Doors", #selector(OpenFinalDoors))
        bottomEvent("Open Doors", #selector(OpenFinalDoors))
    }
    
    @IBAction func OpenFinalDoors(){
        MainImage.image = UIImage(named: "FinalRoom.png")
        AdventureLog.text = "Through the double doors you enter into a small white room, with no windows, no doors. Only a banner that hangs from the ceiling that says 'Congratulations'. You look to the back of the room and there is a pedestal..."
        topEvent("Approach Toaster", #selector(ApproachToaster))
        bottomEvent("Approach Toaster", #selector(ApproachToaster))
    }
    
    @IBAction func ApproachToaster(){
        MainImage.image = UIImage(named: "Toaster.png")
        AdventureLog.text = "The pedestal has a nice silver 4 slot toaster, and a tiny index card that simply says 'Free Toaster'."
        topEvent("Grab Toaster", #selector(GrabToaster))
        bottomEvent("Grab Toaster", #selector(GrabToaster))
    }
    
    @IBAction func GrabToaster(){
        MainImage.image = nil
        AdventureLog.text = "As you pick up the toaster, the doors behind you close and vanish. Leaving you alone and trapped with no way out. Nothing but the banner hanging above you, acknowledging your existance."
        
        defaults.set(true, forKey: "ToasterUnlocked")
        //defaults.set(false, forKey: "hasCharacter")
        topEvent("Search For A Way out", #selector(AttemptEscape))
        bottomEvent("Search For A Way Out", #selector(AttemptEscape))
    }
    
    @IBAction func AttemptEscape(){
        AdventureLog.text = "After a while of searching for a way out, you realize you're trapped, and soon you give up hope of ever leaving. So you sit down on the ground, hold your free toaster, and cry... The lights flicker and go out. Leaving nothing but the sound of your pitiful sobs, echoing in an empty void."
        topEvent("Wait For Rescue", #selector(Rescue))
        bottomEvent("Give Up", #selector(Restart))
    }
    
    @IBAction func Rescue(){
        AdventureLog.text = "You wait...."
        Rescue_Count = 0
        topEvent("...", #selector(Rescue_Loop))
        bottomEvent("...", #selector(Rescue_Loop))
    }
    var Rescue_Count: Int = 0
    @IBAction func Rescue_Loop(){
        Rescue_Count += 1
        if(Rescue_Count < 10){
            topEvent("...", #selector(Rescue_Loop))
            bottomEvent("...", #selector(Rescue_Loop))
        }else{
            AdventureLog.text = "It's been what feels like years since you last saw the light of day. You've been trapped in this Tower for days, and are barely hanging onto life. Suddenly, the doors reappear and open as another unsuspecting adventurer enters the final room."
            topEvent("...", #selector(Decend))
            bottomEvent("...", #selector(Decend))
        }
    }
    
    @IBAction func Decend(){
        AdventureLog.text = "You quickly put the Toaster back on the pedestal anbd hide behind the pedestal waiting for them to come close. As they reach for your toaster you jump out, and kill them. You grab your precious toaster and run out the rapidly closing doors! You made it! You're alive!! But you still have to escape this Tower..."
        defaults.set(true, forKey: "ReturnTrip")
        Next()
    }
    
    func DoNothing(){
        AdventureLog.text = "Nothing was here"
        Next()
    }
    
    func FindCamp(){
        MainImage.image = UIImage(named: Theme + "Tent.png")
        AdventureLog.text = "You find an empty room big enough for a camp..."
        topEvent("Setup Camp", #selector(DoCamp))
        bottomEvent("Just Rest", #selector(DoCampRest))
        
        if(Potions < 3)
        {
            topEvent("Just Rest", #selector(DoCampRest))
        }
    }
    
    @IBAction func DoCamp(){
        CurrentHP = MaxHP
        Potions -= 3
        isBleeding = false
        BleedingCounter = 0
        SetLabels()
        let Gen: UInt32 = arc4random_uniform(100)
        if(Gen >= 20 && Gen < 25){
            if(!defaults.bool(forKey: "Home_Dream") || !defaults.bool(forKey: "Castle_Dream") || !defaults.bool(forKey: "Market_Dream")){
            AdventureLog.text = "You awaken and feel odd..."

                topEvent("Continue", #selector(DreamWorld))
                bottomEvent("Continue", #selector(DreamWorld))
            }else{
                AdventureLog.text = "You setup a camp and feel refreshed and well rested!"
                Next()
            }
        }else{
            AdventureLog.text = "You setup a camp and feel refreshed and well rested!"
            Next()
        }
    }
    
    @IBAction func DreamWorld(){
        MainImage.image = nil
        if(!defaults.bool(forKey: "Home_Dream") && defaults.bool(forKey: "HasKilledDeath")){
            HomeEvent()
        }else if (!defaults.bool(forKey: "Castle_Dream") && KingUnlocked && Floor >= 100){
            GenCastleEvent()
        }else if(!defaults.bool(forKey: "Market_Dream") && defaults.bool(forKey: "ReturnTrip")){
            GenMarketEvent()
        }else{
            GenEvent()
        }
    }
    
   @IBAction func CastleEvent(){
        AdventureLog.text = "You enter the next room and are blinded by a bright light. Once the light clears, you look around and see that you are in the old castle dungeon.."
        MainImage.image =  UIImage(named: "QuestionMark_.png")
    
        topEvent("Attempt To Escape", #selector(CastleEvent2))
        bottomEvent("Wait", #selector(CastleEvent2_b))
    }
    
   @IBAction func CastleEvent2(){
        AdventureLog.text = "You search your cell for a way out. You remember about a whole you were digging. You move what appears to have once been a bed to reveal a large tunnel."
        MainImage.image =  UIImage(named: Theme + "Hole.png")
    
        topEvent("Go Into Hole", #selector(CastleEvent3))
        bottomEvent("Stay", #selector(CastleEvent2_b))
    }
    
    @IBAction func CastleEvent3(){
        AdventureLog.text = "You climb into the hole, and crawl. After a while of crawling through the tunnel you reach the end of the tunnel. You turn back and return to your cell. As you exit the hole there is a guard waiting fo you with a crossbow. The last thing you see was the guard pulling the trigger...."
        MainImage.image =  UIImage(named: Theme + "Hole.png")
        CurrentHP = 1
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
   @IBAction func CastleEvent2_b(){
        AdventureLog.text = "You sit and wait for a guard to come by. The guard opens your cell and motions you to get up and follow him."
        MainImage.image =  UIImage(named: Theme + "Knight.png")
    
        topEvent("Follow Guard", #selector(CastleEvent3_b))
        bottomEvent("Attempt To Escape", #selector(CastleEvent3_c))
    }
    
    @IBAction func CastleEvent3_b(){
        AdventureLog.text = "The guard leads you down many hallways and up quite a few flights of stairs. You eventually get to the Royal Hall. The guard leads you to the foot of the throne and forces you to kneel. You look up and see the King sitting in front of you stuffing his face full of chicken..."
        MainImage.image =  nil
        topEvent("Ask Why You Are Here", #selector(CastleEvent4_a))
        bottomEvent("Wait", #selector(CastleEvent4_b))
    }
    
    @IBAction func CastleEvent4_a(){
        AdventureLog.text = "You ask the King why you were locked up and brought here. The King just laughs and says 'You know exactly why you're here! You killed your wife and child! You are a monster! But I have a proposition for you. And I think you're the guy for the job.'"
        CastleEvent_5()
    }
    
    func CastleEvent_5(){
        MainImage.image =  nil
        defaults.set(true, forKey: "Castle_Dream")
        AdjustGold(Gold * 1/10)
        Adjustpower(Power * 1/20)
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func CastleEvent4_b(){
        AdventureLog.text = "The King laughs and says, 'Not gonna take huh? Well that's what I like about murderers like you, always sulking. Now... I need someone taken care of. And I think you're the guy for the job.'"
        CastleEvent_5()
    }
    
    @IBAction func CastleEvent3_c(){
        AdventureLog.text = "You turn and run as soon as the guard starts walking. You forgot that your legs are shakeled and fall to the floor! The guard hears you, and walks back to you. He grabs a spear off of a near by weapon rack and makes an adventurer kebab..."
        MainImage.image =  UIImage(named: Theme + "Hole.png")
        
        CurrentHP = 1
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    var NiceSquirrel: Bool = false
    
    func HomeEvent(){
        //MainImage.image = UIImage(named: "Questionmark_.png")
        AdventureLog.text = "You enter the next room and are blinded by a bright light. Once the light clears, you look around and see that you are back home! You're pet squirrel runs up your leg and onto your shoulder and nibbles a small nut."
        MainImage.image =  UIImage(named: "SmolSquirrel.png")
        sleep(1)
        topEvent("Pet Him", #selector(PetSquirrel))
        bottomEvent("Put Him Down On The Floor", #selector(SetSquirrelDown))
    }
    
    @IBAction func PetSquirrel(){
        AdventureLog.text = "He seems happy! He runs off into the back room..."
        NiceSquirrel = true
        topEvent("Continue", #selector(HomeEvent2))
        bottomEvent("Continue", #selector(HomeEvent2))
    }
    
    @IBAction func SetSquirrelDown(){
        AdventureLog.text = "He seems upset that you put him down and runs off..."
        NiceSquirrel = false
        topEvent("Continue", #selector(HomeEvent2))
        bottomEvent("Continue", #selector(HomeEvent2))
    }
    
    @IBAction func HomeEvent2(){
        AdventureLog.text = "From the other room you hear a familiar voice..." + "\n" + "'Honey is that you?'" + "\n" + "Your wife comes out of the back room, holding your new born child." + "'I thought you were on your way to see the King. If you want to get to the castle before sundown you should probably leave now!'"
        MainImage.image = UIImage(named: "Wife.png")
        topEvent("Leave For Castle", #selector(HomeEvent3))
        bottomEvent("Stay A Bit Longer", #selector(HomeEvent3_b))
    }
    
    @IBAction func HomeEvent3(){
        MainImage.image = nil
        AdventureLog.text = "You turn around to walk out the door. You look back at your family one last time before you leave, but they are no where to be found..."
        topEvent("...", #selector(HomeEvent4))
        bottomEvent("...", #selector(HomeEvent4))
    }
    
    @IBAction func HomeEvent3_b(){
        MainImage.image = nil
        AdventureLog.text = "As you walk up to your wife and child you feel your gut wrentch in pain. Then everything just goes black. All you can think about is how you may never see them again..."
        topEvent("...", #selector(HomeEvent4))
        bottomEvent("...", #selector(HomeEvent4))
    }
    
    @IBAction func HomeEvent4(){
        MainImage.image = nil
        AdventureLog.text = "The next thing you know, you are walking through the forest neighboring your house... It's pitch black out with only your lantern lighting your path."
        topEvent("...", #selector(HomeEvent5))
        bottomEvent("...", #selector(HomeEvent5))
    }
    
    @IBAction func HomeEvent5(){
        AdventureLog.text = "A ways down the trail you see a bright light... Then you start to smell smoke... You start running down the trail as fast as you can with nothing but fear fueling you..."
        topEvent("...", #selector(HomeEvent6))
        bottomEvent("...", #selector(HomeEvent6))
    }
    
    @IBAction func HomeEvent6(){
        AdventureLog.text = "You get out of the forest to a clearing, and all you can see is fire... Your house, your crops, you family... None of it.. Only burning..." + "\n" + "Off in the distance you notice a small group of bandits laughing and fighting over what looks to be a bag of gold."
        topEvent("Confront The Bandits", #selector(HomeEvent7_a))
        bottomEvent("Run Away", #selector(HomeEvent7_b))
    }
    
    @IBAction func HomeEvent7_a(){
        AdventureLog.text = "You charge in and ready for a fight, but as soon as you get close enough to the bandits to do anything, everything goes black... "
        
        Adjustpower(Power * 1/5)
        defaults.set(NiceSquirrel, forKey: "NiceSquirrel")
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func HomeEvent7_b(){
        defaults.set(true, forKey: "Home_Dream")
        AdventureLog.text = "Terrified you turn back into the forest and run...."
        
        defaults.set(NiceSquirrel, forKey: "NiceSquirrel")
        Adjustpower(Power * 1/5, Add: false)
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func ReturnToTower(){
        AdventureLog.text = "You awaken back in the Tower..."
        
        SetLabels()
        SaveStats()
        Next()
    }
    
    @IBAction func GenHomeEvent(){
        MainImage.image = UIImage(named: "Questionmark_.png")
        HomeEvent()
    }
    
    @IBAction func GenCastleEvent(){
        MainImage.image = UIImage(named: "Questionmark_.png")
        CastleEvent()
    }
    
    @IBAction func GenMarketEvent(){
        MainImage.image = UIImage(named: "Questionmark_.png")
        MarketEvent()
    }
    
    func MarketEvent(){
        MainImage.image = nil
        AdventureLog.text = "You enter the next room and are blinded by a bright light. Once the light clears, you look around and see that you are in the old market place outside of the castle..."
        topEvent("Look Around", #selector(MarketEvent2))
        bottomEvent("Look Around", #selector(MarketEvent2))
    }
    
    @IBAction func MarketEvent2(){
        MainImage.image = UIImage(named: Theme + "Merchant.png")
        AdventureLog.text = "While you're browsing the market, a merchant calls you over..."
        topEvent("Walk Over", #selector(MarketEvent3_a))
        bottomEvent("Ignore Him", #selector(MarketEvent3_b))
    }
    
    @IBAction func MarketEvent3_b(){
        AdventureLog.text = "As soon as you turn away from the merchant he starts screaming 'That person stole one of my toasters! He's a thief!!'"
        topEvent("Run For Your Life!", #selector(MarketEvent4_c))
        bottomEvent("Do The Job You Came Here For...", #selector(MarketEvent4_a))
    }
    
    @IBAction func MarketEvent4_c(){
        AdventureLog.text = "You start to run as the guards stationed at the1q, but as soon as you get past the castle gates, your vision goes out and everything goes black..."
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func MarketEvent3_a(){
        AdventureLog.text = "As soon as you walk over the merchant tries to sell you some of his goods. 'I've got quality weapons on sale today for 2000g today only! I've also got free toasters!'"
        topEvent("Kill The Merchant And Steal A Toaster", #selector(MarketEvent4_a))
        bottomEvent("Purchase The Weapon And Toaster", #selector(MarketEvent4_b))
    }
    
    @IBAction func MarketEvent4_a(){
        AdventureLog.text = "You reach over the counter and grab the merchant. You whisper in his ear 'The King sends his regards..' and with that you kill him... You start to run from the scene of the crime, but as soon as you get past the castle gates, your vision goes out and everything goes black..."
        
        defaults.set(true, forKey: "Market_Dream")
        Adjustpower(Power * 1/5)
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func MarketEvent4_b(){
        AdventureLog.text = "You purchase the weapon and go about searching around the market as before. Then out of nowhere your vision goes out and everything goes black..."
        
        if(Gold >= 2000){
            Gold -= 2000
            Power += 200
        }
        
        topEvent("...", #selector(ReturnToTower))
        bottomEvent("...", #selector(ReturnToTower))
    }
    
    @IBAction func DoCampRest(){
        AdventureLog.text = "You take a quick break and feel reseted!"
        CurrentHP += (CurrentHP / 20)
        if(CurrentHP > MaxHP)
        {CurrentHP = MaxHP}
        if(isBleeding){
            BleedingCounter += 3
            if(BleedingCounter == 10){
                isBleeding = false
                BleedingCounter = 0
            }
        }
        SetLabels()
        Next()
    }

    
    func Fall(){
        let Drop: Int = Int(arc4random_uniform(4)) + 1
        MainImage.image = UIImage(named: Theme + "Hole.png")
        if(!defaults.bool(forKey: "ReturnTrip")){
            AdventureLog.text = "The ground around you starts to collapse! You don't jump out of the way in time and fall " + String(Drop) + " floor(s)!"
            Floor -= Drop
            FloorTenths = 0
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 90){
                StartBleeding()
            }
            if(Gen > 50){
                CurrentHP -= MaxHP * (1/20)
            }
            SetLabels()
            SaveStats()
            Next()
        }else{
            AdventureLog.text = "The ground in front of you collapses!"
            topEvent("Jump Down", #selector(SafeFall))
            bottomEvent("Continue On This Floor", #selector(GenerateEventButton))
        }
    }
    
    @IBAction func SafeFall(){
        let Drop: Int = Int(arc4random_uniform(4)) + 1
        Floor -= Drop
        FloorTenths = 0
        AdventureLog.text = "You jump down " + String(Drop) + " floor(s)!"
        SetLabels()
        SaveStats()
        Next()
    }
    
    var isBleeding: Bool = false
    var BleedingCounter: Int = 0
    
    func StartBleeding(){
        if(isBleeding){
            AdventureLog.text = AdventureLog.text + "\n\n" + "Your wounds have reopened!"
            if(BleedingCounter >= 7){
                BleedingCounter = 7
            }else if(BleedingCounter >= 4 && BleedingCounter < 7){
                BleedingCounter = 4
            }else{
                BleedingCounter = 0
            }
        }else{
            isBleeding = true
            BleedingCounter = 0
            AdventureLog.text = AdventureLog.text + "\n\n" + "You are majorly injured and now bleeding!"
        }
    }
    
    func FindElevator(){
        if(!defaults.bool(forKey: "ReturnTrip")){
            AdventureLog.text = "An elevator in a dungeon? How odd..."
            MainImage.image = UIImage(named: Theme + "Elevator.png")
            topEvent("Ride Elevator", #selector(DoElevator))
            bottomEvent("Continue On This Floor", #selector(GenerateEventButton))
        }else{
            MainImage.image = UIImage(named: "QuestionMark_.png")
            let Raise: Int = Int(arc4random_uniform(5)) + 1
            AdventureLog.text = "You hear something above you, as you look up a giant hand grabs you and pulls you up " + String(Raise) + " floor(s)!"
            MainImage.image = UIImage(named: Theme + "Elevator.png")
            Floor += Raise
            FloorTenths = 0
            SetLabels()
            Next()
        }
    }
    
    @IBAction func DoElevator(_ sender: Any){
        let Raise: Int = Int(arc4random_uniform(5)) + 1
        FloorTenths = 0
        Floor += Raise
        AdventureLog.text = "You rose " + String(Raise) + " floor(s)!"
        SetLabels()
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Next()
    }
    
    func GenProduct() -> [String]{
        let Gen: Int = Int(arc4random_uniform(3))
        var Type: String = ""
        switch Gen {
        case 0:
            Type = "Potion"
        case 1:
            Type = "Weapon"
        case 2:
            Type = "Mystery Sack"
        default:
            Type = "Nothing"
        }
        var Total: Int = Int(arc4random_uniform(4)) + 1
        if(Type == "Mystery Sack"){
            Total = 1
        }
        let Cost: Double = Double(arc4random_uniform(UInt32(800 * Floor * DecensionAdjustment)) + 100)
        let Result: [String] = [Type, String(Total), DoubleString(Input: Cost)]
        return Result
    }
    
    var CurrentProduct: [String] = []
    
    func FindMerchant(){
        CurrentProduct = GenProduct()
        MainImage.image = UIImage(named: Theme + "Merchant.png")
        if(CurrentProduct[0] == "Mystery Sack"){
            AdventureLog.text = "You come across a merchant selling a very mysterious sack! His offer is " + CurrentProduct[2] + "G."
        }else{
            AdventureLog.text = "You come across a merchant selling some goods, he's offering x" + CurrentProduct[1] + " " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "G."}
        topEvent("Buy Product", #selector(BuyProduct))
        bottomEvent("Continue", #selector(GenerateEventButton))
    }
    
    @IBAction func BuyProduct(){
        let Cost: Double = Double(CurrentProduct[2]) ?? 0
        if(Gold < Cost){
            AdventureLog.text = "Not enough Gold for this purchase."
            Next()
        }
        else{
            Gold -= Cost
            switch CurrentProduct[0] {
            case "Potion":
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
                SetLabels()
                AdventureLog.text = AdventureLog.text + "\n" + "Come again!"
                Next()
            case "Weapon":
                GiveWeapon(SkipText: true, UseContainer: false, Total: Int(CurrentProduct[1]) ?? 1)
                SetLabels()
                AdventureLog.text = AdventureLog.text + "\n" + "Come again!"
                Next()
            case "Mystery Sack":
                GiveMysterySack()
            default:
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
                SetLabels()
                AdventureLog.text = AdventureLog.text + "\n" + "Come again!"
                Next()
            }
        }
    }
    
    func GiveWeapon(SkipText: Bool = false, UseContainer: Bool = false, Total: Int = 1, UseNext: Bool = false, isCursed: Bool = false){
        for _ in 0..<(Total){
        let PowerLevel: Double = Double(arc4random_uniform(UInt32(50 * Floor * DecensionAdjustment))) + 1
        if(!SkipText && !UseContainer){
            AdventureLog.text = AdventureLog.text + "\n" + "You obtained a " + GenWeaponType() + " with a power of " + DoubleString(Input: PowerLevel) + "!"
        }
        if(!SkipText && UseContainer){
            MainImage.image = UIImage(named: "Weapons.png")
            AdventureLog.text = "You found a " + GenContainer() + " containing a " + GenWeaponType() + " with a power of " + DoubleString(Input: PowerLevel) + "!"
        }
        Adjustpower(PowerLevel)
            SetLabels()
        }
        if(isCursed){
            AdventureLog.text = AdventureLog.text + "\n" + "The weapon you obtained was cursed!"
            Curse(useString: true, isEvent: false, isBagCurse: false)
        }
        if(UseNext){
            Next()
        }
    }
    
    func GenContainer() -> String{
        let Gen: Int = Int(arc4random_uniform(4))
        switch Gen {
        case 0:
            return "barrel"
        case 1:
            return "closet"
        case 2:
            return "sack"
        case 3:
            return "box"
        default:
            return "box"
        }
    }
    
    func GenWeaponType() -> String{
        switch Class {
        case 0:
            return "sword"
        case 1:
            return "bow"
        case 2:
            return "staff"
        case 3:
            return "scythe"
        case 4:
            return "scepter"
        case 5:
            return "loaf"
        default:
            return "dagger"
        }
    }
    
    func GivePotion(SkipText: Bool = false, UseContainer: Bool = false, Total: Double = 1){
            if(!SkipText && !UseContainer){
                AdventureLog.text = "You obtained " + DoubleString(Input: Total) + " Potion(s)!"
            }
            if(!SkipText && UseContainer){
                AdventureLog.text = "You found a " + GenContainer() + " containing " + DoubleString(Input: Total) + " Potion(s)!"
            }
            Potions += Total
    }
    
    func GiveMysterySack(){
        if(arc4random_uniform(50) < MimicChance){
            //DoMimic
            AdventureLog.text = "The sack contained a mimic!"
            Battle(isMimic: true, MimicName: "Sack Mimic")
        }else{
            //Do Mystery Sack
            let Total: UInt32 = LoadItemChances()
            let Gen: Int = Int(arc4random_uniform(Total))
            if(Gen >= 0 && Gen <= WeaponChance){
                AdventureLog.text = "The sack contained a weapon!"
                GenWeapon(SkipText: false, UseContainer: false, Total: 1, CanBeCursed: true)
                Next()
            }
            else if(Gen > WeaponChance && Gen <= GoldChance){
                AdventureLog.text = "The sack contained some gold!"
                GiveGold(SkipText: false, UseContainer: false)
                Next()
            }
            else{
                AdventureLog.text = "The sack contained some potions!"
                GivePotion(SkipText: false, UseContainer: false, Total: Double(arc4random_uniform(UInt32(Floor * 3)) + 1))
                Next()
            }
        }
    }
    
    func GiveGold(SkipText: Bool = false, UseContainer: Bool = true){
        MainImage.image = UIImage(named: Theme + "Gold.png")
        var Gen: Double = Double(arc4random_uniform(UInt32(100 * Floor * DecensionAdjustment))) + 10
        if(Class == 4){
            Gen = Gen * 3
        }
        Gold += Gen
        if(!SkipText){
            if(UseContainer){
                AdventureLog.text = "You found a " + GenContainer() + " containing " + DoubleString(Input: Gen) + "G!"
            }else{
                AdventureLog.text = "You found " + DoubleString(Input: Gen) + "G!"
            }
        }
    }
    
    func GenWeapon(SkipText: Bool = false, UseContainer: Bool = false, Total: Int = 1, UseNext: Bool = false, CanBeCursed: Bool = true){
        MainImage.image = UIImage(named: "Weapons.png")
        if(CanBeCursed && arc4random_uniform(50) < CursedWeaponChance){
            GiveWeapon(SkipText: SkipText, UseContainer: UseContainer, Total: Total, UseNext: UseNext, isCursed: true)
        }
        else{
            GiveWeapon(SkipText: SkipText, UseContainer: UseContainer, Total: Total, UseNext: UseNext)
        }
        
    }
    
    func FindItem(UseContainer: Bool = true){
        let Total: UInt32 = LoadItemChances()
        let Gen: Int = Int(arc4random_uniform(Total) + 15)
        if(Gen >= 0 && Gen <= WeaponChance){
            GenWeapon(SkipText: false, UseContainer: true, Total: 1, CanBeCursed: true)
            Next()
        }
        else if(Gen > WeaponChance && Gen <= GoldChance){
            GiveGold()
            Next()
        }
        else if(Gen > GoldChance && Gen <= PotionChance){
            MainImage.image = UIImage(named: Theme + "Potion.png")
            GivePotion(SkipText: false, UseContainer: true, Total: Double(arc4random_uniform(19)) + 1)
            Next()
        }else{
            AdventureLog.text = "You found a treasure chest!"
            MainImage.image = UIImage(named: Theme + "TreasureChest.png")
            topEvent("Open", #selector(FindTreasure))
            bottomEvent("Continue", #selector(GenerateEventButton))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(defaults.bool(forKey: "hasCharacter")){
        if(!defaults.bool(forKey: "DisplaySetup")){
            DisplaySetup()
        }
        ReadStats()
        if(defaults.bool(forKey: "TempPotionCheck")){
            if(Potion_Label.isUserInteractionEnabled){
                Potions -= 8
                CurrentHP = MaxHP
                SaveStats()
                defaults.set(false, forKey: "TempPotionCheck")
            
                if(Class == 2){
                    Adjustpower(Power * 8/100)
                }
            }else{
                DisplayAlert(title: "Unable To Heal", message: "A magical force is peventing you from recovering!", button: "OK")
            }
        }
        if(defaults.bool(forKey: "ReturnToTitle")){
            SaveStats()
            defaults.set(false, forKey: "ReturnToTitle")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "TitleScreenSegue", sender: nil)
            })
        }
        if(defaults.bool(forKey: "RestartCharacter")){
            defaults.set(false, forKey: "RestartCharacter")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "CharacterCreationSegue", sender: nil)
            })
        }
        
        if(defaults.bool(forKey: "DonationAddition")){
            Adjustpower(5000)
            AdjustGold(5000)
            AdjustHP(5000)
            AdjustPotions(50)
            SaveStats()
            defaults.set(false, forKey: "DonationAddition")
        }
        if(defaults.string(forKey: "MonsterTheme") == nil){
            defaults.set("", forKey: "MonsterTheme")
            Theme = ""
        }
        
        if(defaults.string(forKey: "isBleeding") == nil){
            isBleeding = false
        }

        ReadStats()
        FixStats()
        SetLabels()
        
            //Display changes if first load of the app
            if(!defaults.bool(forKey: "DisplaySetup")){
                AdventureLog.text = "Welcome Adventurer!" + "\n" + "Press a button to begin!"
                Next()
                defaults.set(true, forKey: "DisplaySetup")
            }
            
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    
    func DisplaySetup(){
        let LabelImage: UIImage = resizeImage(image: UIImage(named: "Gray_typeE_none.png")!, Label: Potion_Label)
        Potion_Label.backgroundColor = UIColor(patternImage: LabelImage)
        
        let LabelImage2: UIImage = resizeImage(image: UIImage(named: "Gray_typeC_none.png")!, Label: Power_Label)
        Power_Label.backgroundColor = UIColor(patternImage: LabelImage2)
        
        let LabelImage3: UIImage = resizeImage(image: UIImage(named: "Gray_typeC_none.png")!, Label: Gold_Label)
        Gold_Label.backgroundColor = UIColor(patternImage: LabelImage3)
        
        HP_Label.layer.borderWidth = 2
        HP_Label.layer.borderColor = UIColor.black.cgColor
        
        
        SubViewUnder(Image: "Gray_typeC_none",
                     x: CGFloat(Name_Label.frame.origin.x),
                     y: CGFloat(Name_Label.frame.origin.y),
                     width: Name_Label.bounds.width,
                     height: Name_Label.bounds.size.height,
                     Tag: 101)
        
        SubViewUnder(Image: "Common_select.png",
                     x: CGFloat(AdventureLog.frame.origin.x),
                     y: CGFloat(AdventureLog.frame.origin.y),
                     width: AdventureLog.bounds.width,
                     height: AdventureLog.bounds.size.height,
                     Tag: 102)
        
        SubViewUnder(Image: "Common_select.png",
                     x: CGFloat(MainImage.frame.origin.x) - 4,
                     y: CGFloat(MainImage.frame.origin.y) - 4,
                     width: MainImage.bounds.width + 8,
                     height: MainImage.bounds.size.height + 8,
                     Tag: 103)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DisplayHP))
        HP_Label.isUserInteractionEnabled = true
        HP_Label.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DisplayPower))
        Power_Label.isUserInteractionEnabled = true
        Power_Label.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(DisplayGold))
        Gold_Label.isUserInteractionEnabled = true
        Gold_Label.addGestureRecognizer(tap3)
        
        let isRunningTestFlightBeta = Bundle.main.appStoreReceiptURL?.lastPathComponent=="sandboxReceipt"
        if(isRunningTestFlightBeta){
            let tap4 = UITapGestureRecognizer(target: self, action: #selector(Debug))
            Name_Label.isUserInteractionEnabled = true
            Name_Label.addGestureRecognizer(tap4)
        }
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(UsePotion))
        Potion_Label.isUserInteractionEnabled = true
        Potion_Label.addGestureRecognizer(tap5)
    }
    
    @IBAction func FindTreasure(){
        
        let a: Int = Int(arc4random_uniform(110))
        if (a >= 0 && a <= 25)
        {
            AdventureLog.text = "The treasure chest contained a " + GenWeaponType()
            GenWeapon(SkipText: false, UseContainer: false, Total: 1, UseNext: false, CanBeCursed: true)
            Next()
        }else if (a > 25 && a <= 40){
            AdventureLog.text = "The chest contained Gold!"
            GiveGold(SkipText: false, UseContainer: false)
            Next()
        }else if (a > 50 && a <= 80){
            AdventureLog.text = "The chest contained Potions!"
            GivePotion(SkipText: false, UseContainer: false, Total: Double(arc4random_uniform(UInt32(Floor + 1))))
            Next()
        }else if (a > 90 && a <= 100)
        {
            AdventureLog.text = "The treasure chest was a mimic!";
            Battle(isMimic: true, MimicName: "Treasure Mimic")
        }else if(a >= 101 && !hasESP){
                AdventureLog.text = "The treasure chest engulfs you in light! You now feel smarter!"
                hasESP = true
                SaveStats()
                Next()
        }else{
            AdventureLog.text = "The treasure chest contained nothing. How sad."
            Next()
        }
    }
    
    func Battle(isMimic: Bool = false, MimicName: String = "Mimic"){
        if (!isMimic && !SquirrelMark)
        {
            let Total: UInt32 = UInt32((EnemyChance * 2) + BossChance + EnhancedChance + 2)
            let Gen: Int = Int(arc4random_uniform(Total))
            if(Gen >= 0 && Gen <= EnemyChance * 2){
                NormalEnemy()
            }
            else if(Gen > EnemyChance * 2 && Gen <= ((EnemyChance * 2) + EnhancedChance)){
                EnhancedEnemy()
            }else if(Gen > ((EnemyChance * 2) + EnhancedChance) && Floor > 4){
                Boss()
            }
            else{
                NormalEnemy()
            }
        }
        else {
            if(isMimic){
                MimicBattle(MimicName: MimicName)}
            else if(SquirrelMark){
                SquirrelBattle()
            }
        }
    }
    
    var CurrentMonster: [String] = []
    
    func GetMonster(Type: Int = 1, Overload: String = "NA") -> [String]{
        var Gen: Int = 0
        if(Overload == "NA"){
            Gen = Int(arc4random_uniform(UInt32(MonsterArray.count)))
        }else{
            Gen = MonsterArray.firstIndex(of: Overload)!
        }
        let TempArray: [String] = MonsterArray[Gen].components(separatedBy: ",")
        var Adjustment: Int = (Floor / 25)
        if(Adjustment < 1){
            Adjustment = 1
        }
        var EasyMode: Double = 1
        if(isEasyMode){
            EasyMode = 2
        }
        let TempPower: String = String((Double(TempArray[1])! * Double(Type * AfterDeath * Floor * 2 * Adjustment * DecensionAdjustment)) / EasyMode)
        let FinalResult: [String] = [TempArray[0], TempPower , TempArray[2]]
        return FinalResult
            
    }
    
    var Theme: String = ""
    
    func NormalEnemy(Overload: String = "NA"){
        CurrentMonster = GetMonster(Type: 1, Overload: Overload)
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        AdventureLog.text = "A " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel(EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway))
    }
    
    func DisplayAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func AppendLog(_ text: String){
        AdventureLog.text = AdventureLog.text + "\n" + text
    }
    
    @IBAction func FightEnemy(){
        let Damage: Double = HandleBattle()
        
        CurrentHP -= Damage
        if(CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            Dead()
            if(CurrentMonster[0].lowercased().contains("slime")){
                AdventureLog.text = AdventureLog.text + "\nThat big bad slime was too much for a weak adventurer such as yourself...."
            }else{
                AppendLog("The \(CurrentMonster[0]) was too powerful! In attempting to fight it you lost your life...")
            }
        }
        else{
            let LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 200)))
            AdventureLog.text = "You slayed the \(CurrentMonster[0])! You looted the body and gained " + CutLabel(LootedGold) + "G."
            Gold += LootedGold
            AdjustHP(MaxHP * (5/100))
            SetLabels()
            if(isSquirrelFight){
                AppendLog("After slaying the squirrel you can feel the burn on your face fade away. It seems you have bested the squirrels...\nFor now...")
                SquirrelMark = false
                isSquirrelFight = false
                defaults.set(false, forKey: "SquirrelMark")
            }
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 85){
                StartBleeding()
            }
            Next()
        }
    }
    
    @IBAction func RunAway_FullLoss(){
        isSquirrelFight = false
        AdventureLog.text = "You ran away losing all of your Gold and Potions!"
        Gold = 0
        Potions = 0
        FloorTenths = 0
        SetLabels()
        Next()
    }
    
    @IBAction func RunAway(){
        isSquirrelFight = false
        AdventureLog.text = "You ran away losing half of your Gold and Potions!"
        Gold -= Gold / 2
        Potions -= Potions / 2
        SetLabels()
        Next()
    }
    
    func GenClassImage(Class: String = "0") -> String{
        switch Class {
        case "0":
            return "Sword.png"
        case "1":
            return "Arrow.png"
        case "2":
            return "Staff.png"
        case "3":
            return "Scythe.png"
        case "4":
            return "Crown.png"
        case "5":
            return "Toaster_Class.png"
        default:
            return "Dagger.png"
        }
    }
    
    func GenClassImage(Class: String = "0") -> UIImage{
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
    
    func EnhancedEnemy(){
        CurrentMonster = GetMonster(Type: 2)
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        AdventureLog.text = "A giant " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Star.png")
        
        if(hasESP && BattlePredict){
           AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway))
    }
    
    func Boss(){
        CurrentMonster = GetMonster(Type: 4)
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 420
        AdventureLog.text = "A boss ranked " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Crown.png")
        
        if(hasESP && BattlePredict){
            AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway_FullLoss))
    }
    
    var isSquirrelFight: Bool = false
    
    func SquirrelBattle(){
        var TempAdjust: Int = 1
        if(defaults.bool(forKey: "SquirrelNice")){
            TempAdjust = 10
        }
        CurrentMonster = ["Squirrel", String((500 * Floor * AfterDeath * 4 * DecensionAdjustment) / TempAdjust), "3"]
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        isSquirrelFight = true
        AdventureLog.text = "The Squirrel has found you!" + "\n" + "Power: " + CutLabel(EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway_FullLoss))
    }
    
    func MimicBattle(MimicName: String = "Mimic"){
        CurrentMonster = [MimicName, String(150 * Floor * AfterDeath), "2"]
        AdventureLog.text = "It was a mimic!" + "\n" + "Power: " + CutLabel(Double(CurrentMonster[1]) ?? 420)
        
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway))
    }
    
    func HandleBattle() -> Double{
        let EP: Double = Double(CurrentMonster[1]) ?? 0
        let PP: Double = Power
        var D: Double = 0
        let EC: Int = Int(CurrentMonster[2]) ?? 3
        let PC: Int = Class
        var CA: Double = 2
        
        if (PC == 0 && EC == 1 || PC == 1 && EC == 2 || PC == 2 && EC == 0){
            CA = 3
        }else if (PC == 1 && EC == 0 || PC == 2 && EC == 1 || PC == 0 && EC == 2){
            CA = 1.5
        }
        
        D = (EP / CA) * (EP / (EP + PP))
        
        if(CurrentHP < MaxHP / 2){
            D += D / 2
        }
        
        if(EP > PP * 5){
            D = MaxHP
        }
        
        if(PP > EP * 5){
            D = 0
        }
        
        NSLog("Player Power: " + String(PP))
        NSLog("Enemy Power: " + String(EP))
        NSLog("Adjustment: " + String(CA))
        NSLog("Damage: " + String(D))
        
        return D
    }
    
    func HandleBattle_OldFormula() -> Double{
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        //0-Warrior 1-Ranger 2-Mage 3-Haunted 4-King
        let EnemyClass: Int = Int(CurrentMonster[2]) ?? 0
        var PlayerPower: Double = Power
        var ClassAdjust: Double = 0
        var BadAdjust: Double = 0
        var Damage: Double = 0
        
        NSLog("Enemy: " + CurrentMonster[0])
        NSLog("Power: " + CurrentMonster[1])
        NSLog("EClass: " + CurrentMonster[2])
        
        //If HP is under half power reduced by a quarter
        if (CurrentHP == MaxHP / 2){
            PlayerPower -= PlayerPower * 1/4    }
        NSLog("HP Adjust Player Power: " + String(PlayerPower))
        //Warrior over Ranger, Ranger over Mage, Mage over Ranger.
        //If class adavantage exists, winning side gets additional quarter power.
        if (Class == 0 && EnemyClass == 1 || Class == 1 && EnemyClass == 2 || Class == 2 && EnemyClass == 0){
            ClassAdjust = PlayerPower / 10  }
        if (Class == 1 && EnemyClass == 0 || Class == 2 && EnemyClass == 1 || Class == 0 && EnemyClass == 2){
            BadAdjust = PlayerPower / 10 }
        NSLog("Class Adjust: " + String(ClassAdjust))
        NSLog("Bad Adjust: " + String(BadAdjust))


        PlayerPower -= BadAdjust;
        PlayerPower += ClassAdjust;
        
        var Adjustment: Double = 1;
        if (PlayerPower > EnemyPower * 2){
            Adjustment = 5
        }else{
            Adjustment = 2  }
        NSLog("Adjustment: " + String(Adjustment))
        if (PlayerPower >= EnemyPower){
            Damage = ((EnemyPower / 5) + (PlayerPower - EnemyPower)) / Adjustment
        }else{
            Damage = ((EnemyPower / 5) + (EnemyPower - PlayerPower))}
        NSLog("Damage: " + String(Damage))
        //If Enemy power is greater than the players power add 25%.
        if (EnemyPower > PlayerPower){
            Damage += Damage / 4}
        if (EnemyPower > PlayerPower * 5){
            Damage = MaxHP}
        NSLog("Damage: " + String(Damage))
        //Needs to be at the end to make sure no damage is taken if you hella over power the enemy
        if (PlayerPower >= (EnemyPower * 3)){
            Damage = 0}
        
        NSLog("Player Power: " + String(PlayerPower))
        NSLog("Enemy Power: " + String(EnemyPower))
        NSLog("Damage: " + String(Damage))
        
        return Damage.rounded(toPlaces: 0)
    }
    
    
    
    //Curses will simply be an array now not an ini file, curses will still be split as follows:
    //Effected Stat, Amount
    //Buffs and debuffs are now merged and will simply use enegative numbers for debuffs
    func Curse(useString: Bool = false, isEvent: Bool = false, isBagCurse: Bool = false, ConfusionCurse: Bool = false){
        let CurseNum: Int = Int(arc4random_uniform(UInt32(Curses.count)))
        let GenCurse: String = Curses[CurseNum]
        let FullCurse: [String] = GenCurse.components(separatedBy: ",")
        let CurseModifier: Int = PullInt(Buff: FullCurse[0])
        
        if(!ConfusionCurse){
            defaults.set(String(Int(FullCurse[1])! + CurseModifier), forKey: FullCurse[0])
            let _ = LoadChances()
        }
        
        if(isEvent){
            MainImage.image = UIImage(named: Theme + "Curse.png")
            let Gen: UInt32 = arc4random_uniform(5)
            switch Gen{
                case 0:
                    AdventureLog.text = "You stepped on a ancient Indian bug burial ground. The lost souls of the bugs haunt you!" + "\n"
                case 1:
                    AdventureLog.text = "A wizard jumps out and casts a curse on you!" + "\n"
                case 2:
                    AdventureLog.text = "You look at what seems to be ancient hyroglyphics on the wall. Something feels off about them but since you can't read it, you're not sure..." + "\n"
                case 3:
                    AdventureLog.text = "You feel a bit off. Maybe that last potion you drank expired?" + "\n"
                case 4:
                    AdventureLog.text = "A ghost zips through the wall in front of you and flys right through you. It seemed to be an angered spirit and it appears to have cursed you..." + "\n"
                default:
                    AdventureLog.text = "Generic Curse"
                }
            Next()
        }
        
        if (isBagCurse){
            AdventureLog.text = "You opened the bag and then there's a loud bang and smoke erupts out. Seems like it was booby trapped..." + "\n"}

        
        if(useString){
            switch FullCurse[0]{
            case "FindItemChance":
                AdventureLog.text = AdventureLog.text + "You are now less likely to find items..."
            case "CursedWeaponChance":
                AdventureLog.text = AdventureLog.text + "You are now more likely to find cursed weapons..."
            case "GoldChance":
                AdventureLog.text = AdventureLog.text + "You are now less likely to find gold..."
            case "PotionChance":
                AdventureLog.text = AdventureLog.text + "You are now less likely to find potions..."
            case "FallChance":
                AdventureLog.text = AdventureLog.text + "You are now more likely to fall through floors..."
            case "EnemyChance":
                AdventureLog.text = AdventureLog.text + "You are now more likely to find enemies wandering around the dungeon..."
            case "WeaponChance":
                AdventureLog.text = AdventureLog.text + "Oddly enough you feel like you may have better luck finding weapons..."
            default:
                AdventureLog.text = AdventureLog.text + "Generic curse..."
            }
            if(ConfusionCurse){
                AdventureLog.text = AdventureLog.text + "You are confused and may have troubles adventuring!"
            }
        }
    }
    
    let Curses: [String] = ["WeaponChance,1", "FallChance,1", "FindItemChance,-1", "CursedWeaponChance,1", "GoldChance,-1","EnemyChance,1","PotionChance,-1"]
    
    @IBAction func UsePotion(_ sender: Any) {
        if(Potions >= 1 && CurrentHP < MaxHP){
            Potions -= 1
            CurrentHP += (MaxHP / 10).rounded(toPlaces: 0)
            if(CurrentHP > MaxHP){
                CurrentHP = MaxHP}
            
            if(Class == 2){
                Adjustpower(Power * (1 / 100))
            }
        }
        SetLabels()
        SaveStats()
    }
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var AdventureLog: UITextView!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var Top_Button: UIButton!
    @IBOutlet weak var Bottom_Button: UIButton!
    @IBOutlet weak var UsePotion_Button: UIButton!
    @IBOutlet weak var Name_Label: UILabel!
    @IBOutlet weak var HP_Label: UILabel!
    @IBOutlet weak var Power_Label: UILabel!
    @IBOutlet weak var Gold_Label: UILabel!
    @IBOutlet weak var Potion_Label: UILabel!
    @IBOutlet weak var TypeImage: UIImageView!
    @IBOutlet weak var ClassImage: UIImageView!
    
    
    func GenMiscEvent(){
        let Gen: Int = Int(arc4random_uniform(121))
        if(Gen >= 0 && Gen < 25){
            FindBadMerchant()
        }else if(Gen >= 25 && Gen < 50){
            FindTrap()
        }else if(Gen >= 50 && Gen < 65){
            SmallDreamEvent()
        }else if(Gen >= 65 && Gen < 70){
            FindSquirrel()
        }else if(Gen >= 70 && Gen < 75 && Floor > 15){
            FindHell()
        }else if(Gen >= 75 && Gen < 80){
            FindHotSpring()
        }else if(Gen >= 80 && Gen < 90){
            FindOldHag()
        }else if(Gen >= 90 && Gen < 105 && !isConfused){
            ConfusionCurse()
        }else if(Gen >= 105 && Gen < 110){
            EncounterGilgamesh()
        }else{
            FindDeadBody()
        }
    }
    
    func SmallDreamEvent(){
        let Gen: Int = Int(arc4random_uniform(100))
        if(Gen >= 0 && Gen < 25 && defaults.bool(forKey: "Dream_1")){
            //Fighting Bandits
            var Adjustment: Int = (Floor / 25)
            if(Adjustment < 1){
                Adjustment = 1
            }
            CurrentMonster = ["Bandit Hoard", String(100 * Double(Floor * 4 * AfterDeath * Adjustment * DecensionAdjustment)), "1"]
            MainImage.image = UIImage(named: Theme + "Bandit.png")
            AdventureLog.text = "You enter another room and inside waiting for you is a big group of bandits.." + "\n" + "10 Bandits with " + CurrentMonster[1] + " Power each." + "\n\n" + "When you start this fight you can't stop part way in!"
            topEvent("Battle!", #selector(FightBandits))
            bottomEvent("Run Away", #selector(RunAway_FullLoss))
        }else if(Gen >= 25 && Gen < 50 && defaults.bool(forKey: "Dream_2")){
            //Denying The King
            AdventureLog.text = "As you enter the next room, you find yourself in the throne room of the old King."
            topEvent("Approach King", #selector(ApproachKing))
            bottomEvent("Leave", #selector(GenerateEventButton))
        }else{
            MainImage.image = nil
            AdventureLog.text = "There's nothing here, but you feel weirdly depressed..."
            Next()
        }
    }
    
    @IBAction func ApproachKing(){
    AdventureLog.text = "The King belows 'You've had time to consider my offer. What say you?'. You politely decline the King's offer of freeing you in exchange for an assassination. 'You dare deny me?!! You will live to regret this! You will rot away in hell!'. The King's guards escort you out, but not to the dungeons this time..."
        
        topEvent("...", #selector(ApproachKing2))
        bottomEvent("...", #selector(ApproachKing2))
    }
    
    @IBAction func ApproachKing2(){
        AdventureLog.text = "As soon as you leave the throne room the guards put a sack over your head and knock you out... When you awake, you are in front of what looks like a giant tower. The giards open the giant double doors and push you in..." + "\n" + "As soon as you enter the Tower, you are back in the last room before you met the King.."
        defaults.set(true, forKey: "Dream_2")
        Next()
    }
    
    @IBAction func FightBandits(){
        let TempHP: Double = CurrentHP
        var Count: Int = 0
        for _ in 0..<11{
            let Damage: Double = HandleBattle()
            CurrentHP -= Damage
            if(CurrentHP < 1){
                CurrentHP = 0
                SetLabels()
                Dead()
                AppendLog("The Bandit hoard overwhelmed you with their mighty numbers! As your life fades away, your only thoughts are of your family...")
            }else{
                Count += 1
            }
        }
        if(Count >= 10){
            AdventureLog.text = "After a long fight all of the bandits have fallen. You prepare to start looting the bodies when out of no where they all just disapear..."
            CurrentHP = TempHP
            defaults.set(true, forKey: "Dream_1")
            Next()
        }
    }
    
    func PredictBattle() -> String{
        let Damage: Double = HandleBattle()
        if(Damage > CurrentHP){
            return "Prediction: Guaranteed Loss"
        }else if(Damage < CurrentHP && Damage > (CurrentHP / 2)){
            return "Prediction: Win, but at great risk."
        }else{
            return "Prediction: Win, minimal risk."
        }
    }
    
    func EncounterGilgamesh(){
        var Adjustment: Int = (Floor / 25)
        if(Adjustment < 1){
            Adjustment = 1
        }
        CurrentMonster = ["Gilgamesh", String(1000 * Double(Floor * 4 * AfterDeath * Adjustment * DecensionAdjustment)), "0"]
        let EnemyPower: Double = Double(CurrentMonster[1]) ?? 420
 
        AdventureLog.text = "The Great Gilgamesh appears before you, and challenges you to a duel." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Crown.png")
        
        if(hasESP && BattlePredict){
            AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        
        topEvent("Battle!", #selector(FightGilgamesh))
        bottomEvent("Decline The Duel", #selector(RunAway_NoLoss))
    }
    
    @IBAction func FightGilgamesh(){
        let Damage: Double = HandleBattle()
        
        CurrentHP -= Damage
        if(CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            Dead()
            AppendLog("Gilgamesh raises his great halbred for one last strike! As he brings it down upon you you can't help but think about all the sins you've commited..")
        }
        else{
            let LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 4000))) + 4000
            AdventureLog.text = "You defeated Gilgamesh! He rewards you with " + DoubleString(Input: LootedGold) + "G and a weapon!"
            GiveWeapon(SkipText: true, UseContainer: false, Total: 1, UseNext: false, isCursed: false)
            Gold += LootedGold
            AdjustHP(MaxHP * (15/100).rounded(toPlaces: 0))
            SetLabels()
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 70){
                StartBleeding()
            }
            Next()
        }
    }
    
    @IBAction func RunAway_NoLoss(){
        AdventureLog.text = "Gilgamesh allows you to escape..."
        SetLabels()
        Next()
    }
    
    var isConfused: Bool = false
    var ConfusionCounter: Int = 0
    
    var TopButtonX: CGFloat = 0
    var TopButtonY: CGFloat = 0
    
    var BottomButtonX: CGFloat = 0
    var BottomButtonY: CGFloat = 0
    
    func ConfusionCurse(){
        isConfused = true
        ConfusionCounter = 10
        Curse(useString: false, isEvent: true, isBagCurse: false, ConfusionCurse: true)
        Next()
    }
    
    func FindOldHag(){
        MainImage.image = UIImage(named: Theme + "Hag.png")
        AdventureLog.text = "An old hag walks up to you and demands all of your Gold."
        topEvent("Fight Her", #selector(FightHag))
        if(Gold > 0){
            bottomEvent("Give Her Your Gold", #selector(GiveAllGold))
        }else{
            bottomEvent("Fight Her", #selector(FightHag))
        }
    }
    
    let HagChanges: [String] = ["Ice Sorceress,200,2", "Fire Sorceress,250,2", "Succubus,220,2"]
    
    @IBAction func FightHag(_ Attacked: Bool = false){
        var Adjustment: Int = (Floor / 25)
        if(Adjustment < 1){
            Adjustment = 1
        }
        
        let Gen: Int = Int(arc4random_uniform(3))
        let TempArray: [String] = HagChanges[Gen].components(separatedBy: ",")
        
        CurrentMonster = TempArray
        var EnemyPower: Double = (Double(CurrentMonster[1]) ?? 0) * Double(Floor * Adjustment * 2 * DecensionAdjustment)
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        if(Attacked){
            AdventureLog.text = "As she was walking away she turns back and charges you! As she's charging she transforms into an " + CurrentMonster[0] + "!" + "\n" + "Power: " + CutLabel(EnemyPower)
        }else{
            AdventureLog.text = "The hag transforms into an " + CurrentMonster[0] + "!" + "\n" + "Power: " + DoubleString(Input: EnemyPower)
        }
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        CurrentMonster = [TempArray[0], String(EnemyPower), TempArray[2]] 
        
        if(hasESP && BattlePredict){
           AdventureLog.text = AdventureLog.text + "\n" + PredictBattle()
        }
        topEvent("Battle!", #selector(FightEnemy))
        bottomEvent("Run Away", #selector(RunAway))
    }
    
    @IBAction func GiveAllGold(){
        Gold = 0
        SaveStats()
        SetLabels()
        AdventureLog.text = "She crackles 'You chose wisely' and walks away."
        Next()
    }
    
    func FindDeadBody(){
        AdventureLog.text = "Wow a dead body how exciting.."
        topEvent("Loot Body", #selector(LootBody))
        bottomEvent("Continue", #selector(GenerateEventButton))
    }
    
    func FindSquirrel(){
        MainImage.image = UIImage(named: "SmolSquirrel.png")
        AdventureLog.text = "As you're walking down a hall a squirrel walks up to you and looks up at you with hope in his eyes..."
        if(Potions > 0){
            topEvent("Give It All Of Your Potions", #selector(DoSquirrelGood))
        }else{
            topEvent("Kick It And Walk Away", #selector(DoSquirrelBad))
        }
        bottomEvent("Kick It And Walk Away", #selector(DoSquirrelBad))
    }
    
    @IBAction func DoSquirrelGood(){
        SquirrelMark = false
        defaults.set(false, forKey: "SquirrelMark")
        AdventureLog.text = "You decide to help the little guy out and hand him all of your potions. He takes them and runs off into the dungeon."
        Potions = 0
        SetLabels()
        Next()
    }
    
    @IBAction func DoSquirrelBad(){
        AdventureLog.text = "You kick the squirrel out of your way and continue on. As you're walking down the hall you hear something behind you. You look back and see what may have once been a squirrel. You try to run, but he quickly catches you. Everything goes black."
        defaults.set(true, forKey: "SquirrelMark")
        SquirrelMark = true
        SaveStats()
        topEvent("...", #selector(SquirrelContinue))
        bottomEvent("...", #selector(SquirrelContinue))
    }
    
    @IBAction func SquirrelContinue(){
    AdventureLog.text = "You wake up sometime later. The nightmare that just unfolded seems to have been just that, a nightmare, if not for a burning mark on your face. You hope that it means nothing..."
        Next()
    }
    
    @IBAction func LootBody(){
        let Gen: Int = Int(arc4random_uniform(70))
        if(Gen >= 0 && Gen < 25){
            AdventureLog.text = "You check the body and find some gold! How nice!"
            GiveGold(SkipText: false, UseContainer: false)
        }else if(Gen >= 25 && Gen < 50){
            AdventureLog.text = "You check the body and find a weapon!"
            GiveWeapon(SkipText: false, UseContainer: false, Total: 1, UseNext: false, isCursed: false)
        }else if(Gen >= 50 && Gen < 60){
            AdventureLog.text = "You check the body and as you're searching it reanimates and grabs your arm and then falls back. You are unharmed but feel odd..."
            Curse(useString: true, isEvent: false, isBagCurse: false)
        }else{
           AdventureLog.text = "You check the body but find nothing of any value..."
        }
        Next()
    }

    var inHell: Bool = false
    func FindHell(){
        AdventureLog.text = "You feel a cold chill in the air..."
        topEvent("Continue", #selector(EnterHell))
        bottomEvent("Turn Back", #selector(GenerateEventButton))
    }
    
    func FindBadMerchant(){
        CurrentProduct = GenProduct()
        MainImage.image = UIImage(named: Theme + "BadMerchant.png")
        if(CurrentProduct[0] == "Mystery Sack"){
            AdventureLog.text = "You come across a merchant selling a very mysterious sack! His offer is " + CurrentProduct[2] + "G."
        }else{
            AdventureLog.text = "You come across a merchant selling some goods, he's offering " + CurrentProduct[1] + "x " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "G."}
        topEvent("Buy Product", #selector(DoBadMerchant))
        bottomEvent("Continue", #selector(GenerateEventButton))
    }
    
    @IBAction func DoBadMerchant(){
        let Cost: Double = Double(CurrentProduct[2])!
        if (Gold < Cost)
        {
            AdventureLog.text = "Looks like you don't have enough gold."
        }else{
            AdventureLog.text = "As you are exchanging goods, the merchant knocks you over and takes as much of your stuff as he can before you get back up! At least you still have the item you just bought..."

            Gold -= Cost
            Gold = (Gold / 2)
            Potions = (Potions / 2)
            switch CurrentProduct[0] {
            case "Potion":
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
            case "Weapon":
                GiveWeapon(SkipText: true, UseContainer: false, Total: Int(CurrentProduct[1]) ?? 1)
            case "Mystery Sack":
                GiveMysterySack()
            default:
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
            }
            
            SetLabels()
            SaveStats()
        }
        Next()
    }
    
    func FindHotSpring(){
        MainImage.image = UIImage(named: Theme + "Hotspring.png")
        AdventureLog.text = "You find a hot spring and take a quick dip." + "\n" + "You feel refreshed!";
        CurrentHP += CurrentHP / 5
        if (CurrentHP > MaxHP){
            CurrentHP = MaxHP}
        ClearBuffs()
        SetLabels()
        Next()
    }
    
    func FindTrap()
    {
        MainImage.image = UIImage(named: Theme + "Trap.png")
        let a: Int = Int(arc4random_uniform(101))
        if (a >= 0 && a < 25){
            FindPitFallTrap()
            }else if (a >= 25 && a < 50){
            FindRopeTrap()
            }else if (a >= 50 && a < 75){
            FindCurseTrap()
        }else if (a >= 75 && a < 100){
            FindMonsterTrap()
        }
    }
    
    func FindMonsterTrap()
    {
        if(Class != 1 && Class != 4)
            {
                AdventureLog.text = "You walk into a large room and see a cage with a goblin laughing next to it. It opens the cage and you see two glowing eyes staring back out at you, looks like a fight is about to happen...";
                if(!SquirrelMark){
                    NormalEnemy()
                }else{
                    SquirrelBattle()
                }
            }
            else
            {
                AdventureLog.text = "You walk into a large room and see a cage with a goblin laughing next to it. It starts to open the cage, but you quickly spot some TNT barrels on the other side of the cage, so you grab a near by torch and toss it at the barrels. It just barely hits the first barrel, but it's enough, the barrels all ignite and explode with great force, evaporating the goblin and whatever was in it's cage."
                Next()
            }
    }
    
    func FindRopeTrap()
    {
    if (Class != 1 && Class != 4){
    Gold -= Gold / 10
    Potions -= Potions / 10
    CurrentHP -= CurrentHP / 20
    AdventureLog.text = "You are walking through a hallway when all of a sudden you feel a tug at your foot. You look down and a goblin has grabbed you from a hole in the wall. You try to get away but it drags you into the hole....";
    }else{
    AdventureLog.text = "You notice a goblin trying to be sneaky as he snickers loudly from a hole in the wall. You walk out of arms reach on the other side of the hall.";
    }
        if (CurrentHP <= 0){
            Dead()
            AppendLog("The light of the torches are the last thing you see before entering eternal darkness...")
        }else{
            AppendLog("When you awake you find youself on the ground with some of your supplies missing.")
            Next()}
    }
    
    func FindCurseTrap()
{
    if (Class != 1 && Class != 4 && Class != 2)
    {
    AdventureLog.text = "You hear chanting coming from above you. You look up and a goblin is hanging on the ceiling seemingly chanting a curse. As you are about to run away he finishes he chant and hits you on the head with his staff. You pull the goblin down and kill it.";
    Curse(useString: true, isEvent: false, isBagCurse: false)
    }
    if(Class == 2)
    {
        AdventureLog.text = "You hear chanting coming from above you. You look up and a goblin is hanging on the ceiling seemingly chanting a curse. You imediately start putting a curse back on the little bastard. While you do succeed in cursing the goblin it too curses you. But it seems your curse was stronger as the goblin dries up as if its life was just sucked out.";
        Curse(useString: true, isEvent: false, isBagCurse: false)
    }
    else
    {
    AdventureLog.text = "You hear chanting coming from above you. You look up and a goblin is hanging on the ceiling seemingly chanting a curse. You quickly throw a knife at the goblin slaying it, avoiding any curse it was trying to place on you.";
    }
    if (CurrentHP <= 0){
        Dead()
        AppendLog("As you are walking away, you feel your body disolving into dust. It seems that curse was much more than expected...")
    }else{
        Next()}
    }
    
    func FindPitFallTrap()
    {
        if(Class != 1 && Class != 4)
        {
            Floor -= 1
                if(Floor < 1){
                    Floor = 1
                }
            FloorTenths = 0;
            CurrentHP -= (MaxHP / 10)
            AdventureLog.text = "You step into the room and see a goblin across the room smirking at you. You try to run to him to slay him, but he pulls a lever dropping you through the floor!";
        
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 90){
                StartBleeding()
            }
            if(Gen > 50){
                CurrentHP -= CurrentHP * (1/20)
            }
            FixStats()
            SetLabels()
        }
        else
        {
            AdventureLog.text = "You sense something is off and you see a goblin across the room smirking at you. You jump backwards and fire an arrow right into the goblin. As he is dying he pulls a lever next to him, and the floor in front of you collapses into the darkness.";
        }
        if (CurrentHP <= 0){
            Dead()
            AppendLog("The fall was so great that no human could've walked away from it...")
        }
        else{
            Next()}
    }
    @IBAction func Hamburger_button(_ sender: Any) {
        
        //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        //DispatchQueue.main.async(execute: {
         //   self.performSegue(withIdentifier: "SideSegue", sender: nil)})
    }
    
    @IBAction func EnterHell()
    {
        let image = UIImage(named: "HellBricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        inHell = true
        MainImage.image = UIImage(named: "QuestionMark_.png")

        AdventureLog.text = "You feel like your body and soul have just been ripped apart. Your vision starts to fade and you passout. When you awake you are no longer in the same dungeon. The walls are old and rotted away, and there's a foul scent in the air..."
        HellNext()
    }
    
    func HellNext()
    {
        //MainImage.image = UIImage(named: "QuestionMark_.png")
        ClassImage.image = nil
        TypeImage.image = nil
        
        let image = UIImage(named: "HellBricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        
        topEvent("Continue", #selector(GenerateHellEvent))
        bottomEvent("Continue", #selector(GenerateHellEvent))
    }
    
    var HellFloorTenths: Int = 0
    var HellFloor: Int = 1
    
    @IBAction func GenerateHellEvent()
    {
        MainImage.image = UIImage(named: "QuestionMark_.png")
        TypeImage.image = nil
        ClassImage.image = nil
        FixStats()
        
        if(HellFloorTenths <= 10){
            HellFloorTenths += 1
        }else{
            HellFloor += 1
            HellFloorTenths = 1
        }
        SetLabels()
            if(HellFloor >= 2 && HellFloorTenths >= 10){
                DeathsDoor()
            }else{
            let a: Int = Int(arc4random_uniform(130))
            
            if(a >= 0 && a < 25){
                HellWinds()
            }else if (a >= 50 && a < 75){
                HellBattle()
            }else if (a >= 75 && a < 100){
                HellFindItem()
            }else if(a >= 25 && a < 50){
                HellMerchant()
            }else if(a == 105){
                HellResetFloor()
            }else if( a > 105 && a < 125){
                HellMerchant(alive: true)
            }else{
                HellDoNothing()
            }
        }
    }
    
    func DeathsDoor()
    {
        AdventureLog.text = "You walk through a long hallway covered in bones and fire. At the end of the hall there's a door."
        topEvent("Continue", #selector(DeathsRoom))
        bottomEvent("Continue", #selector(DeathsRoom))
    }
    
    @IBAction func DeathsRoom()
    {
        AdventureLog.text = "As you walk through the door, a wave of pure heat and evil bursts forth. You push through and at the end of the room you see a giant coffin. The coffin door collapses and from within it emerges Death himself. You drawn your " + GenWeaponType() + " and step forward. Thus it begins."
        topEvent("Begin", #selector(FightDeath))
        bottomEvent("Begin", #selector(FightDeath))
    }
    
    @IBAction func FightDeath()
    {
        CurrentMonster = ["Death", String(666 * 20 * Double(AfterDeath * Floor * DecensionAdjustment)), "3"]
        MainImage.image = UIImage(named: Theme + "Death.png")
        ClassImage.image = UIImage(named: "Scythe.png")
        TypeImage.image = UIImage(named: "Crown.png")
        AdventureLog.text = "Death emerges from his coffin ready to battle." + "\n" + "Power: " + CutLabel(Double(CurrentMonster[1]) ?? 420)
        isStunned = false
        trapSet = false
        DeathHealth = Double(CurrentMonster[1])! * 666
        
        topEvent("Battle", #selector(NewBattleDeath))
        bottomEvent("Battle", #selector(NewBattleDeath))
    }

    func battleButtons(_ deathAtk: String){
        //let alertController = UIAlertController(title: nil, message: "What will you do?", preferredStyle: .actionSheet)
        let actionController = TwitterActionController()
        actionController.headerData = (AdventureLog.text + "\nWhat will you do?")
        var index: Int = 0
        actionController.addAction(Action(ActionData(title: "Attack!"), style: .default, handler: { action in
            index = 0
            self.handleDeathAtk(deathAtk, index)
            self.SetLabels()
            self.SaveStats()
            }))
        
        actionController.addAction(Action(ActionData(title: "Dodge!"), style: .default, handler: { action in
            index = 1
            self.handleDeathAtk(deathAtk, index)
            self.SetLabels()
            self.SaveStats()
            }))
        
        var ability: String = ""
        switch GenClassName(){
            case "Warrior":
                ability = "Power Attack"
            case "Ranger":
                ability = "Set Trap"
            case "Mage":
                ability = "Curse"
            case "The Haunted":
                ability = "Drain Life"
            case "King":
                ability = "Confidence Boost"
            case "Toaster":
                ability = "Burn"
            default:
                ability = "nil"
        }
        
        actionController.addAction(Action(ActionData(title: ability), style: .default, handler: { (action) in
            index = 2
            self.handleDeathAtk(deathAtk, index)
            self.SetLabels()
            self.SaveStats()
            }))
        
        actionController.addAction(Action(ActionData(title: "Use Potion"), style: .default, handler: { action in
            index = 3
            self.handleDeathAtk(deathAtk, index)
            self.SetLabels()
            self.SaveStats()
            }))

        //actionController.addSection(PeriscopeSection())
        actionController.addAction(Action(ActionData(title: "Do Nothing"), style: .cancel, handler: { action in
            index = 5
            self.handleDeathAtk(deathAtk, index)
            self.SetLabels()
            self.SaveStats()
            }))
        present(actionController, animated: true, completion: nil)
    }
    
    var playerAction: Int = 0
    
    func BattleTut(){
        let alert = UIAlertController(title: "Tutorial", message: "Think of this battle system as a more modern RPG battle. You will need to perform actions based on what your opponent is about to do. So for example if your enemy is about to attack you should probably dodge out of the way. Or if they are casting a spell you can take the time to heal or you can attack them to break their concentration! As you try it out you will learn what works best for each situation, so go get them!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Back To The Fight!", style: .cancel, handler: {action in self.NewBattleDeath()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func NewBattleDeath(){
        if(!defaults.bool(forKey: "NewBattle")){
            defaults.set(true, forKey: "NewBattle")
            let alert = UIAlertController(title: "Tutorial", message: "Welcome to the new boss battle system!\nWe are trying out a new style of fighting tough enemies in hopes of making the battles much more than just a regular enemy fight.\nWould you like to learn more?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No :(", style: .cancel, handler: {action in self.NewBattleDeath()}))
            alert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: {action in self.BattleTut()}))
            self.present(alert, animated: true, completion: nil)
        }else{
            if(CurrentHP <= 0){
                CurrentHP = 0
                SetLabels()
                AppendLog("Death's attack was too much!")
                HellDead()
            }else{
                if(DeathHealth <= 0){
                    DefeatDeath()
                }else{
                    disablePotions()
                    let deathAtk: String = GenDeathAttack()
                    AdventureLog.text = deathAtk
                    battleButtons(deathAtk)
                }
                SetLabels()
                SaveStats()
            }
        }
    }
    
    func genDeathDamage(_ DamageMultiplier: Double = 1){
        CurrentHP -= HandleBattle() * DamageMultiplier
    }
    
    func DeathNext(){
        topEvent("Actions", #selector(NewBattleDeath))
        bottomEvent("Actions", #selector(NewBattleDeath))
        if(DeathHealth < 0){
            DeathHealth = 0
        }
        AdventureLog.text = AdventureLog.text + "\nDeath Health: " + CutLabel(DeathHealth)
    }
    
    //0 == Attack
    //1 == Dodge
    //2 == Special attack
    //3 == Use Potion
    //5 == Do nothing
    func handleDeathAtk(_ deathAtk: String, _ playerAction: Int){
        if(trapSet){
            AdventureLog.text = "Death attempts to attack but gets caught in your trap!"
            DoPlayerAction(playerAction)
        }else{
        if(deathAtk == "Death is unable to act!"){
                DoPlayerAction(playerAction)
        }
        if(deathAtk == "Death is preparing to attack!" || deathAtk == "Death is readying to attack!"){
            if(playerAction == 1){
                AdventureLog.text = AdventureLog.text + "\nYou dodge out of the way!"
                DoPlayerAction(playerAction)
            }else{
                AdventureLog.text = "Death's attack lands a direct blow!";
                genDeathDamage()
                DoPlayerAction(playerAction)
            }
        }
        if(deathAtk == "Death is preparing a spell!"){
            if(playerAction == 0 || playerAction == 2){
                AdventureLog.text = "Death's concentration on the spell was broken!"
            }else{
                AdventureLog.text = "Death recovered health!"
                DeathHealth += DeathHealth / 50
            }
            DoPlayerAction(playerAction)
        }
        if(deathAtk == "Death is radiating a dark energy!"){
            if(playerAction == 0 || playerAction == 2){
                AdventureLog.text = "As you approach to attack,\nDeath lets out a giant burst of dark energy!"
                genDeathDamage(2)
            }else if(playerAction == 1){
                AdventureLog.text = "Death lets out a giant burst of dark energy, but you managed to get out of the way!"
            }else{
                AdventureLog.text = AdventureLog.text + "\nDeath lets out a giant burst of enegy! It hurts but it doesn't stop you!"
                DoPlayerAction(playerAction)
                genDeathDamage()
            }
        }
        if(deathAtk == "Death retreated backwards!"){
            DoPlayerAction(playerAction)
        }
        if(deathAtk == "Death is taunting you!"){
            if(playerAction == 0 || playerAction == 2){
                AdventureLog.text = "As you approach to attack Death lands a direct attack with his scythe!!"
                genDeathDamage(3)
            }else{
                DoPlayerAction(playerAction)
            }
        }
        if(deathAtk == "Death lunges forward!"){
            if(playerAction == 1){
                AdventureLog.text = AdventureLog.text + "\nYou dodge out of the way!"
            }else{
                AdventureLog.text = "Death's attack lands a direct blow!";
                genDeathDamage(2)
            }
        }
        if(deathAtk == "Death englufs himself in fire!"){
            if(playerAction == 0 || playerAction == 2){
                AdventureLog.text = "As you approach to attack but are hit by the fire!"
                genDeathDamage(3)
            }else{
                AdventureLog.text = "The fire is so intense that you can't do anything!"
            }
        }
        if(deathAtk == "Death is preparing a curse!"){
            if(Class != 2){
                AdventureLog.text = "Death's curse causes you to stagger back before you have a chance to act!"
            }else{
                AdventureLog.text = "The curse doesn't affect a hardened Mage such as yourself!"
                DoPlayerAction(playerAction)
            }
        }
        if(deathAtk == "Death is assesing the situation..."){
            DoPlayerAction(playerAction)
        }
        DeathNext()
    }
    }
    var DeathHealth: Double = 0
    var playerSkip: Bool = false
    func DoPlayerAction(_ playerAction: Int){
        if(!playerSkip){
        switch playerAction{
        case 0: do {
                if(Power / 10 < 1){
                    DeathHealth -= 1
                }else{
                    DeathHealth -= Power / 10
                }
            AdventureLog.text = AdventureLog.text + "\nYou attack Death dealing\n" + CutLabel(Power / 10) + " points of damage!"
            }
        case 2: do {
            DoSpecial()
            }
        case 3: do {
            //Use Potion
            AdventureLog.text = AdventureLog.text + "\nYou use a potion!"
            if(Potions > 1){
                    Potions -= 1
                    CurrentHP += CurrentHP / 10
                    if(CurrentHP >= MaxHP){
                        CurrentHP = MaxHP
                    }
                }
            }
        default:
            break
        }
        }
        else{
            AdventureLog.text = AdventureLog.text + "\nUnable to do anything!"
        }
    }
    
    var trapSet: Bool = false;
    func DoSpecial(){
        switch GenClassName(){
        case "Warrior": do{
            AdventureLog.text = AdventureLog.text + "\nYou swing your sword and attack with all of your strength!!\nDealing " + CutLabel(Power / 10) + " points of damage!"
                DeathHealth -= Power
            }
        case "Ranger": do{
             AdventureLog.text = AdventureLog.text + "\nYou quickly throw together a booby trap and throw it infront of you..."
             trapSet = true
        }
        case "Mage": do{
            AdventureLog.text = AdventureLog.text + "\nYou begin chanting an ancient curse, in doing so you place a curse,\ntemporarily stopping the enemy!"
            isStunned = true
        }
        case "The Haunted": do{
            AdventureLog.text = AdventureLog.text + "\nYou turn into an astral form and zip through Death and eat part of his twisted evil soul!"
            CurrentHP += DeathHealth / 30
            if(CurrentHP >= MaxHP){
                CurrentHP = MaxHP
            }
            DeathHealth -= DeathHealth / 30
        }
        case "King": do{
            AdventureLog.text = AdventureLog.text + "\nYou pull out a mirror and quickly give yourself a pep talk, in doing so you feel like you can do anything!"
            Adjustpower(Power / 35)
        }
        case "Toaster": do{
            AdventureLog.text = AdventureLog.text + "\nYou call upon the fires that burn hotter than Hell itself!"
            DeathHealth -= DeathHealth / 30
        }
        default: do{}
        }
        
        SetLabels()
        SaveStats()
    }
    var isStunned: Bool = false
    func GenDeathAttack(_ isStunned: Bool = false) -> String{
        let a: Int = Int(arc4random_uniform(100))
        if(isStunned){
            return "Death is unable to act!"
        }
        if(a <= 10){
            return "Death is preparing to attack!"
        }else if(a > 10 && a <= 20){
            return "Death is preparing a spell!"
        }else if(a > 20 && a <= 30){
            return "Death is radiating a dark energy!"
        }else if(a > 30 && a <= 40){
            return "Death retreated backwards!"
        }else if(a > 40 && a <= 50){
            return "Death is taunting you!"
        }else if(a > 50 && a <= 55){
            return "Death is readying to attack!"
        }else if(a > 55 && a <= 70){
            return "Death lunges forward!"
        }else if(a > 70 && a <= 75){
            return "Death englufs himself in fire!"
        }else if(a > 80 && a <= 90){
            return "Death is preparing a curse!"
        }else{
            return "Death is assesing the situation..."
        }
    }
    
    @IBAction func BattleDeath(){
        let Damage: Double = HandleBattle()
        CurrentHP -= Damage
        SetLabels()
        if (CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            HellDead()
        }else{
            DefeatDeath()
        }
    }
    
    @IBAction func DefeatDeath()
    {
        enablePotions()
        defaults.set(true, forKey: "hasKilledDeath")
        MainImage.image = UIImage(named: Theme + "TreasureChest.png")
        AdventureLog.text = "You stand over Death victorious. You pick up Death's Sythe and with one great swing you slay Death with his own weapon. As you do so you once again feel your body and soul being ripped apart. But unlike last time it quickly fades. You look around and see a chest."
        topEvent("Open Chest", #selector(DeathsTreasure))
        bottomEvent("Open Chest", #selector(DeathsTreasure))
    }
    
    @IBAction func DeathsTreasure()
    {
        MainImage.image = UIImage(named: "QuestionMark_.png")
        ClassImage.image = nil
        TypeImage.image = nil
        AdventureLog.text = "You open the chest and are englufed in a flash of darkness. For what feels like forever you can't see anything. You call out, but your voices just echos and dies in the darkness..."
        topEvent("Give Up", #selector(GiveUp))
        bottomEvent("Call Out", #selector(CallOut))
    }
    
    @IBAction func GiveUp()
    {
        AdventureLog.text = "You give up on finding a way out of the darkness and let it engulf you. You can feel the power in the darkness, you understand more than ever what true power is." + "\n" + "And after what feels like an eternity in darkness, a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon..."
        //Class = 3
        Adjustpower(Power * 2)
        ClearBuffs()
        AfterDeath += 6
        //defaults.set(true, forKey: "PowerOfDarkness")
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        CurrentHP = (MaxHP / 4).rounded(toPlaces: 0)
        if(!defaults.bool(forKey: "HauntedUnlocked")){
            DisplayAlert(title: "Unlocked Character!", message: "You unlocked 'The Haunted' as a playable class!", button: "OK")
            defaults.set(true, forKey: "HauntedUnlocked")
        }
        
        HellFloor = 0
        HellFloorTenths = 0
        SetLabels()
        SaveStats()
        Next()
    }
    
    @IBAction func CallOut()
    {
        AdventureLog.text = "You call out repeatedly, hundreds, thousands of times. Over and over and over again. The words quickly begin to mean less and less to you. Eventually your thoughts are of only escaping the darkness." + "\n" + "And after what feels like an eternity a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon... Or are you?"
        //Class = 3
        Adjustpower(Power / 50)
        AfterDeath += 3
        CurseImmunity = true
        defaults.set(true, forKey: "isCrazy")
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        CurrentHP = (MaxHP / 4).rounded(toPlaces: 0)
        if(!defaults.bool(forKey: "HauntedUnlocked")){
                    DisplayAlert(title: "Unlocked Character!", message: "You unlocked 'The Haunted' as a playable class!", button: "OK")
                    defaults.set(true, forKey: "HauntedUnlocked")
        }
        
        HellFloor = 0
        HellFloorTenths = 0
        SetLabels()
        SaveStats()
        Next()
    }
    
    func ClearBuffs()
    {
        defaults.set(0, forKey: "CurseChance")
        defaults.set(0, forKey: "EnemyChance")
        defaults.set(0, forKey: "FindItemChance")
        defaults.set(0, forKey: "MerchantChance")
        defaults.set(0, forKey: "ElevatorChance")
        defaults.set(0, forKey: "FallChance")
        defaults.set(0, forKey: "MiscEventChance")
        defaults.set(0, forKey: "CampChance")
        defaults.set(0, forKey: "BossChance")
        defaults.set(0, forKey: "WeaponChance")
        defaults.set(0, forKey: "GoldChance")
        defaults.set(0, forKey: "PotionChance")
        defaults.set(0, forKey: "CursedWeaponChance")
    }
    
    func HellWinds()
    {
        AdventureLog.text = "A chilling yet burning hot wind hits you. You sense that something is angry..."
        CurrentHP -= (CurrentHP / 20)
        SetLabels()
        HellNext()
    }
    
    func HellBattle(isDeath: Bool = false)
    {
        CurrentMonster = GetHellMonster()
        //let EnemyPower: Double = Double(CurrentMonster[1])!
        
        //CurrentMonster = { Monster[0], EnemyPower.ToString(), Monster[2] }
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        AdventureLog.text = "The wall in front of you starts oozing blood. As it falls and hits the ground it takes the form of a demonic " + CurrentMonster[0] + "\n" + "Enemy Power: " + DoubleString(Input: Double(CurrentMonster[1]) ?? 420)
        
        topEvent("Battle!", #selector(FightHellEnemy))
        bottomEvent("Battle", #selector(FightHellEnemy))
    }
    
    func GetHellMonster() -> [String]
    {
        let Gen: Int = Int(arc4random_uniform(UInt32(MonsterArray.count)))
        let TempArray: [String] = MonsterArray[Gen].components(separatedBy: ",")
        let TempPower: String = String(Double(TempArray[1])! * 15 * Double(AfterDeath * Floor * DecensionAdjustment))
        let FinalResult: [String] = [TempArray[0], TempPower , TempArray[2]]
        return FinalResult
    }
    
    
    @IBAction func FightHellEnemy()
    {
        let Damage: Double = HandleBattle()
        CurrentHP -= Damage
        if(CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            AppendLog("The \(CurrentMonster[0]) was too powerful!")
            HellDead()
        }
        else{
            var LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 2000)))
            if(Class == 4){
                LootedGold = LootedGold * 3
            }
            AdventureLog.text = "You slayed the \(CurrentMonster[0])! You looted the body and gained " + DoubleString(Input: LootedGold) + "G."
            AdjustGold(LootedGold)
            AdjustHP(MaxHP * 10/100)
            SetLabels()
            HellNext()
        }
    }
    
    func HellMerchant(alive: Bool = false)
    {
        MainImage.image = UIImage(named: Theme + "Merchant.png")
        if (alive)
        {
            CurrentProduct = HellGenProduct()
            
            if (CurrentProduct[0] == "Nothing"){
                AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he doesn't have any goods though..."
            }else{
                AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he wants to sell you " + CurrentProduct[1] + "x " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "g."}
            
            topEvent("Deal", #selector(HellDoMerchant))
            bottomEvent("Continue", #selector(GenerateHellEvent))
            
            if (CurrentProduct[0] == "Nothing"){
                HellNext()}
        }
        else
        {
            MainImage.image = nil
            AdventureLog.text = "You find what looks like the remains of some kind of shop keep..."
            HellNext()
        }
    }
    
    func HellGenProduct() -> [String]{
        let Gen: Int = Int(arc4random_uniform(2))
        var Type: String = ""
        switch Gen {
        case 0:
            Type = "Potion"
        case 1:
            Type = "Weapon"
        default:
            Type = "Nothing"
        }
        let Total: Int = Int(arc4random_uniform(4)) + 1
        let Cost: Double = Double(arc4random_uniform(UInt32(20000 * Floor))) + 5000
        let Result: [String] = [Type, String(Total), DoubleString(Input: Cost)]
        return Result
    }
    
    
    @IBAction func HellDoMerchant()
    {
        let Cost: Double = Double(CurrentProduct[2]) ?? 0
        if(Gold < Cost){
            AdventureLog.text = "Not enough Gold for this purchase."
            HellNext()
        }
        else{
            Gold -= Cost
            switch CurrentProduct[0] {
            case "Potion":
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
            case "Weapon":
                GiveWeapon(SkipText: true, UseContainer: false, Total: Int(CurrentProduct[1]) ?? 1)
            default:
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
            }
            
            AdventureLog.text = "Come again!"
            HellNext()
        }
    }
    
    func HellFindItem()
    {
        MainImage.image = UIImage(named: Theme + "TreasureChest.png")
        AdventureLog.text = "You find a chest and as soon as you try to open it, it turns into sand right as you reach for it..."
        HellNext()
    }
    
    func HellDoNothing()
    {
        MainImage.image = UIImage(named: "QuestionMark_.png")
        AdventureLog.text = "Nothing is here but the screams of forgotten souls..."
        HellNext()
    }
    
    func HellResetFloor()
    {
        AdventureLog.text = "A strong pulls you back to the beginning of the floor!"
        HellFloorTenths = 0
        HellNext()
    }
    
    func HellDead()
    {
        disablePotions()
        MainImage.image = UIImage(named: "Dead.png")
        AppendLog("You died!\nYou can feel your soul being tugged away...")
        topEvent("Well Shucks...", #selector(ReturnHome))
        bottomEvent("That's My Soul I Need That!", #selector(HellRevive))
    }
    
    @IBAction func ReturnHome()
    {
        enablePotions()
        AdventureLog.text = "You feel your soul letting go. Everything goes black. When you awake you are back in the Tower.. Whas it just a dream?"
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        
        MainView.backgroundColor = UIColor(patternImage: scaled)
        MainImage.image = UIImage(named: "QuestionMark_.png")
        CurrentHP = MaxHP / 4
        SetLabels()
        SaveStats()
        Next()
    }
    
    @IBAction func HellRevive()
    {
        enablePotions()
        AdventureLog.text = "You try to muster up the power to get back up, but fail. You collapse and everything goes black. When you wake, you are back in the Tower..."
        HellFloorTenths = 0
        HellFloor = 0
        CurrentHP = 1
        SetLabels()
        SaveStats()
        HellNext()
    }
    
    func AdjustHP(_ Value: Double, Add: Bool = true){
        if(Value <= MaxValue && Value > OverFlowed){
            if(MaxHP < MaxValue){
                if(Add){
                    MaxHP += Value
                }else{
                    MaxHP -= Value
                }
            }
        }else{
            MaxHP = MaxValue
        }
    }
    
    func Adjustpower(_ Value: Double, Add: Bool = true){
        if(Value <= MaxValue && Value > OverFlowed){
            if(Power < MaxValue){
                if(Add){
                    Power += Value
                }else{
                    Power -= Value
                }
            }
        }else{
            Power = MaxValue
        }
    }
    
    func AdjustGold(_ Value: Double, Add: Bool = true){
        if(Gold < MaxValue){
            if(Add){
                Gold += Value
            }else{
                Gold -= Value
            }
        }
    }
    
    func AdjustPotions(_ Value: Double, Add: Bool = true){
        if(Potions < MaxValue){
            if(Add){
                Potions += Value
            }else{
                Potions -= Value
            }
        }
    }
    
    @IBAction func Debug(){
        let alert = UIAlertController(title: "Debug Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Change Stats", style: UIAlertAction.Style.default, handler: { action in
            self.StatDebug()
        }))
        alert.addAction(UIAlertAction(title: "Do Event", style: .default, handler: { action in
            self.EventDebug()
        }))
        alert.addAction(UIAlertAction(title: "Update Labels", style: .default, handler: { action in
            self.SetLabels()
        }))
        alert.addAction(UIAlertAction(title: "Save Stats", style: .default, handler: { action in
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Reload Stats", style: .default, handler: { action in
            self.ReadStats()
            self.SetLabels()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func EventDebug(){
        let alert = UIAlertController(title: "Event Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Find Item", style: UIAlertAction.Style.default, handler: { action in
            self.FindItemDebug()
        }))
        alert.addAction(UIAlertAction(title: "Fight Enemy", style: UIAlertAction.Style.default, handler: { action in
            self.EnemyDebug()
        }))
        alert.addAction(UIAlertAction(title: "Find Camp", style: UIAlertAction.Style.default, handler: { action in
            self.FindCamp()
        }))
        alert.addAction(UIAlertAction(title: "Find Hell", style: UIAlertAction.Style.default, handler: { action in
            self.FindHell()
        }))
        alert.addAction(UIAlertAction(title: "Elevator", style: UIAlertAction.Style.default, handler: { action in
            self.FindElevator()
        }))
        alert.addAction(UIAlertAction(title: "Pitfall", style: UIAlertAction.Style.default, handler: { action in
            self.Fall()
        }))
        alert.addAction(UIAlertAction(title: "Find Trap", style: UIAlertAction.Style.default, handler: { action in
            self.FindTrap()
        }))
        alert.addAction(UIAlertAction(title: "Dream", style: UIAlertAction.Style.default, handler: { action in
            self.DreamDebug()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func DreamDebug(){
        let alert = UIAlertController(title: "Dream Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Home", style: UIAlertAction.Style.default, handler: { action in
            self.GenHomeEvent()
        }))
        alert.addAction(UIAlertAction(title: "Castle", style: UIAlertAction.Style.default, handler: { action in
            self.GenCastleEvent()
        }))
        alert.addAction(UIAlertAction(title: "Boss", style: UIAlertAction.Style.default, handler: { action in
            self.GenMarketEvent()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func EnemyDebug(){
        let alert = UIAlertController(title: "Enemy Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Normal (Random)", style: UIAlertAction.Style.default, handler: { action in
            self.NormalEnemy()
        }))
        alert.addAction(UIAlertAction(title: "Normal (Specific)", style: UIAlertAction.Style.default, handler: { action in
            self.EnemyChoice()
        }))
        alert.addAction(UIAlertAction(title: "Enhanced", style: UIAlertAction.Style.default, handler: { action in
            self.EnhancedEnemy()
        }))
        alert.addAction(UIAlertAction(title: "Boss", style: UIAlertAction.Style.default, handler: { action in
            self.Boss()
        }))
        alert.addAction(UIAlertAction(title: "Find Squirrel", style: UIAlertAction.Style.default, handler: { action in
            self.FindSquirrel()
        }))
        alert.addAction(UIAlertAction(title: "Gilgamesh", style: UIAlertAction.Style.default, handler: { action in
            self.EncounterGilgamesh()
        }))
        alert.addAction(UIAlertAction(title: "Find Hag", style: UIAlertAction.Style.default, handler: { action in
            self.FindOldHag()
        }))
        alert.addAction(UIAlertAction(title: "Fight Death", style: UIAlertAction.Style.default, handler: { action in
            self.FightDeath()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func EnemyChoice(){
        let alert = UIAlertController(title: "Enemy Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        for monster in MonsterArray {
            alert.addAction(UIAlertAction(title: monster, style: UIAlertAction.Style.default, handler: { action in
                self.NormalEnemy(Overload: monster)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func FindItemDebug(){
        let alert = UIAlertController(title: "Item Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Weapon", style: UIAlertAction.Style.default, handler: { action in
            self.GiveWeapon(SkipText: false, UseContainer: false, Total: 1, UseNext: true, isCursed: false)
        }))
        alert.addAction(UIAlertAction(title: "Gold", style: UIAlertAction.Style.default, handler: { action in
            self.GiveGold(SkipText: false, UseContainer: false)
        }))
        alert.addAction(UIAlertAction(title: "Potion (100)", style: UIAlertAction.Style.default, handler: { action in
            self.GivePotion(SkipText: false, UseContainer: false, Total: 100)
        }))
        alert.addAction(UIAlertAction(title: "Treasure Chest", style: UIAlertAction.Style.default, handler: { action in
            self.FindTreasure()
        }))
        alert.addAction(UIAlertAction(title: "Random Item", style: UIAlertAction.Style.default, handler: { action in
            self.FindItem()
        }))
        alert.addAction(UIAlertAction(title: "Mimic", style: UIAlertAction.Style.default, handler: { action in
            self.MimicBattle(MimicName: "Treasure Mimic")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func StatDebug(){
        let alert = UIAlertController(title: "Stat Menu", message: "Please select an option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Set All To Max", style: UIAlertAction.Style.default, handler: { action in
            self.Power = self.MaxValue
            self.CurrentHP = self.MaxValue
            self.MaxHP = self.MaxValue
            self.Gold = self.MaxValue
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Halve All Stats", style: UIAlertAction.Style.default, handler: { action in
            self.Power = self.Power / 2
            self.Gold = self.Gold / 2
            self.MaxHP = self.MaxHP / 2
            self.CurrentHP = self.MaxHP
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Set all to 1", style: UIAlertAction.Style.default, handler: { action in
            self.Power = 1
            self.CurrentHP = 1
            self.MaxHP = 1
            self.Gold = 1
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Set Floor To 250", style: UIAlertAction.Style.default, handler: { action in
            self.Floor = 250
            self.FloorTenths = 0
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Set Floor To 2", style: UIAlertAction.Style.default, handler: { action in
            self.Floor = 2
            self.FloorTenths = 0
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Change Decension Status", style: UIAlertAction.Style.default, handler: { action in
            self.defaults.set(!self.defaults.bool(forKey: "ReturnTrip"), forKey: "ReturnTrip")
            self.SetLabels()
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Change ESP Status", style: UIAlertAction.Style.default, handler: { action in
            self.hasESP = !self.hasESP
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Change Bleeding Status", style: UIAlertAction.Style.default, handler: { action in
            self.isBleeding = !self.isBleeding
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Change Confusion Status", style: UIAlertAction.Style.default, handler: { action in
            self.isConfused = !self.isConfused
            self.SaveStats()
        }))
        alert.addAction(UIAlertAction(title: "Kill Yourself", style: UIAlertAction.Style.default, handler: { action in
            self.CurrentHP = 0
            self.SetLabels()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    public class LoadingOverlay{
        
        var overlayView = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
        class var shared: LoadingOverlay {
            struct Static {
                static let instance: LoadingOverlay = LoadingOverlay()
            }
            return Static.instance
        }
        
        public func showOverlay(view: UIView) {
            
            overlayView.frame = CGRect(x:0, y:0, width:200, height:200)
            overlayView.center = view.center
            overlayView.backgroundColor = UIColor(rgb: 0x727272, alpha: 0.7)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator.style = .whiteLarge
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            
            overlayView.addSubview(activityIndicator)
            view.insertSubview(overlayView, at: 20)
            
            activityIndicator.startAnimating()
        }
        
        public func hideOverlayView() {
            activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let temp: String = String((self * divisor).rounded() / divisor)
        return Double(temp) ?? 0
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension UILabel {
    func set(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString(string: text, attributes: [.font: self.font!])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }
}
