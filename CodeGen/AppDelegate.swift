//
//  AppDelegate.swift
//  CodeGen
//
//  Created by admin on 09.04.18.
//  Copyright © 2018 starmel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("AppDelegate: home = \(NSHomeDirectory() + "/Library/CodeGen")")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

