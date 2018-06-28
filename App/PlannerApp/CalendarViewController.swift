//
//  CalendarViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 04/06/2018.
//
//
//  This is the viewcontroller that represenths the months of the year as a calendar in am UIView.

import UIKit
import Foundation

// Define the months
var monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

// Define months per day
var daysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = 0
var currentYear: Int = 0
var currentDay = 0
var startDay = 0
var currentWeekDay = 0
var startMonth = 0
var startYear = 0
var highLightedCell: String!

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var temp = [String]()
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    @IBOutlet weak var goToDateButton: UIButton!
    
    var newDate: Date!
    
    var month: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftButton.isEnabled = false                   // Disable left button for start month
        leftButton.isHidden = true                     // Hide left button for start month
        goToDateButton.isHidden = true                 // Hide the go to date button
        currentMonth = Calendar.current.component(.month, from: Date()) - 1   // Define current calender month
        currentYear = Calendar.current.component(.year, from: Date())        // Define current calender year
        startYear = Calendar.current.component(.year, from: Date())          // Define calender start year
        startMonth = Calendar.current.component(.month, from: Date()) - 1   // Define calender start month
        currentWeekDay = Calendar.current.component(.weekday, from: Date()) - 1  // Define weekday of current date
        currentDay = Calendar.current.component(.day, from: Date())              // Define the day of todau
        startDay = (7 + currentWeekDay - (currentDay - 1)%7)%7                  // Calculate at what day the month starts
        updateUI()                                                              // Update the view

    }
    /// Go to net month when right button is pressed
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        // Calculate starting date of the next month
        startDay = (startDay + daysPerMonth[currentMonth]%7)%7
        // Increase month by one
        currentMonth += 1
        // If december, go to january and increse year by one
        if currentMonth > 11{
            currentYear += 1
            currentMonth = 0

        }
        // Enable and unhide left button
        leftButton.isEnabled = true
        leftButton.isHidden = false
        // Hide go to date button (no date is selected, when going to next month)
        goToDateButton.isHidden = true
        // Update collection view
        updateUI()
        
    }
    
    /// Go to prior month when left button is pressed
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        // Decrease current month by one
        currentMonth -= 1
        // If it is januari, go to december and decrease year by one
        if currentMonth < 0 {
            currentYear -= 1
            currentMonth = 11
        }
        // calculate the starting day of the new month
        startDay = (7 + startDay - daysPerMonth[currentMonth]%7)%7
        
        // If on current month, don't allow user to go back
        if (currentMonth == startMonth && currentYear == startYear) {
            leftButton.isEnabled = false
            leftButton.isHidden = true
        }
        // Hide go to date button (no date is selected, when going to prior month)
        goToDateButton.isHidden = true
        // Update the views
        updateUI()
    }
    
    /// Updtes the collection view for chosen month
    func updateUI() {
        temp.removeAll()
        
        // Show empty boxes until the starting day
        if startDay > 0 {
            for _ in 1...startDay {
                temp.append(" ")
            }
        }
        
        // Retrieve array representing the date, account for leap years
        if (currentMonth == 2 && (currentYear%4) == 0) {
            for index in 1...29 {
                temp.append("\(index)")
            }
        } else {
            for index in 1...daysPerMonth[currentMonth] {
                temp.append("\(index)")
            }
        }
        // Define current month
        month = monthsArray[currentMonth]
        // Display month in text above the page
        monthYearLabel.text = "\(month!) \(currentYear)"
        // Reload collection view
        collectionVIew.reloadData()
    }
    
    /// Give the amount of cells in collectionview as days in the current month + the empty boxes until starting day
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.temp.count
    }
    
    /// Update the colletion view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        // Give each cell an apropriate label
        cell.dateLabel.text = self.temp[indexPath.item]
        
        cell.backgroundColor = UIColor.blue                             // Set cell background to blue
        cell.layer.borderColor = UIColor.black.cgColor                  // Set cell border to black
        cell.layer.borderWidth = 1                                      // Define the border with
        cell.layer.cornerRadius = 8                                     // Make the cell round
 
        
        return cell
    }
    
    /// update the size of each cell, so that 7 cells fit the screen
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width                    // Define the width of the screen
        let scaleFactor = (screenWidth / 8) - 6                         // Define scaling factor
            
        return CGSize(width: scaleFactor, height: scaleFactor)          // Define 7 cells per width
    }
    
    
    /// Highligth a cell when selected
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
    
        // If selected cell is a date highlight red, if already highlighted make blue again
        if indexPath.item > startDay - 1 {
            if cell?.backgroundColor == UIColor.red {
                cell?.backgroundColor = UIColor.blue
                // Dhow the go to date button when date is selected
                goToDateButton.isHidden = true
            } else {
                for cell in collectionView.visibleCells as [UICollectionViewCell] {
                    cell.backgroundColor = UIColor.blue
                }
                cell?.backgroundColor = UIColor.red
                // If no cell highlighted, hide go to date button
                goToDateButton.isHidden = false
            }
        }
        // Determine highlighted cell
        highLightedCell = self.temp[indexPath.item]
    }
    
    /// Prepare for segue to planner
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        
        let formatter = DateFormatter()                                         // Call date formatter
        // Set locale, the app doesn't screw up when used with foreign phones
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.dateStyle = .medium                                           // Define the date formate
        formatter.timeStyle = .none                                             // Do not define time
        let currentDate = "\(month!) \(highLightedCell!), \(currentYear)"       // make a label with the current date
        newDate = formatter.date(from: currentDate)                             // get date from label, to pass on to plannerViewController

        super.prepare(for: segue, sender: sender)
        
    }
    
}

/// define screenwidth var, to use for getting 7 cells per view
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
