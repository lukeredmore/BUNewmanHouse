//
//  ModalPickerViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 8/11/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

protocol AlertTimePickerDelegate: class {
    func pickerDidSelectAlertTime(inMinutes time: Int)
}

///Modal VC where both the notification delivery time and day override can be picked
final class ModalPickerViewController: ModalMenuViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dayPicker: UIPickerView!
    weak var alertTimePickerDelegate: AlertTimePickerDelegate?
    
    let alertTimeOptions = [
        AlertTimeOptionsModel(int: 10080, label: "1 week before"),
        AlertTimeOptionsModel(int: 2880, label: "2 days before"),
        AlertTimeOptionsModel(int: 1440, label: "1 day before"),
        AlertTimeOptionsModel(int: 120, label: "2 hours before"),
        AlertTimeOptionsModel(int: 60, label: "1 hour before"),
        AlertTimeOptionsModel(int: 30, label: "30 minutes before"),
        AlertTimeOptionsModel(int: 15, label: "15 minutes before"),
        AlertTimeOptionsModel(int: 5, label: "5 minutes before"),
        AlertTimeOptionsModel(int: 0, label: "At time of event")]
    
    //MARK: Init Methods
    internal static func instantiate(delegate : AlertTimePickerDelegate) -> ModalPickerViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalPickerViewScene") as! ModalPickerViewController
        vc.alertTimePickerDelegate = delegate
        return vc
    }
    
    
    //MARK: View Control
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView(menuView)
        dayPicker.delegate = self
        dayPicker.dataSource = self
    }
    override func passBackData() { //called before view disappears
        alertTimePickerDelegate?.pickerDidSelectAlertTime(inMinutes: alertTimeOptions[dayPicker.selectedRow(inComponent: 0)].int)
    }

    //MARK: Delegate Methods For Day Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alertTimeOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        alertTimeOptions[row].label
    }
}

struct AlertTimeOptionsModel {
    let int: Int
    let label: String
}
