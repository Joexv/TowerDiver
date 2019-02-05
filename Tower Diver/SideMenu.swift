//
//  SideMenu.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/26/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyStoreKit
import StoreKit

class SideMenu: UITableViewController {
    
    var HighestFloor: Int = 0
    var Potions: Double = 0
    var CurrentHP: Double = 0
    var MaxHP: Double = 0
    var hasESP: Bool = false
    var BattlePredict: Bool = false
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        ReadStats()
    }
    
    func ReadStats(){
        HighestFloor = defaults.object(forKey: "HighestFloor") as! Int
        Potions = defaults.object(forKey: "Potions") as! Double
        CurrentHP = defaults.object(forKey: "CurrentHP") as! Double
        MaxHP = defaults.object(forKey: "MaxHP") as! Double
        hasESP = defaults.object(forKey: "hasESP") as! Bool
        BattlePredict = defaults.bool(forKey: "BattlePredict")
        BattleSwitch.isOn = BattlePredict
        BattleSwitch.isEnabled = hasESP
        FloorLabel.setTitle(String(HighestFloor), for: .normal)
    }
    
    @IBAction func HighestFloor_Button(_ sender: Any) {
        var TempString: String = "Class: " + (defaults.string(forKey: "HF_Class") ?? "Warrior")
        TempString = TempString + "\n" + "Power: " + (defaults.string(forKey: "HF_Power") ?? "420")
        
        if(defaults.bool(forKey: "HF_KilledDeath")){
            TempString = TempString + "\n" + "Had killed Death."
        }
        if(defaults.bool(forKey: "HF_SquirrelMark")){
            TempString = TempString + "\n" + "Had the Mark of The Squirrel"
        }
        DisplayAlert(title: "Best Tower Diver", message: TempString, button: "OK")
    }
    
    func PullInt(Buff: String) -> Int{
        let result = defaults.object(forKey: Buff)
        return result as? Int ?? 0
    }
    
    func DisplayAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func Alert(_ message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //@IBOutlet weak var Floor_label: UILabel!
    @IBOutlet weak var FloorLabel: UIButton!
    
    
    @IBAction func Predict_Button(_ sender: Any) {
        if(hasESP && Potions >= 1){
            ReadStats()
            Potions -= 1
            SaveStats()
            let Total: Int = Int(LoadChances())
            
            CurseChance = 10
            EnemyChance = 25
            FindItemChance = 35
            MerchantChance = 13
            ElevatorChance = 2
            FallChance = 2
            MiscEventChance = 14
            CampChance = 6
            
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
            
            CurseChance = Total / CurseChance
            EnemyChance = Total / EnemyChance
            FindItemChance = Total / FindItemChance
            MerchantChance = Total / MerchantChance
            ElevatorChance = Total / ElevatorChance
            FallChance = Total / FallChance
            CampChance = Total / CampChance
            MiscEventChance = Total / MiscEventChance
            
            var PredictionString: String = "Curses " + String(CurseChance) + "%" + "\n"
            PredictionString = PredictionString + "Enemies " + String(EnemyChance) + "%" + "\n"
            PredictionString = PredictionString + "Items " + String(FindItemChance) + "%" + "\n"
            PredictionString = PredictionString + "Merchants " + String(MerchantChance) + "%" + "\n"
            PredictionString = PredictionString + "Elevators " + String(ElevatorChance) + "%" + "\n"
            PredictionString = PredictionString + "Floor Drops " + String(FallChance) + "%" + "\n"
            PredictionString = PredictionString + "Camp Grounds " + String(CampChance) + "%" + "\n"
            PredictionString = PredictionString + "Misc Events " + String(MiscEventChance) + "%" + "\n"
            DisplayAlert(title: "Predictions", message: PredictionString, button: "OK")
        }else{
            DisplayAlert(title: "Predictions", message: "You do not have the powers or resources to use this.", button: "OK")
        }
    }
    
    @IBAction func HealFull_Button(_ sender: Any) {
        if(Potions < 8){
            DisplayAlert(title: "", message: "You need 8 potions to heal to full HP!", button: "OK")
        }else{
            if(CurrentHP < MaxHP){
                defaults.set(true, forKey: "TempPotionCheck")
                SaveStats()
                dismiss(animated: true, completion: nil)
                //DisplayAlert(title: "", message: "HP healed to full!", button: "OK")
            }else{
                DisplayAlert(title: "", message: "You are at full health no need to heal.", button: "OK")
            }
        }
    }
    
    func Save(Input: Any, Key: String){
        defaults.set(Input, forKey: Key)
    }
    
    
    func SaveStats(){
        Save(Input: MaxHP, Key: "MaxHP")
        Save(Input: CurrentHP, Key: "CurrentHP")
        Save(Input: Potions, Key: "Potions")
        Save(Input: BattlePredict, Key: "BattlePredict")
        //Save(Input: HighestFloor, Key: "HighestFloor")
    }
    
    @IBAction func DisplayCurses_Button(_ sender: Any) {
    }
    
    @IBAction func Restart_Button(_ sender: Any) {
        defaults.set(true, forKey: "RestartCharacter")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Return_Button(_ sender: Any) {
        SaveStats()
        defaults.set(true, forKey: "ReturnToTitle")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func BattlePredict_Switch(_ sender: Any) {
            defaults.set(BattleSwitch.isOn, forKey: "BattlePredict")
    }
    @IBOutlet weak var BattleSwitch: UISwitch!
    
    @IBAction func Report_Button(_ sender: Any) {
        let url = URL(string: "https://github.com/Joexv/TowerDiver/issues/new")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func Wiki_Button(_ sender: Any) {
        let url = URL(string: "http://towerdiver.wikidot.com/")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
        
    }
    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    @IBAction func About_Button(_ sender: Any) {
        DisplayAlert(title: "Info", message: "v" + Version + " - Alpha" + "\n" + "Made by Joe Oliveira" + "\n" + "With help from Joseph Mooney" + "\n" + "For a full list of credits check out our wiki page!", button: "OK")
    }
    

    
    @IBAction func Donate_Button(_ sender: Any) {
        let alert = UIAlertController(title: "Donate?", message: "Would you like to donate $1? Each donation adds 5000 Power, Gold and HP along with 50 potions, to your current character.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.DoBuy2()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //This is unused to avoid Apple denying the app due to linking to out of AppStore Payment options
    /*
    func OldDonate(){
        let alert = UIAlertController(title: "Donate?", message: "Would you like to go to our Patreon page and support our coffee adictions?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Not Today", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Me To Patreon!", style: .default, handler: { action in
            self.GotoDonation()
        }))
        alert.addAction(UIAlertAction(title: "Donate Through The AppStore!", style: .default, handler: { action in
            self.DoBuy()
        }))
        self.present(alert, animated: true, completion: nil)
    }
 
    func DoBuy(){
        let alert = UIAlertController(title: "Donate?", message: "Would you like to donate $1? Each donation adds 5000 Power and Gold to your current character.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.DoBuy2()
        }))
    }
     
     func GotoDonation(){
     let url = URL(string: "https://www.patreon.com/Joexv")
     let svc = SFSafariViewController(url: url!)
     present(svc, animated: true, completion: nil)
     }
    */
    
    func DoBuy2(){
        if(SKPaymentQueue.canMakePayments())
        {
            //DisplayAlert(title: "Alert", message: "Cannot buy products while testing", button: "OK")
            self.BuyProd()
        }else{
            DisplayAlert(title: "Error", message: "Cannot make purchases on this device!", button: "OK")
        }
    }
    
    @IBAction func Theme_Button(_ sender: Any) {
        let alert = UIAlertController(title: "Monster Theme", message: "Select what theme you would like the monsters' portaits to appear as:", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Hand Drawn", style: .default, handler: { action in
            self.defaults.set("", forKey: "MonsterTheme")
        }))
        //Disabled Until fully completed. I would rather not use other people's pixel art for this as it styles are vastly different.
        /*
        alert.addAction(UIAlertAction(title: "Pixel Art", style: .default, handler: { action in
           self.defaults.set("Pixel_", forKey: "MonsterTheme")
        }))
         */
        alert.addAction(UIAlertAction(title: "Stick Figures", style: .default, handler: { action in
            self.defaults.set("Stick_", forKey: "MonsterTheme")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func BuyProd(){
        //var productIdentifiers = Set<ProductIdentifier>()
        //productIdentifiers.insert("Boi_I_Dont_Like_Ads")
        
        SwiftyStoreKit.purchaseProduct("Generous_Donation", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "DonationAddition")
            case .error(let error):
                switch error.code {
                case .unknown: self.Alert("Unknown error. Please contact support")
                case .clientInvalid: self.Alert("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: self.Alert("The purchase identifier was invalid")
                case .paymentNotAllowed: self.Alert("The device is not allowed to make the payment")
                case .storeProductNotAvailable: self.Alert("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: self.Alert("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: self.Alert("Could not connect to the network")
                case .cloudServiceRevoked: self.Alert("User has revoked permission to use this cloud service")
                }
            }
        }
    }
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        EnemyChance = 18
        FindItemChance = 34
        MerchantChance = 10
        ElevatorChance = 3
        FallChance = 3
        MiscEventChance = 9
        CampChance = 5
        
        EnhancedChance = 4
        BossChance = 2
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
        //DisplayAlert(title: "test", message: String(MiscEventChance), button: "OK")
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
}
