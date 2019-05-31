//
//  CharacterCreation2.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/21/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit

class CharacterCreation2: UIViewController {
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var Adjustments: Int = 10
    var HP: Int = 500
    var Power: Int = 50
    var Gold: Int = 150
    var Potions: Int = 10
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let image = UIImage(named: "Bricks.png")
        //let scaled = UIImage(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: image!.imageOrientation)
        //view.backgroundColor = UIColor(patternImage: scaled)
        ResetStats()
        SetStatLabels()
    }
    
    func SetStatLabels(){
        HP_Label.text = String(HP)
        Power_Label.text = String(Power)
        Gold_Label.text = String(Gold)
        Potions_label.text = String(Potions)
        Adjustments_Label.text = "Adjustments: " + String(Adjustments)
    }
    
    var Class: Int = 0
    
    func ResetStats(){
        Class = defaults.object(forKey: "Class") as! Int
        if(Class == 0){
            HP = 600
            Power = 150
            Gold = 100
            Potions = 10
            BaseHP = HP
        }
        if(Class == 1){
            HP = 450
            Power = 75
            Gold = 200
            Potions = 10
            BaseHP = HP
        }
        if(Class == 2){
            HP = 300
            Power = 50
            Gold = 150
            Potions = 15
            BaseHP = HP
        }
        if(Class == 3){
            HP = 10
            Power = 0
            Gold = 0
            Potions = 0
            Adjustments = 5
            BaseHP = -40
        }
        if(Class == 4){
            HP = 50
            Power = 50
            Gold = 7500
            Potions = 50
            Adjustments = 0
            BaseHP = 0
        }
        if(Class == 5){
            HP = 500
            Power = 500
            Gold = 500
            Potions = 500
            Adjustments = 0
            BaseHP = 500
        }
    }
    
    var BaseHP: Int = 0
    
    @IBAction func HP_Stepper_OnChange(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Click")
        if ( HP_Stepper.value == 0 && HP > (BaseHP - 50) && Class != 4 && Class != 5) {
            HP -= 25
            if(HP < 10){
                HP = 10
            }
            Adjustments += 1
        } else if (HP_Stepper.value == 2 && Class != 4 && Class != 5){ // else up
            if(Adjustments != 0)
            {
                HP += 25
                Adjustments -= 1
            }
        }
        HP_Stepper.value = 1; // reset
        SetStatLabels()
    }
    
    
    @IBAction func Power_Stepper_OnChange(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Click")
        if ( Power_Stepper.value == 0 && Power > 10 && Class != 4 && Class != 5) {
            Power -= 10
            Adjustments += 1
        } else if (Power_Stepper.value == 2 && Class != 4 && Class != 5){ // else up
            if(Adjustments != 0)
            {
                Power += 10
                Adjustments -= 1
            }
        }
        Power_Stepper.value = 1; // reset
        SetStatLabels()
    }
    
    @IBAction func Gold_Stepper_OnChange(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Click")
        if ( Gold_Stepper.value == 0 && Gold > 0 && Class != 4 && Class != 5) {
            Gold -= 25
            Adjustments += 1
        } else if (Gold_Stepper.value == 2 && Class != 4 && Class != 5){ // else up
            if(Adjustments != 0)
            {
                Gold += 25
                Adjustments -= 1
            }
        }
        Gold_Stepper.value = 1; // reset
        SetStatLabels()
    }
    
    @IBAction func Potions_Stepper_OnChange(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Click")
        if ( Potions_Stepper.value == 0 && Potions > 0 && Class != 4 && Class != 5) {
            Potions -= 1
            Adjustments += 1
        } else if (Potions_Stepper.value == 2 && Class != 4 && Class != 5){ // else up
            if(Adjustments != 0)
            {
                Potions += 1
                Adjustments -= 1
            }
        }
        Potions_Stepper.value = 1; // reset
        SetStatLabels()
    }
    
    @IBAction func Reset_Button(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Close")
        ResetStats()
        SetStatLabels()
        Adjustments = 10
        if(Class == 3){
            Adjustments = 5
        }else if (Class == 4){
            Adjustments = 0
        }else if(Class == 5){
            Adjustments = 0
        }
    }
    
    @IBAction func Finish_Button(_ sender: Any) {
        MusicPlayer().playSoundEffect(soundEffect: "Confirm")
        defaults.set(HP, forKey: "MaxHP")
        defaults.set(HP, forKey: "CurrentHP")
        defaults.set(Power, forKey: "Power")
        defaults.set(Gold, forKey: "Gold")
        defaults.set(Potions, forKey: "Potions")
        
        defaults.set(false, forKey: "SquirrelMark")
        defaults.set(false, forKey: "hasKilledDeath")
        defaults.set(false, forKey: "hasESP")
        defaults.set(false, forKey: "isCrazy")
        defaults.set(false, forKey: "isBleeding")
        defaults.set(false, forKey: "isConfused")
        defaults.set(0, forKey: "bleedingCounter")
        defaults.set(0, forKey: "confusionCounter")
        
        defaults.set(1, forKey: "Floor")
        defaults.set(1, forKey: "AfterDeath")
        defaults.set(false, forKey: "ReturnTrip")
        
        if(defaults.object(forKey: "HighestFloor") as? Int == nil){
            defaults.set(1, forKey: "HighestFloor")
        }
        
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

        if(Class == 0){
            defaults.set(2, forKey: "WeaponChance")
            defaults.set(2, forKey: "EnemyChance")
        }
        if(Class == 1){
            defaults.set(2, forKey: "FindItemChance")
        }
        if(Class == 2){
            defaults.set(-1, forKey: "CurseChance")
            defaults.set(1, forKey: "PotionChance")
        }
        if(Class == 3){
            
        }
        if(Class == 4){
            
        }
        
        defaults.set(false, forKey: "CC_Debug")
        defaults.set(false, forKey: "CC_Revive")
        defaults.set(false, forKey: "CC_Patreon")
        
        defaults.set(true, forKey: "hasCharacter")
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "MainPageSegue", sender: nil)
        })
    }
    
    /*
     CurseChance = 5
     EnemyChance = 18
     FindItemChance = 34
     MerchantChance = 10
     ElevatorChance = 3
     Fall = 3
     MiscEventChance = 9
     CampChance = 5
     BossChance = 2
     WeaponChance = 50
     GoldChance = 20
     PotionChance = 15
     CursedWeaponChance = 10
 */
    
    @IBOutlet weak var HP_Label: UILabel!
    @IBOutlet weak var Power_Label: UILabel!
    @IBOutlet weak var Gold_Label: UILabel!
    @IBOutlet weak var Potions_label: UILabel!
    @IBOutlet weak var Adjustments_Label: UILabel!
    
    @IBOutlet weak var HP_Stepper: UIStepper!
    @IBOutlet weak var Power_Stepper: UIStepper!
    @IBOutlet weak var Gold_Stepper: UIStepper!
    @IBOutlet weak var Potions_Stepper: UIStepper!
}
