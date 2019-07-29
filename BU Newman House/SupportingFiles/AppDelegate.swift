//
//  AppDelegate.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/23/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "gotham", size: 30)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "systemTextLight")!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "gotham", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "systemTextLight")!
        ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "gotham", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "systemTextLight")!
        ], for: .highlighted)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
              (granted, error) in
              if granted {
                  print("Notification permisison granted")
              } else {
                  print("Notification permission denied")
              }
          }
        
        return true
    }


}

