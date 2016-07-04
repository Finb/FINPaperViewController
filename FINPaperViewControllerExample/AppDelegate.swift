//
//  AppDelegate.swift
//  FINPaperViewControllerExample
//
//  Created by huangfeng on 16/6/22.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window?.rootViewController = FINPaperViewController();
        self.window?.makeKeyAndVisible();
        return true
    }

}

