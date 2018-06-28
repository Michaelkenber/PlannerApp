//
//  SelectTransportTypeTableViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// This is the viewcontroller where a user can select the transport type

import UIKit


protocol SelectTransportTypeTableViewControllerDelegate {
    func didSelect(transportType: TransportType)
}

class SelectTransportTypeTableViewController: UITableViewController {
    
    var delegate: SelectTransportTypeTableViewControllerDelegate?
    var transportType: TransportType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // One section in tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Return the rows for each transport type
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransportType.all.count
    }

    /// Give each row a name and a checkmark if selected
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransportTypeCell", for: indexPath)
        let transportType = TransportType.all[indexPath.row]
        
        cell.textLabel?.text = transportType.name
        
        if transportType == self.transportType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    /// Define the transport type as the cell that is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transportType = TransportType.all[indexPath.row]
        delegate?.didSelect(transportType: transportType!)
        tableView.reloadData()
    }
}

