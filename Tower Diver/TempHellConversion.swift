//
//  TempHellConversion.swift
//  Tower Diver
//
//  Created by Joe Oliveira on 12/27/18.
//  Copyright © 2018 Alternative Apps Unlimited. All rights reserved.
//

import Foundation


func EnterHell()
{
    this.BackgroundImage = UIImage(named: "HellBricks.png")
    AdventureLog.text = "You feel like your body and soul have just been ripped apart. Your vision starts to fade and you passout. When you awake you are no longer in the same dungeon. The walls are old and rotted away, and there's a foul scent in the air..."
    HellNext()
}

func HellNext()
{
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

func GenerateHellEvent()
{
    ClassImage.Image = null
    Console.WriteLine("Generating new event")
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    FixItems()
    if (HellFloorTenths <= 10)
    HellFloorTenths++
    else
    {
        HellFloor++
        HellFloorTenths = 1
    }
    SetLabels()
    if (HellFloor == 2 && HellFloorTenths >= 10)
    {
        DeathsDoor()
    }
    else
    {
        Random random = new Random(Environment.TickCount)
        int a = random.Next(0, 150)
        if (a >= 0 && a < 25)
        HellWinds()
        else if (a >= 25 && a < 50)
        HellBattle()
        else if (a >= 50 && a < 75)
        HellFindItem()
        else if (a >= 75 && a < 100)
        HellMerchant()
        else if (a >= 105)
        HellResetFloor()
        else if (a > 105 && a < 125)
        HellMerchant(true)
        else
        HellDoNothing()
    }
}

func DeathsDoor()
{
    AdventureLog.text = "You walk through a long hallway covered in bones and fire. At the end of the hall there's a door."
    
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    button1.Click += DeathsRoom
    button2.Click += DeathsRoom
    
    button1.Text = "Open The Door"
    button2.Text = "Open The Door"
}

func DeathsRoom()
{
    AdventureLog.text = "As you walk through the door, a wave of pure heat and evil bursts forth. You push through and at the end of the room you see a giant coffin. The coffin door collapses and from within it emerges Death himself. You drawn your " + GenWeapon(Class) + " and step forward. Thus it begins."
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    button1.Click += FightDeath
    button2.Click += FightDeath
    
    button1.Text = "Begin"
    button2.Text = "Begin"
}

func FightDeath()
{
    string[] Death = {"Death", "500", "4"}
    pictureBox1.Image = Image.FromFile(Images + "Death.png")
    pictureBox2.Image = Image.FromFile(Images + "Crown.png")
    pictureBox4.Image = Image.FromFile(Images + "Scythe.png")
    int Damage = HandleBattle(Death)
    Current_HP = Current_HP - Damage
    if (Current_HP <= 0)
    HellDead()
    else
    DefeatDeath()
}

func DefeatDeath()
{
    var parser = new FileIniDataParser()
    var data = parser.ReadFile("Character.ini")
    data["Stats"]["hasKilledDeath"] = "True"
    parser.WriteFile("Character.ini", data)
    
    AdventureLog.text = "You stand over Death victorious. You pick up Death's Sythe and with one great swing you slay Death with his own weapon. As you do so you once again feel your body and soul being ripped apart. But unlike last time it quickly fades. You look around and see a chest."
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    button1.Click += DeathsTreasure
    button2.Click += DeathsTreasure
    
    button1.Text = "Open Chest"
    button2.Text = "Open Chest"
}

func DeathsTreasure()
{
    pictureBox1.Image = Image.FromFile(Images + "QuestionMark_.png")
    pictureBox2.Image = null
    pictureBox4.Image = null
    AdventureLog.text = "You open the chest and are englufed in a flash of darkness. For what feels like forever you can't see anything. You call out, but your voices just echos and dies in the darkness..."
    DeathsTrap()
}
func DeathsTrap()
{
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    button1.Click += GiveUp
    button2.Click += CallOut
    
    button1.Text = "Give up"
    button2.Text = "Call out again"
}

func GiveUp()
{
    AdventureLog.text = "You give up on finding a way out of the darkness and let it engulf you. You can feel the power in the darkness, you understand more than ever what true power is." + Environment.NewLine + "And after what feels like an eternity in darkness, a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon..."
    Class = 4
    Power = Power * 2
    ClearDeBuffs()
    AfterDeath = 6
    var parser = new FileIniDataParser()
    var data = parser.ReadFile("Character.ini")
    data["Stats"]["PowerOfDarkness"] = "True"
    parser.WriteFile("Character.ini", data)
    
    this.BackgroundImage = Image.FromFile(Images + "Bricks.png")
    pictureBox1.Image = Image.FromFile(Images + "QuestionMark_.png")
    Current_HP = Max_HP / 4
    Next()
}

func CallOut()
{
    AdventureLog.text = "You call out repeatedly, hundreds, thousands of times. Over and over and over again. The words quickly begin to mean less and less to you. Eventually your thoughts are of only escaping the darkness." + Environment.NewLine + "And after what feels like an eternity a light shines trhough the darkness. The light slowly engulfs you with no hesitation. After a minute the light fades. You awake back in the dungeon... Or are you?"
    Class = 4
    Power = Power + (Power / 50)
    AfterDeath = 3
    CurseImmunity = true
    var parser = new FileIniDataParser()
    var data = parser.ReadFile("Character.ini")
    data["Stats"]["isCrazy"] = "True"
    parser.WriteFile("Character.ini", data)
    
    this.BackgroundImage = Image.FromFile(Images + "Bricks.png")
    pictureBox1.Image = Image.FromFile(Images + "QuestionMark_.png")
    Current_HP = Max_HP / 4
    Next()
}

public bool CurseImmunity = false
public int AfterDeath = 1

private void ClearBuffs()
{
    var parser = new FileIniDataParser()
    var data = parser.ReadFile("Character.ini")
    data["Buff"]["CurseChance"] = "0"
    data["Buff"]["EnemyChance"] = "0"
    data["Buff"]["FindItemChance"] = "0"
    data["Buff"]["MerchantChance"] = "0"
    data["Buff"]["ElevatorChance"] = "0"
    data["Buff"]["Fall"] = "0"
    data["Buff"]["CorpseChance"] = "0"
    data["Buff"]["WeaponChance"] = "0"
    data["Buff"]["GoldChance"] = "0"
    data["Buff"]["PotionChance"] = "0"
    data["Buff"]["CursedWeaponChance"] = "0"
    parser.WriteFile("Character.ini", data)
}

private void ClearDeBuffs()
{
    var parser = new FileIniDataParser()
    var data = parser.ReadFile("Character.ini")
    data["DeBuff"]["CurseChance"] = "0"
    data["DeBuff"]["EnemyChance"] = "0"
    data["DeBuff"]["FindItemChance"] = "0"
    data["DeBuff"]["MerchantChance"] = "0"
    data["DeBuff"]["ElevatorChance"] = "0"
    data["DeBuff"]["Fall"] = "0"
    data["DeBuff"]["CorpseChance"] = "0"
    data["DeBuff"]["WeaponChance"] = "0"
    data["DeBuff"]["GoldChance"] = "0"
    data["DeBuff"]["PotionChance"] = "0"
    data["DeBuff"]["CursedWeaponChance"] = "0"
    parser.WriteFile("Character.ini", data)
}

func HellWinds()
{
    AdventureLog.text = "A chilling yet burning hot wind hits you. You sense that something is angry..."
    Current_HP = Current_HP - (Current_HP / 20)
    HellNext()
}

func HellBattle(bool isDeath = false)
{
    string[] Monster = GetHellMonster()
    int EnemyPower = int.Parse(Monster[1])
    
    //CurrentMonster = { Monster[0], EnemyPower.ToString(), Monster[2] }
    pictureBox1.Image = Image.FromFile(Images + Monster[0] + ".png")
    pictureBox4.Image = Image.FromFile(GenClassImage(Monster[2]))
    AdventureLog.text = "The wall in front of you starts oozing blood. As it falls and hits the ground it takes the form of a demonic " + System.Environment.NewLine + "Enemy Power: " + Monster[1]
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    
    if (hasESP)
    {
        ESPBox.Visible = true
        ESPBox.Text = "Your ESP is failing you!"
    }
    
    button2.Click += FightHellEnemy
    button1.Click += FightHellEnemy
    
    button1.Text = "Battle!"
    button2.Text = "Battle!"
    
    CurrentMonster = Monster
}

private string[] GetHellMonster()
{
    var parser = new FileIniDataParser()
    //Can be changed to another monster.ini filled with only hell creatures.
    var data = parser.ReadFile("Monsters.ini")
    Random random = new Random()
    
    int a = random.Next(1, int.Parse(data["Monsters"]["Total"]) + 1)
    string MonsterString = data["Monsters"][a.ToString()]
    Console.WriteLine(MonsterString)
    string[] Monster = MonsterString.Split(',')
    string[] MonsterEdit = { Monster[0], (int.Parse(Monster[1]) * 20 * Floor).ToString(), Monster[2] }
    return MonsterEdit
}


func FightHellEnemy()
{
    int DamageDealt = HandleBattle(CurrentMonster)
    DropLabel.Visible = true
    DropLabel.Text = "-" + DamageDealt.ToString()
    MyAsyncMethod()
    Current_HP = Current_HP - DamageDealt
    
    if (Current_HP < 1)
    HellDead()
    else
    {
        pictureBox2.Image = null
        textBox1.AppendText("You won!")
        int MaxGold = Floor * 20000
        Random random = new Random(Environment.TickCount)
        int a = random.Next(1, MaxGold)
        Gold = Gold + a
        Max_HP = Max_HP + (Max_HP / 10)
        
        SetLabels()
        AdventureLog.text = "You slayed the beast!" + Environment.NewLine + "You looted the creature finding " + a.ToString() + "g!"
        HellNext()
    }
}

func HellMerchant(bool alive = false)
{
    if (alive)
    {
        pictureBox1.Image = UIImage(named: "Merchant.png")
        Console.WriteLine("That's a shop keep")
        CurrentProduct = GenProduct()
        
        if (CurrentProduct[0] == "Nothing")
        AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he doesn't have any goods though..."
        else
        AdventureLog.text = "You find a shop keep that's just barely holding onto life. It looks like he wants to sell you " + CurrentProduct[2] + "x " + CurrentProduct[0] + "(s) for " + CurrentProduct[1] + "g."
        
        RemoveClickEvent(button1)
        RemoveClickEvent(button2)
        button1.Click += GenerateHellEvent
        button2.Click += HellDoMerchant
        
        button1.Text = "Decline the offer"
        button2.Text = "Deal!"
        
        if (CurrentProduct[0] == "Nothing")
        HellNext()
    }
    else
    {
        AdventureLog.text = "You find what looks like the remains of some kind of shop keep..."
        HellNext()
    }
}

public string[] HellGenProduct()
{
    string Item = ""
    Random random = new Random(Environment.TickCount)
    int a = random.Next(0, PotionChance)
    Console.WriteLine(a)
    // a =  WeaponChance
    string Cost = random.Next(10000, 20000 * Floor).ToString()
    string Quantity = random.Next(1, 5).ToString()
    
    if (a >= 0 && a <= WeaponChance)
    {
        Item = "Weapon"
    }
    if (a > WeaponChance && a <= GoldChance)
    {
        Item = "Nothing"
        Quantity = "1"
    }
    if (a > GoldChance && a <= PotionChance)
    {
        Item = "Potion"
        Cost = random.Next(1, 200 * Floor).ToString()
    }
    
    string[] Result = { Item, Cost, Quantity }
    return Result
}

func HellDoMerchant()
{
    if (Gold < int.Parse(CurrentProduct[1]))
    {
        textBox1.AppendText(Environment.NewLine + "Looks like you don't have enough gold.")
        Next()
    }
    else
    {
        Gold = Gold - int.Parse(CurrentProduct[1])
        for (int i = 0 i < int.Parse(CurrentProduct[2]) i++)
        {
            switch (CurrentProduct[0])
            {
            case "Weapon":
                GiveHellWeapon()
                break
            case "Potion":
                FindHellPotion()
                break
            default:
                textBox1.AppendText("Nothing...")
                break
            }
        }
        RemoveClickEvent(button1)
        RemoveClickEvent(button2)
        HellNext()
    }
}

func FindHellPotion()
{
    int MaxPotions = Floor * 5
    Random random = new Random(Environment.TickCount)
    int a = random.Next(1, MaxPotions)
    Potions = Potions + a
    AdventureLog.text = "You got a " + ItemContainerGen() + " containing " + a.ToString() + " potion(s)!"
    HellNext()
}


func GiveHellWeapon(bool StopText = false)
{
    Console.WriteLine("You found a weapon.")
    Weapon_Amount++
    int MaxPower = Floor * 20000
    Random random = new Random(Environment.TickCount)
    int a = random.Next(1000, MaxPower)
    Power = Power + a
    Max_HP = Max_HP + 100
    if (StopText == false)
    AdventureLog.text = "You found a, " + GenWeapon(Class) + "! With a power of, " + a.ToString() + Environment.NewLine
    HellNext()
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
    AdventureLog.text = "A strong force makes you fly back to where you first awoke!"
    HellFloorTenths = 0
    HellFloor = 1
    HellNext()
}

func HellDead()
{
    pictureBox1.Image = UIImage(named: "Dead.png")
    AdventureLog.text = "You died!" + Environment.NewLine + "You can feel your soul tugging away..."
    RemoveClickEvent(button1)
    RemoveClickEvent(button2)
    button2.Click += HellRevive
    button1.Click += ReturnHome
    
    button1.Text = "Well shucks..."
    button2.Text = "Fight back!"
}

func ReturnHome()
{
    AdventureLog.text = "You feel your soul letting go. Everything goes black. When you awake you are back in the dungeon. Was it all a dream?"
    this.BackgroundImage = Image.FromFile(Images + "Bricks.png")
    pictureBox1.Image = Image.FromFile(Images + "QuestionMark_.png")
    Current_HP = Max_HP / 4
    Next()
}

func HellRevive()
{
    AdventureLog.text = "You try to muster up the power to get back up, but fail. You collapse and everything goes black. When you wake, you are back where you first came into this strange land..."
    HellFloorTenths = 0
    HellFloor = 0
    Current_HP = 1
    HellNext()
}
