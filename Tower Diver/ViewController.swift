//
//  ViewController.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/21/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        
        MainView.backgroundColor = UIColor(patternImage: scaled)
        var hasCharacter = defaults.object(forKey: "hasCharacter")
        if(hasCharacter == nil){
            hasCharacter = false
        }
        if(hasCharacter as! Bool == false){
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "CharacterCreationSegue", sender: nil)
            })
        }
        else{
            ReadStats()
            FixStats()
            SetLabels()
            Next()
            MainImage.image = UIImage(named: "QuestionMark_.png")
            MainImage.layer.borderWidth = 2
            MainImage.layer.borderColor = UIColor.gray.cgColor
            
            Top_Button.layer.borderWidth = 2
            Top_Button.layer.borderColor = UIColor.gray.cgColor
            
            Bottom_Button.layer.borderWidth = 2
            Bottom_Button.layer.borderColor = UIColor.gray.cgColor
            
            AdventureLog.layer.borderWidth = 2
            AdventureLog.layer.borderColor = UIColor.gray.cgColor
            
            Potion_Label.layer.borderWidth = 2
            Potion_Label.layer.borderColor = UIColor.gray.cgColor
            
            HP_Label.layer.borderWidth = 2
            HP_Label.layer.borderColor = UIColor.gray.cgColor
            
            Gold_Label.layer.borderWidth = 2
            Gold_Label.layer.borderColor = UIColor.gray.cgColor
            
            Power_Label.layer.borderWidth = 2
            Power_Label.layer.borderColor = UIColor.gray.cgColor
            
            Name_Label.layer.borderWidth = 2
            Name_Label.layer.borderColor = UIColor.gray.cgColor
            
            Side_Button.layer.borderWidth = 2
            Side_Button.layer.borderColor = UIColor.gray.cgColor
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(DisplayHP))
            HP_Label.isUserInteractionEnabled = true
            HP_Label.addGestureRecognizer(tap)
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(DisplayPower))
            Power_Label.isUserInteractionEnabled = true
            Power_Label.addGestureRecognizer(tap2)
            
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(DisplayGold))
            Gold_Label.isUserInteractionEnabled = true
            Gold_Label.addGestureRecognizer(tap3)
            
            if(defaults.string(forKey: "MonsterTheme") == nil){
                defaults.set("", forKey: "MonsterTheme")
                Theme = ""
            }
        }
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
        default:
            ClassString = "Boop"
        }
        return ClassString
    }
    
    @IBOutlet weak var Side_Button: UIButton!
    
    func FixStats(){
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
        if(CurrentHP < 1){
            Dead()
        }
    }
    
    var KingUnlocked: Bool = false
    var HauntedUnlocked: Bool = false
    
    func SetLabels(){
        //Name_Label.text = Name
        Name_Label.text = "Floor: " + String(Floor)
        HP_Label.text = "HP: " + CutLabel(CurrentHP) + "\\" + CutLabel(MaxHP)
        Power_Label.text = "Power: " + CutLabel(Power)
        Gold_Label.text = "Gold: " + CutLabel(Gold)
        Potion_Label.text = "Potions: " + CutLabel(Potions)
        
        if(CurrentHP < MaxHP / 2){
            HP_Label.backgroundColor = UIColor.red
        }else{
            HP_Label.backgroundColor = UIColor.white
        }
        
        if(CurrentHP < 1){
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
        if(Input >= 1000000000000){
            Letter = "T"
            Number.removeLast(12)
        }else if(Input >= 1000000000 && Input < 1000000000000){
            Letter = "B"
            Number.removeLast(9)
        }else if(Input >= 1000000 && Input < 1000000000){
            Letter = "M"
            Number.removeLast(6)
        }else if(Input >= 100000 && Input < 1000000){
            Letter = "K"
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
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Continue", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
        SaveStats()
    }
    
    func Dead(){
        AdventureLog.text = "You died!" + "\n" + "You made it to floor: " + String(Floor) + "!"
        MainImage.image = UIImage(named: "Dead.png")
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Well Shucks", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(Restart), for: .touchUpInside)
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Well Shucks", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(Restart), for: .touchUpInside)
    }
    
    @IBAction func Restart(_ sender: Any){
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
        CurseChance = 5
        EnemyChance = 20
        FindItemChance = 30
        MerchantChance = 8
        ElevatorChance = 2
        FallChance = 2
        MiscEventChance = 9
        CampChance = 4
        
        EnhancedChance = 6
        BossChance = 4
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
        
        LoadItemChances()
        
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
    
    func GenEvent(){
        NSLog("Checking for Bleeding")
        DoBleedDamage()
        NSLog("Checking for confusion")
        SwapButtons()
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
        Name_Label.text = "Floor: " + String(Floor)
        MainImage.image = nil
        
        let Total: UInt32 = LoadChances() + 1
        let Result: Int = Int(arc4random_uniform(Total))
        NSLog("Total: " + String(Total))
        NSLog("Generated Number: " + String(Result))
        if(Result >= 0 && Result <= CurseChance ){
            NSLog("Curse")
            Curse(useString: true, isEvent: true)}
        else if(Result > CurseChance && Result <= EnemyChance){
            NSLog("Battle")
            Battle()}
        else if(Result > EnemyChance && Result <= FindItemChance){
            NSLog("Find Item")
            FindItem();}
        else if(Result > FindItemChance && Result <= MerchantChance){
            NSLog("Find Merchant")
            FindMerchant()}
        else if(Result > MerchantChance && Result <= ElevatorChance){
            NSLog("Find Elevator")
            FindElevator()}
        else if(Result > ElevatorChance && Result <= FallChance && Floor > 10){
            NSLog("Fall")
            Fall()}
        else if(Result > FallChance && Result <= MiscEventChance){
            NSLog("Generating Misc Event")
            GenMiscEvent()}
        else if(Result > MiscEventChance && Result <= CampChance){
            NSLog("Find Camp")
            FindCamp()}
        else{
            NSLog("FindNothing")
            DoNothing()
        }
    }
    
    func DoNothing(){
        AdventureLog.text = "Nothing was here"
        Next()
    }
    
    func FindCamp(){
        MainImage.image = UIImage(named: "Tent.png")
        AdventureLog.text = "You find an empty room big enough for a camp..."
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Setup Camp", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Just Rest", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(DoCampRest), for: .touchUpInside)
        
        if(Potions < 3)
        {
            Top_Button.setTitle("Just Rest", for: .normal)
            Top_Button.addTarget(self, action: #selector(DoCampRest), for: .touchUpInside)
        }else{
            Top_Button.addTarget(self, action: #selector(DoCamp), for: .touchUpInside)
        }
    }
    
    @IBAction func DoCamp(){
        AdventureLog.text = "You setup a camp and feel refreshed and well rested!"
        CurrentHP = MaxHP
        Potions -= 3
        isBleeding = false
        BleedingCounter = 0
        SetLabels()
        Next()
    }
    
    @IBAction func DoCampRest(){
        AdventureLog.text = "You take a quick break and feel reseted!"
        CurrentHP += (CurrentHP / 20)
        if(CurrentHP > MaxHP)
        {CurrentHP = MaxHP}
        SetLabels()
        Next()
    }

    
    func Fall(){
        let Drop: Int = Int(arc4random_uniform(4)) + 1
        AdventureLog.text = "The ground around you starts to collapse! You don't jump out of the way in time and fall " + String(Drop) + " floor(s)!"
        MainImage.image = UIImage(named: "Hole.png")
        Floor -= Drop
        FloorTenths = 0
        CurrentHP -= (MaxHP / 10)
        
        let Gen: UInt32 = arc4random_uniform(100)
        if(Gen > 75){
            StartBleeding()
        }
        
        SetLabels()
        SaveStats()
        Next()
    }
    
    var isBleeding: Bool = false
    var BleedingCounter: Int = 0
    
    func StartBleeding(){
        if(isBleeding){
            AdventureLog.text = AdventureLog.text + "\n\n" + "Your wounds have reopened!"
            if(BleedingCounter >= 5){
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
        AdventureLog.text = "An elevator in a dungeon? How odd..."
        MainImage.image = UIImage(named: "Elevator.png")
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Ride Elevator", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(DoElevator), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue On This Floor", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
    }
    
    @IBAction func DoElevator(_ sender: Any){
        let Raise: Int = Int(arc4random_uniform(3)) + 1
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
        let Cost: Double = Double(arc4random_uniform(UInt32(1000 * Floor)))
        let Result: [String] = [Type, String(Total), DoubleString(Input: Cost)]
        return Result
    }
    
    var CurrentProduct: [String] = []
    
    func FindMerchant(){
        CurrentProduct = GenProduct()
        MainImage.image = UIImage(named: "Merchant.png")
        if(CurrentProduct[0] == "Mystery Sack"){
            AdventureLog.text = "You come across a merchant selling a very mysterious sack! His offer is " + CurrentProduct[2] + "G."
        }else{
            AdventureLog.text = "You come across a merchant selling some goods, he's offering x" + CurrentProduct[1] + " " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "G."}
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Buy Product", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(BuyProduct), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
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
        let PowerLevel: Double = Double(arc4random_uniform(UInt32(50 * Floor))) + 50
        if(!SkipText && !UseContainer){
            AdventureLog.text = "You obtained a " + GenWeaponType() + " with a power of " + DoubleString(Input: PowerLevel) + "!"
        }
        if(!SkipText && UseContainer){
            MainImage.image = UIImage(named: "Weapons.png")
            AdventureLog.text = "You found a " + GenContainer() + " containing a " + GenWeaponType() + " with a power of " + DoubleString(Input: PowerLevel) + "!"
        }
        Power += PowerLevel
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
                GivePotion(SkipText: false, UseContainer: false, Total: Double(arc4random_uniform(UInt32(Floor * 3))))
                Next()
            }
        }
    }
    
    func GiveGold(SkipText: Bool = false, UseContainer: Bool = true){
        MainImage.image = UIImage(named: "Gold.png")
        let Gen: Double = Double(arc4random_uniform(UInt32(300 * Floor)))
        if(Class == 4){
            Gold = Gold * 3
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
        MainImage.image = UIImage(named: "weapons.png")
        if(CanBeCursed && arc4random_uniform(50) < CursedWeaponChance){
            GiveWeapon(SkipText: SkipText, UseContainer: UseContainer, Total: Total, UseNext: UseNext, isCursed: true)
        }
        else{
            GiveWeapon(SkipText: SkipText, UseContainer: UseContainer, Total: Total, UseNext: UseNext)
        }
        
    }
    
    func FindItem(UseContainer: Bool = true){
        let Total: UInt32 = LoadItemChances()
        let Gen: Int = Int(arc4random_uniform(Total) + 10)
        if(Gen >= 0 && Gen <= WeaponChance){
            GenWeapon(SkipText: false, UseContainer: true, Total: 1, CanBeCursed: true)
            Next()
        }
        else if(Gen > WeaponChance && Gen <= GoldChance){
            GiveGold()
            Next()
        }
        else if(Gen > GoldChance && Gen <= PotionChance){
            MainImage.image = UIImage(named: "Potion.png")
            GivePotion(SkipText: false, UseContainer: true, Total: Double(arc4random_uniform(19)) + 1)
            Next()
        }else{
            AdventureLog.text = "You found a treasure chest!"
            MainImage.image = UIImage(named: "TreasureChest.png")
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle("Open", for: .normal)
            Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: #selector(FindTreasure), for: .touchUpInside)
            
            
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle("Continue", for: .normal)
            Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(defaults.bool(forKey: "TempPotionCheck")){
            Potions -= 8
            CurrentHP = MaxHP
            SaveStats()
            defaults.set(false, forKey: "TempPotionCheck")
            
            if(Class == 2){
                Power += Power * (40 / 100)
            }
        }
        if(defaults.bool(forKey: "ReturnToTitle")){
            SaveStats()
            dismiss(animated: true, completion: nil)
            defaults.set(false, forKey: "ReturnToTitle")
        }
        if(defaults.bool(forKey: "RestartCharacter")){
            defaults.set(false, forKey: "RestartCharacter")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "CharacterCreationSegue", sender: nil)
            })
        }
        
        if(defaults.bool(forKey: "DonationAddition")){
            Power += 5000
            Gold += 5000
            SaveStats()
        }
        ReadStats()
        SetLabels()
    }
    
    @IBAction func FindTreasure(){
        
        let a: Int = Int(arc4random_uniform(106))
        if (a >= 0 && a <= 25)
        {
            AdventureLog.text = "The treasure chest contains a weapon, take it?"
            GenWeapon(SkipText: false, UseContainer: false, Total: 1, UseNext: false, CanBeCursed: true)
            Next()
        }else if (a > 25 && a <= 40){
            AdventureLog.text = "The chest contained Gold!"
            GiveGold(SkipText: false, UseContainer: false)
            Next()
        }else if (a > 50 && a <= 80){
            AdventureLog.text = "The chest contained Potions!"
            GivePotion(SkipText: false, UseContainer: false, Total: Double(arc4random_uniform(UInt32(Floor * 3))))
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
    
    func GetMonster(Type: Int = 1) -> [String]{
        let Gen: Int = Int(arc4random_uniform(UInt32(MonsterArray.count)))
        let TempArray: [String] = MonsterArray[Gen].components(separatedBy: ",")
        var Adjustment: Double = (Double(Floor) / 25).rounded(toPlaces: 1)
        if(Adjustment < 1){
            Adjustment = 1
        }
        let TempPower: String = String(Double(TempArray[1])! * Double(Type) * Double(AfterDeath) * Double(Floor) * 2 * Adjustment)
        let FinalResult: [String] = [TempArray[0], TempPower , TempArray[2]]
        return FinalResult
    }
    
    var Theme: String = ""
    
    func NormalEnemy(){
        CurrentMonster = GetMonster(Type: 1)
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        AdventureLog.text = "A " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel(EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        //TypeImage.image = UIImage(named: "Star.png")
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway), for: .touchUpInside)
    }
    
    func DisplayAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func FightEnemy(){
        let Damage: Double = HandleBattle()
        
        CurrentHP -= Damage
        if(CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            Dead()
        }
        else{
            let LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 200)))
            AdventureLog.text = "You slayed the beast! You looted the body and gained " + CutLabel(LootedGold) + "G."
            Gold += LootedGold
            MaxHP += (MaxHP * (10/100)).rounded(toPlaces: 0)
            SetLabels()
            if(isSquirrelFight){
                AdventureLog.text = AdventureLog.text + "\n" + "After slaying the squirrel you can feel the burn on your face fade away. It seems you have bested the squirrels... For now..."
                SquirrelMark = false
                defaults.set(false, forKey: "SquirrelMark")
            }
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 75){
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
        default:
            return UIImage(named:"Dagger.png")!
        }
    }
    
    func EnhancedEnemy(){
        CurrentMonster = GetMonster(Type: 2)
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        AdventureLog.text = "A giant " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Star.png")
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway), for: .touchUpInside)
    }
    
    func Boss(){
        CurrentMonster = GetMonster(Type: 4)
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 420
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        AdventureLog.text = "A boss ranked " + CurrentMonster[0] + " emerges from the shadows in front of you." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Crown.png")
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away!", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway_FullLoss), for: .touchUpInside)
    }
    
    var isSquirrelFight: Bool = false
    
    func SquirrelBattle(){
        CurrentMonster = ["Squirrel", String(600 * Floor * AfterDeath * 4), "3"]
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        isSquirrelFight = true
        AdventureLog.text = "The Squirrel has found you!" + "\n" + "Power: " + CutLabel(EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away!", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway_FullLoss), for: .touchUpInside)
    }
    
    func MimicBattle(MimicName: String = "Mimic"){
        CurrentMonster = [MimicName, String(150 * Floor * AfterDeath), "2"]
        AdventureLog.text = "It was a mimic!" + "\n" + "Power: " + CutLabel(Double(CurrentMonster[1]) ?? 420)
        
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway), for: .touchUpInside)
    }
    
    func HandleBattle() -> Double{
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 0
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
        
        //Warrior over Ranger, Ranger over Mage, Mage over Ranger.
        //If class adavantage exists, winning side gets additional quarter power.
        if (Class == 0 && EnemyClass == 1 || Class == 1 && EnemyClass == 2 || Class == 2 && EnemyClass == 0){
            ClassAdjust = PlayerPower / 10  }
        if (Class == 1 && EnemyClass == 0 || Class == 2 && EnemyClass == 1 || Class == 0 && EnemyClass == 2){
            BadAdjust = EnemyPower / 10 }
        

        EnemyPower += BadAdjust;
        PlayerPower += ClassAdjust;
        
        var Adjustment: Double = 1;
        if (PlayerPower > EnemyPower * 2){
            Adjustment = 10
        }else{
            Adjustment = 5  }
        
        if (PlayerPower >= EnemyPower){
            Damage = ((EnemyPower / 5) + (PlayerPower - EnemyPower)) / Adjustment
        }else{
            Damage = ((EnemyPower / 5) + (EnemyPower - PlayerPower)) / 5    }
        
        //If Enemy power is greater than the players power add 25%.
        if (EnemyPower > PlayerPower){
            Damage += Damage / 4}
        if (EnemyPower > PlayerPower * 5){
            Damage = MaxHP}

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
        LoadChances()
        }
        
        if(isEvent){
            MainImage.image = UIImage(named: "Curse.png")
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
                Power += Power * (5 / 100)
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
        }else if(Gen >= 50 && Gen < 60){
            FindSquirrel()
        }else if(Gen >= 60 && Gen < 70 && Floor > 15){
            FindHell()
        }else if(Gen >= 70 && Gen < 80){
            FindHotSpring()
        }else if(Gen >= 80 && Gen < 95){
            FindOldHag()
        }else if(Gen >= 95 && Gen < 105 && !isConfused){
            ConfusionCurse()
        }else if(Gen >= 105 && Gen < 110){
            EncounterGilgamesh()
        }else{
            FindDeadBody()
        }
    }
    
    func EncounterGilgamesh(){
        var Adjustment: Double = (Double(Floor) / 25).rounded(toPlaces: 1)
        if(Adjustment < 1){
            Adjustment = 1
        }
        CurrentMonster = ["Gilgamesh", String(1000 * Double(Floor) * 4 * Double(AfterDeath) * Adjustment), "0"]
        var EnemyPower: Double = Double(CurrentMonster[1]) ?? 420
        if(isEasyMode){
            EnemyPower = EnemyPower / 2
        }
        AdventureLog.text = "The Great Gilgamesh appears before you, and challenges you to a duel." + "\n" + "Power: " + CutLabel( EnemyPower)
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        TypeImage.image = UIImage(named: "Crown.png")
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightGilgamesh), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away!", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway_NoLoss), for: .touchUpInside)
    }
    
    @IBAction func FightGilgamesh(){
        let Damage: Double = HandleBattle()
        
        CurrentHP -= Damage
        if(CurrentHP < 1){
            CurrentHP = 0
            SetLabels()
            Dead()
        }
        else{
            let LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 4000))) + 4000
            AdventureLog.text = "You defeated Gilgamesh! He rewards you with " + DoubleString(Input: LootedGold) + "G and a weapon!"
            GiveWeapon(SkipText: false, UseContainer: false, Total: 1, UseNext: false, isCursed: false)
            Gold += LootedGold
            MaxHP += (MaxHP * (20/100)).rounded(toPlaces: 0)
            SetLabels()
            let Gen: UInt32 = arc4random_uniform(100)
            if(Gen > 90){
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
        
        var coordinates: CGPoint = Top_Button.frame.origin
        TopButtonX = coordinates.x
        TopButtonY = coordinates.y
        
        coordinates = Bottom_Button.frame.origin
        BottomButtonX = coordinates.x
        BottomButtonY = coordinates.y
        
        Next()
    }
    
    func FindOldHag(){
        MainImage.image = UIImage(named: "Hag.png")
        AdventureLog.text = "An old hag walks up to you and demands all of your Gold."
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Fight Her", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightHag), for: .touchUpInside)
        
        if(Gold > 0){
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle("Give All Gold", for: .normal)
            Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: #selector(GiveAllGold), for: .touchUpInside)
        }else{
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle("Fight Her", for: .normal)
            Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: #selector(FightHag), for: .touchUpInside)
        }
    }
    
    let HagChanges: [String] = ["Ice Sorceress,200,2", "Fire Sorceress,250,2", "Succubus,220,2"]
    
    @IBAction func FightHag(_ Attacked: Bool = false){
        var Adjustment: Double = (Double(Floor) / 25).rounded(toPlaces: 1)
        if(Adjustment < 1){
            Adjustment = 1
        }
        
        let Gen: Int = Int(arc4random_uniform(UInt32(HagChanges.count)))
        let TempArray: [String] = HagChanges[Gen].components(separatedBy: ",")
        
        CurrentMonster = TempArray
        var EnemyPower: Double = (Double(CurrentMonster[1]) ?? 0) * Double(Floor) * Adjustment * 2
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
        
        if(hasESP && BattlePredict){
            let Damage: Double = HandleBattle()
            DisplayAlert(title: "Battle Prediction", message: "Possible damage: " + DoubleString(Input: Damage - (Damage / 25)) + " to " + DoubleString(Input: Damage + (Damage / 25)), button: "OK")
        }
        //TypeImage.image = UIImage(named: "Star.png")
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle!", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Run Away", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(RunAway), for: .touchUpInside)
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
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Loot Body", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(LootBody), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
    }
    
    func FindSquirrel(){
        MainImage.image = UIImage(named: "SmolSquirrel.png")
        AdventureLog.text = "As you're walking down a hall a squirrel walks up to you and looks up at you with hope in his eyes..."
        if(Potions > 0){
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle("Give it all of your potions", for: .normal)
            Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: #selector(DoSquirrelGood), for: .touchUpInside)
        }else{
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle("Kick it and walk away", for: .normal)
            Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: #selector(DoSquirrelBad), for: .touchUpInside)
        }
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Kick it and walk away", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(DoSquirrelBad), for: .touchUpInside)
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
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("...", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(SquirrelContinue), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("...", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(SquirrelContinue), for: .touchUpInside)
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

    func FindHell(){
        AdventureLog.text = "You feel a cold chill in the air..."
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Continue", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(EnterHell), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Turn Back", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
    }
    
    func FindBadMerchant(){
        CurrentProduct = GenProduct()
        MainImage.image = UIImage(named: "BadMerchant.png")
        if(CurrentProduct[0] == "Mystery Sack"){
            AdventureLog.text = "You come across a merchant selling a very mysterious sack! His offer is " + CurrentProduct[2] + "G."
        }else{
            AdventureLog.text = "You come across a merchant selling some goods, he's offering " + CurrentProduct[1] + "x " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "G."}
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Buy Product", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(DoBadMerchant), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateEventButton), for: .touchUpInside)
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
                SetLabels()
            case "Weapon":
                GiveWeapon(SkipText: true, UseContainer: false, Total: Int(CurrentProduct[1]) ?? 1)
                SetLabels()
            case "Mystery Sack":
                GiveMysterySack()
            default:
                GivePotion(SkipText: true, UseContainer: false, Total: Double(CurrentProduct[1]) ?? 1)
                SetLabels()
            }
        }
        Next()
    }
    
    func FindHotSpring(){
        MainImage.image = UIImage(named: "Hotspring.png")
        AdventureLog.text = "You find a hot spring and take a quick dip." + "\n" + "You feel refreshed!";
        CurrentHP += CurrentHP / 10
        if (CurrentHP > MaxHP){
            CurrentHP = MaxHP}
        SetLabels()
        Next()
    }
    
    func FindTrap()
    {
        MainImage.image = UIImage(named: "Trap.png")
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
    AdventureLog.text = "You are walking through a hallway when all of a sudden you feel a tug at your foot. You look down and a goblin has grabbed you from a hole in the wall. You try to get away but it drags you into the hole, and knocks you out. When you awake you find some of your supplies missing.";
    }else{
    AdventureLog.text = "You notice a goblin trying to be sneaky as he snickers loudly from a hole in the wall. You walk out of arms reach on the other side of the hall.";
    }
        if (CurrentHP <= 0){
            Dead()
        }else{
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
            if(Gen > 75){
                StartBleeding()
            }
        
            if(Gen > 50){
                CurrentHP -= CurrentHP * (1/20)
            }
        }
        else
        {
            AdventureLog.text = "You sense something is off and you see a goblin across the room smirking at you. You jump backwards and fire an arrow right into the goblin. As he is dying he pulls a lever next to him, and the floor in front of you collapses into the darkness.";
        }
        if (CurrentHP <= 0){
            Dead()}
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
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Continue", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(GenerateHellEvent), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(GenerateHellEvent), for: .touchUpInside)
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
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Continue", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(DeathsRoom), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Continue", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(DeathsRoom), for: .touchUpInside)
    }
    
    @IBAction func DeathsRoom()
    {
        AdventureLog.text = "As you walk through the door, a wave of pure heat and evil bursts forth. You push through and at the end of the room you see a giant coffin. The coffin door collapses and from within it emerges Death himself. You drawn your " + GenWeaponType() + " and step forward. Thus it begins."
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Begin", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightDeath), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Begin", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(FightDeath), for: .touchUpInside)
    }
    
    @IBAction func FightDeath()
    {
        CurrentMonster = ["Death", String(666 * 4 * Double(AfterDeath) * Double(Floor)), "4"]
        MainImage.image = UIImage(named: Theme + "Death.png")
        ClassImage.image = UIImage(named: "Scythe.png")
        TypeImage.image = UIImage(named: "Crown.png")
        AdventureLog.text = "Death emerges from his coffin ready to battle." + "\n" + "Power: " + CurrentMonster[1]
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Battle", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(BattleDeath), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Battle", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(BattleDeath), for: .touchUpInside)
    }
    
    @IBAction func BattleDeath(){
        let Damage: Double = HandleBattle()
        CurrentHP -= Damage
        SetLabels()
        if (CurrentHP <= 0){
            HellDead()
        }else{
            DefeatDeath()
        }
    }
    
    @IBAction func DefeatDeath()
    {
        defaults.set(true, forKey: "hasKilledDeath")
        defaults.set(true, forKey: "HauntedUnlocked")
        MainImage.image = UIImage(named: "TreasureChest.png")
        AdventureLog.text = "You stand over Death victorious. You pick up Death's Sythe and with one great swing you slay Death with his own weapon. As you do so you once again feel your body and soul being ripped apart. But unlike last time it quickly fades. You look around and see a chest."
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Open Chest", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(DeathsTreasure), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("OpenChest", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(DeathsTreasure), for: .touchUpInside)
    }
    
    @IBAction func DeathsTreasure()
    {
        MainImage.image = UIImage(named: "QuestionMark_.png")
        ClassImage.image = nil
        TypeImage.image = nil
        AdventureLog.text = "You open the chest and are englufed in a flash of darkness. For what feels like forever you can't see anything. You call out, but your voices just echos and dies in the darkness..."
        DeathsTrap()
    }
    func DeathsTrap()
    {
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Give Up", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(GiveUp), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Call Out", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(CallOut), for: .touchUpInside)
    }
    
    @IBAction func GiveUp()
    {
        AdventureLog.text = "You give up on finding a way out of the darkness and let it engulf you. You can feel the power in the darkness, you understand more than ever what true power is." + "\n" + "And after what feels like an eternity in darkness, a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon..."
        Class = 4
        Power = Power * 2
        ClearBuffs()
        AfterDeath = 6
        //defaults.set(true, forKey: "PowerOfDarkness")
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        CurrentHP = (MaxHP / 4).rounded(toPlaces: 0)
        DisplayAlert(title: "Unlocked Character!", message: "You unlocked 'The Haunted' as a playable class!", button: "OK")
        Next()
    }
    
    @IBAction func CallOut()
    {
        AdventureLog.text = "You call out repeatedly, hundreds, thousands of times. Over and over and over again. The words quickly begin to mean less and less to you. Eventually your thoughts are of only escaping the darkness." + "\n" + "And after what feels like an eternity a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon... Or are you?"
        Class = 4
        Power = Power + (Power / 50)
        AfterDeath = 3
        CurseImmunity = true
        defaults.set(true, forKey: "isCrazy")
        
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        MainView.backgroundColor = UIColor.gray
        MainView.backgroundColor = UIColor(patternImage: scaled)
        CurrentHP = (MaxHP / 4).rounded(toPlaces: 0)
        DisplayAlert(title: "Unlocked Character!", message: "You unlocked 'The Haunted' as a playable class!", button: "OK")
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
        HellNext()
    }
    
    func HellBattle(isDeath: Bool = false)
    {
        CurrentMonster = GetHellMonster()
        //let EnemyPower: Double = Double(CurrentMonster[1])!
        
        //CurrentMonster = { Monster[0], EnemyPower.ToString(), Monster[2] }
        MainImage.image = UIImage(named: Theme + CurrentMonster[0] + ".png")
        ClassImage.image = GenClassImage(Class: CurrentMonster[2])
        AdventureLog.text = "The wall in front of you starts oozing blood. As it falls and hits the ground it takes the form of a demonic " + CurrentMonster[0] + "\n" + "Enemy Power: " + CurrentMonster[1]
        
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Fight Enemy", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(FightHellEnemy), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Fight Enemy", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(FightHellEnemy), for: .touchUpInside)
    }
    
    func GetHellMonster() -> [String]
    {
        let Gen: Int = Int(arc4random_uniform(UInt32(MonsterArray.count)))
        let TempArray: [String] = MonsterArray[Gen].components(separatedBy: ",")
        let TempPower: String = String(Double(TempArray[1])! * 20 * Double(AfterDeath) * Double(Floor))
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
            HellDead()
        }
        else{
            let LootedGold: Double = Double(arc4random_uniform(UInt32(Floor * 2000)))
            AdventureLog.text = "You slayed the beast! You looted the body and gained " + DoubleString(Input: LootedGold) + "G."
            Gold += LootedGold
            MaxHP += (MaxHP * (20/100)).rounded(toPlaces: 0)
            SetLabels()
            HellNext()
        }
    }
    
    func HellMerchant(alive: Bool = false)
    {
        if (alive)
        {
            MainImage.image = UIImage(named: "Merchant.png")
            CurrentProduct = HellGenProduct()
            
            if (CurrentProduct[0] == "Nothing"){
            AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he doesn't have any goods though..."
            }else{
                AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he wants to sell you " + CurrentProduct[1] + "x " + CurrentProduct[0] + "(s) for " + CurrentProduct[2] + "g."}
            
            Top_Button.removeTarget(nil, action: nil, for: .allEvents)
            Top_Button.setTitle("Deal", for: .normal)
            Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Top_Button.addTarget(self, action: #selector(HellDoMerchant), for: .touchUpInside)
            
            
            Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
            Bottom_Button.setTitle("Continue", for: .normal)
            Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            Bottom_Button.addTarget(self, action: #selector(GenerateHellEvent), for: .touchUpInside)
            
            if (CurrentProduct[0] == "Nothing"){
                HellNext()}
        }
        else
        {
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
        AdventureLog.text = "You find a chest and as soon as you try to open it, it turns into sand right as you reach for it..."
        HellNext()
    }
    
    func HellDoNothing()
    {
        AdventureLog.text = "Nothing is here but the screams of forgotten souls..."
        HellNext()
    }
    
    func HellResetFloor()
    {
        AdventureLog.text = "A strong force makes you fly back to the beginning of the floor!"
        HellFloorTenths = 0
        HellNext()
    }
    
    func HellDead()
    {
        MainImage.image = UIImage(named: "Dead.png")
        AdventureLog.text = "You died!" + "\n" + "You can feel your soul tugging away..."
        Top_Button.removeTarget(nil, action: nil, for: .allEvents)
        Top_Button.setTitle("Well Shucks...", for: .normal)
        Top_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Top_Button.addTarget(self, action: #selector(ReturnHome), for: .touchUpInside)
        
        
        Bottom_Button.removeTarget(nil, action: nil, for: .allEvents)
        Bottom_Button.setTitle("Fight Back!", for: .normal)
        Bottom_Button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        Bottom_Button.addTarget(self, action: #selector(HellRevive), for: .touchUpInside)
    }
    
    @IBAction func ReturnHome()
    {
        AdventureLog.text = "You feel your soul letting go. Everything goes black. When you awake you are back in the dungeon. Was it all a dream?"
        let image = UIImage(named: "Bricks.png")
        let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        
        MainView.backgroundColor = UIColor(patternImage: scaled)
        MainImage.image = UIImage(named: "QuestionMark_.png")
        CurrentHP = MaxHP / 4
        Next()
    }
    
    @IBAction func HellRevive()
    {
        AdventureLog.text = "You try to muster up the power to get back up, but fail. You collapse and everything goes black. When you wake, you are back where you first came into this strange land..."
        HellFloorTenths = 0
        HellFloor = 0
        CurrentHP = 1
        HellNext()
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
