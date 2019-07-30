//
//  AboutTableViewDelegate.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/6/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
import MessageUI


///Methods to display mail composer in About view
class AboutMailDelegate: NSObject, MFMailComposeViewControllerDelegate {
    
    let parent : AboutViewController!

    init(parent: AboutViewController) {
        self.parent = parent
    }
    
    //MARK: Email Mehtods
    func presentMailVC() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            parent.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self

        mailComposerVC.setToRecipients(["srrose@binghamton.edu"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)

        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send email. Please check your email configuration and try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        sendMailErrorAlert.addAction(okButton)
        parent.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
