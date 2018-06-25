//
//  ViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 04/06/2018.
//  Code inspired by: https://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
//

import UIKit
import Foundation

var monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
var daysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = 0
var currentYear: Int = 0
var currentDay = 0
var startDay = 0
var currentWeekDay = 0
var startMonth = 0
var startYear = 0
var highLightedCell: String!

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let formatter = DateFormatter()
    
    let numberOfCellsPerRow: CGFloat = 6

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
        leftButton.isEnabled = false
        leftButton.isHidden = true
        goToDateButton.isHidden = true
        currentMonth = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        startYear = Calendar.current.component(.year, from: Date())
        startMonth = Calendar.current.component(.month, from: Date()) - 1
        currentWeekDay = Calendar.current.component(.weekday, from: Date()) - 1
        currentDay = Calendar.current.component(.day, from: Date())
        startDay = (7 + startDay - (currentDay - 1)%7)%7
        print("Startday is: \(startDay)")
        print(currentWeekDay)
        print(startDay)
        print(currentMonth)
        print(currentYear)
        print(currentWeekDay)
        print(currentDay)

        
        updateUI()

    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        startDay = (startDay + daysPerMonth[currentMonth]%7)%7
        print("Startday is: \(startDay)")
        currentMonth += 1
        if currentMonth > 11{
            currentYear += 1
            currentMonth = 0

        }
        leftButton.isEnabled = true
        leftButton.isHidden = false
        goToDateButton.isHidden = true
        updateUI()
        
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth < 0 {
            currentYear -= 1
            currentMonth = 11
        }
        startDay = (7 + startDay - daysPerMonth[currentMonth]%7)%7
        if (currentMonth == startMonth && currentYear == startYear) {
            leftButton.isEnabled = false
            leftButton.isHidden = true
        }
        goToDateButton.isHidden = true
        updateUI()
    }
    
    func updateUI() {
        temp.removeAll()
        if startDay > 0 {
            for _ in 1...startDay {
                temp.append(" ")
            }
        }
        for index in 1...daysPerMonth[currentMonth] {
            temp.append("\(index)")
        }
        month = monthsArray[currentMonth]
        monthYearLabel.text = "\(month!) \(currentYear)"
        collectionVIew.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.temp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.dateLabel.text = self.temp[indexPath.item]
        
        
        cell.backgroundColor = UIColor.blue
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
 
        
        
        //let size = CGSize(width: self.view.frame.width/7, height: self.view.frame.width/10)
        //cell.sizeThatFits(size)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.temp[indexPath.item])

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 8) - 6
            
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
    
        if indexPath.item > startDay - 1 {
            if cell?.backgroundColor == UIColor.red {
                cell?.backgroundColor = UIColor.blue
                goToDateButton.isHidden = true
            } else {
                for cell in collectionView.visibleCells as [UICollectionViewCell] {
                    cell.backgroundColor = UIColor.blue
                }
                cell?.backgroundColor = UIColor.red
                goToDateButton.isHidden = false
            }
        }
        highLightedCell = self.temp[indexPath.item]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let currentDate = "\(month!) \(highLightedCell!), \(currentYear)"
        newDate = formatter.date(from: currentDate)
        
        print(newDate)
        
        super.prepare(for: segue, sender: sender)
        
    }
    
}
