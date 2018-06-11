//
//  ViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 04/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

var monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
var daysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = 0
var currentYear: Int = 0

class ViewController: UIViewController {

    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonth = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        updateUI()

    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        currentMonth += 1
        if currentMonth > 11{
            currentYear += 1
            currentMonth = 0
        }
        updateUI()
        
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth < 0 {
            currentYear -= 1
            currentMonth = 11
        }
        updateUI()
    }
    
    func updateUI() {
        let month = monthsArray[currentMonth]
        monthYearLabel.text = "\(month) \(currentYear)"
    }
    
}

