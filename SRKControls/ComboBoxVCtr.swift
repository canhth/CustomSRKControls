//
//  ComboBoxVCtr.swift
//  BeautyNotes
//
//  Created by Sagar on 12/18/15.
//  Copyright © 2015 Sagar R. Kothari. All rights reserved.
//

import UIKit

@objc public protocol SRKComboBoxDelegate : NSObjectProtocol {
	
	func comboBox(textField:SRKComboBox, didSelectRow row:Int)
	func comboBoxNumberOfRows(textField:SRKComboBox) -> Int
	func comboBox(textField:SRKComboBox, textForRow row:Int) -> String
	func comboBoxPresentingViewController(textField:SRKComboBox) -> UIViewController
	func comboBoxRectFromWhereToPresent(textField:SRKComboBox) -> CGRect
    
    func comboBoxPresentingTableView(textField:SRKComboBox) -> UITableView
    func comboBoxRectTableViewCellFromWhereToPresent(textField:SRKComboBox) -> UITableViewCell
	
	func comboBoxFromBarButton(textField:SRKComboBox) -> UIBarButtonItem?
	
	func comboBoxTintColor(textField:SRKComboBox) -> UIColor
	func comboBoxToolbarColor(textField:SRKComboBox) -> UIColor
	
	func comboBoxDidTappedCancel(textField:SRKComboBox)
	func comboBoxDidTappedDone(textField:SRKComboBox)
}

@objc public class SRKComboBox: UITextField {
	public weak var delegateForComboBox:SRKComboBoxDelegate?
	var objComboBoxVCtr: ComboBoxVCtr?
	
    public func showOptions() {
        self.objComboBoxVCtr = ComboBoxVCtr(nibName: "ComboBoxVCtr", bundle: nil)
        self.objComboBoxVCtr?.modalPresentationStyle = .Popover
        self.objComboBoxVCtr?.popoverPresentationController?.delegate = self.objComboBoxVCtr
        self.objComboBoxVCtr?.refSRKComboBox = self
        if let btn = self.delegateForComboBox?.comboBoxFromBarButton(self) {
            self.objComboBoxVCtr?.popoverPresentationController?.barButtonItem = btn
        }
        else if let tableview = self.delegateForComboBox?.comboBoxPresentingTableView(self) {
            self.objComboBoxVCtr?.popoverPresentationController?.sourceView = tableview
            
            var sourceRect = (self.delegateForComboBox?.comboBoxRectTableViewCellFromWhereToPresent(self).frame)!
            sourceRect.size.width += sourceRect.size.width / 2
            
            self.objComboBoxVCtr?.popoverPresentationController?.sourceRect = sourceRect
        }
            
        else {
            self.objComboBoxVCtr?.popoverPresentationController?.sourceView = self.delegateForComboBox?.comboBoxPresentingViewController(self).view
            self.objComboBoxVCtr?.popoverPresentationController?.sourceRect = self.delegateForComboBox!.comboBoxRectFromWhereToPresent(self)
        }
        self.delegateForComboBox?.comboBoxPresentingViewController(self).presentViewController(self.objComboBoxVCtr!, animated: true, completion: nil)
    }
    
    
}

@objc public class ComboBoxVCtr: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {

	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var toolBar: UIToolbar!
	weak var refSRKComboBox:SRKComboBox?
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		self.preferredContentSize = CGSizeMake(WIDTH / 2.5, 100)
//		if let clr = self.refSRKComboBox?.delegateForComboBox?.comboBoxTintColor(self.refSRKComboBox!) {
//			self.toolBar.tintColor = clr
//		}
//		
//		if let clr = self.refSRKComboBox?.delegateForComboBox?.comboBoxToolbarColor(self.refSRKComboBox!) {
//			self.toolBar.backgroundColor = clr
//		}
//		
//		self.refSRKComboBox!.delegateForComboBox?.comboBox(self.refSRKComboBox!, didSelectRow: 0)
    }
	
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.refSRKComboBox!.delegateForComboBox?.comboBox(self.refSRKComboBox!, didSelectRow: row)
	}
	
	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (self.refSRKComboBox?.delegateForComboBox?.comboBoxNumberOfRows(self.refSRKComboBox!))!
	}
	
	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.refSRKComboBox?.delegateForComboBox?.comboBox(self.refSRKComboBox!, textForRow: row)
	}
	
	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	@IBAction public func btnDoneTapped(sender: UIBarButtonItem) {
		self.refSRKComboBox?.delegateForComboBox?.comboBoxDidTappedDone(self.refSRKComboBox!)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction public func btnCancelTapped(sender: UIBarButtonItem) {
		self.refSRKComboBox?.delegateForComboBox?.comboBoxDidTappedCancel(self.refSRKComboBox!)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
}
