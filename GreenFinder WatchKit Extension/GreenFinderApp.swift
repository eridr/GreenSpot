//
//  GreenFinderApp.swift
//  GreenFinder WatchKit Extension
//
//  Created by Erik Dreifaldt on 2021-05-30.
//

import SwiftUI

@main
struct GreenFinderApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
