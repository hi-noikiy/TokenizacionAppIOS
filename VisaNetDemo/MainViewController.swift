//
//  MainViewController.swift
//  VisaNetDemo
//
//  Created by Luis Perez on 8/30/18.
//  Copyright © 2018 VisaNet. All rights reserved.
//

import UIKit
import VisaNetSDK

class MainViewController: UIViewController {
    
    @IBOutlet weak var CESwitch: UISwitch!
    @IBOutlet weak var SPSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
   

    @IBAction func formSwitchValueChanged(_ formSwitch: UISwitch) {
        switch formSwitch {
        case self.CESwitch:
            self.SPSwitch.isOn = !self.CESwitch.isOn
        case self.SPSwitch:
            self.CESwitch.isOn = !self.SPSwitch.isOn
        default:
            break
        }
    }
    
    @IBAction func startDemoAction(_ sender: UIButton) {
        if CESwitch.isOn {
            performSegue(withIdentifier: "toCE", sender: nil)
        }
        else {
            performSegue(withIdentifier: "toSP", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCE" {
            segue.destination.title = "Comercio Electrónico"
        }
        else {
            segue.destination.title = "Pago Programado"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

