//
//  DateTimeBoxVCtr.swift
//  BeautyNotes
//
//  Created by Sagar on 12/18/15.
//  Copyright © 2015 Sagar R. Kothari. All rights reserved.
//

import UIKit

@objc public protocol SRKDateTimeBoxDelegate : NSObjectProtocol {
    
    func dateTimeBox(textField:SRKDateTimeBox, didSelectDate date:NSDate)
    func dateTimeBoxType(textField:SRKDateTimeBox) -> UIDatePickerMode
    
    func dateTimeBoxMinimumDate(textField:SRKDateTimeBox) -> NSDate?
    func dateTimeBoxMaximumDate(textField:SRKDateTimeBox) -> NSDate?
    
    func dateTimeBoxPresentingViewController(textField:SRKDateTimeBox) -> UIViewController
    func dateTimeBoxRectFromWhereToPresent(textField:SRKDateTimeBox) -> CGRect
    
    func dateTimeBoxFromBarButton(textField:SRKDateTimeBox) -> UIBarButtonItem?
    
    func dateTimeBoxFromTableViewCell(textField:SRKDateTimeBox) -> UITableView
    func dateTimeBoxRectFromTableViewCell(textField:SRKDateTimeBox) -> UITableViewCell
    
    func dateTimeBoxTintColor(textField:SRKDateTimeBox) -> UIColor
    func dateTimeBoxToolbarColor(textField:SRKDateTimeBox) -> UIColor
    
    func dateTimeBoxDidTappedCancel(textField:SRKDateTimeBox)
    func dateTimeBoxDidTappedDone(textField:SRKDateTimeBox)
}

@objc public class SRKDateTimeBox: UITextField {
    public weak var delegateForDateTimeBox:SRKDateTimeBoxDelegate?
    var objDateTimeBoxVCtr: DateTimeBoxVCtr?
    
    public func showOptions() {
        self.objDateTimeBoxVCtr = DateTimeBoxVCtr(nibName: "DateTimeBoxVCtr", bundle: nil)
        self.objDateTimeBoxVCtr?.modalPresentationStyle = .Popover
        self.objDateTimeBoxVCtr?.popoverPresentationController?.delegate = self.objDateTimeBoxVCtr
        self.objDateTimeBoxVCtr?.refSRKDateTimeBox = self
        if let btn = self.delegateForDateTimeBox?.dateTimeBoxFromBarButton(self) {
            self.objDateTimeBoxVCtr?.popoverPresentationController?.barButtonItem = btn
        }
        if let tableview = self.delegateForDateTimeBox?.dateTimeBoxFromTableViewCell(self) {
            self.objDateTimeBoxVCtr?.popoverPresentationController?.sourceView = tableview
            
            var sourceRect = (self.delegateForDateTimeBox?.dateTimeBoxRectFromTableViewCell(self).frame)!
            sourceRect.size.width /= 2
            
            self.objDateTimeBoxVCtr?.popoverPresentationController?.sourceRect = sourceRect
        }
        else {
            self.objDateTimeBoxVCtr?.popoverPresentationController?.sourceView = self.delegateForDateTimeBox?.dateTimeBoxPresentingViewController(self).view
            self.objDateTimeBoxVCtr?.popoverPresentationController?.sourceRect = (self.delegateForDateTimeBox?.dateTimeBoxRectFromWhereToPresent(self))!
        }
        self.delegateForDateTimeBox?.dateTimeBoxPresentingViewController(self).presentViewController(self.objDateTimeBoxVCtr!, animated: true, completion: nil)
        
    }
}

@objc public class DateTimeBoxVCtr: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    weak var refSRKDateTimeBox:SRKDateTimeBox?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(320, 260)
        if let clr = self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxTintColor(self.refSRKDateTimeBox!) {
            self.toolBar.tintColor = clr
        }
        
        if let clr = self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxToolbarColor(self.refSRKDateTimeBox!) {
            self.toolBar.backgroundColor = clr
        }
        
        if let max = self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxMaximumDate(self.refSRKDateTimeBox!) {
            self.pickerView.maximumDate = max
            self.refSRKDateTimeBox!.delegateForDateTimeBox?.dateTimeBox(self.refSRKDateTimeBox!, didSelectDate:max)
        }
        if let min = self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxMinimumDate(self.refSRKDateTimeBox!) {
            self.pickerView.minimumDate = min
        }
        
        self.pickerView.datePickerMode = (self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxType(self.refSRKDateTimeBox!))!
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction public func dateChanged(sender: UIDatePicker) {
        self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBox(self.refSRKDateTimeBox!, didSelectDate: sender.date)
    }
    
    @IBAction public func btnDoneTapped(sender: UIBarButtonItem) {
        self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxDidTappedDone(self.refSRKDateTimeBox!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction public func btnCancelTapped(sender: UIBarButtonItem) {
        self.refSRKDateTimeBox?.delegateForDateTimeBox?.dateTimeBoxDidTappedCancel(self.refSRKDateTimeBox!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}