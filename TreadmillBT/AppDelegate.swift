//
//  AppDelegate.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 20/05/2021.
//

import Cocoa
import SwiftUI
import AppKit
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var popover = NSPopover()
    private var statusBar: StatusBarController?
    
    private var cancellable: AnyCancellable?
    private lazy var session = SessionViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Block additional status bar initialization when in SwiftUI preview mode
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else {
            return
        }
        
        print(PersistenceService.shared.container)
        
        let contentView = MainView()
            .environmentObject(session)
            .environment(\.managedObjectContext, PersistenceService.shared.viewContext)
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: 300, height: 360)
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
        
        // Create the Status Bar Item with the Popover
        statusBar = StatusBarController(popover, session)
        
        // Hides dock icon when running application (works only in status bar)
        NSApp.setActivationPolicy(.accessory)
    }
}
