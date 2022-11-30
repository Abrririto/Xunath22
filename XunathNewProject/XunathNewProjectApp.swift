//
//  XunathApp.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 20/10/22.
//

import SwiftUI

@main
struct XunathNewProjectApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    @StateObject var sceneManagerViewModel = SceneManagerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1024, height: 768)
                .fixedSize()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isEnabled = false
                    NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = false
                    NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = false
                })
        }
        .commands {
            CommandMenu("Zunath") {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("Q")
            }
        }
    }
}


@objc
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var token: NSKeyValueObservation?
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Remove a single menu
        if let m = NSApp.mainMenu?.item(withTitle: "Edit") {
            NSApp.mainMenu?.removeItem(m)
        }
        
        // Remove Multiple Menus
        ["Zunath", "Edit", "View", "Help", "Window", "File"].forEach { name in
            NSApp.mainMenu?.item(withTitle: name).map { NSApp.mainMenu?.removeItem($0) }
        }
        
        // Must remove after every time SwiftUI re adds
        token = NSApp.observe(\.mainMenu, options: .new) { (app, change) in
            ["Zunath", "Edit", "View", "Help", "Window", "File"].forEach { name in
                NSApp.mainMenu?.item(withTitle: name).map { NSApp.mainMenu?.removeItem($0) }
            }
            
            // Remove a single menu
            guard let menu = app.mainMenu?.item(withTitle: "Edit") else { return }
            app.mainMenu?.removeItem(menu)
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1024, height: 768),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.makeKeyAndOrderFront(self)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        
        let mainScreen: NSScreen = NSScreen.screens[0]
        window.contentView?.enterFullScreenMode(mainScreen)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
