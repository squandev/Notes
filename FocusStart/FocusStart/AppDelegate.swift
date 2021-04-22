//
//  AppDelegate.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let mainCoordinator = MainCoordinator.shared
        mainCoordinator.window.makeKeyAndVisible()
        mainCoordinator.start()

        if UserDefaults.standard.value(forKey: "firstLaunch") == nil {
            let text = "Первый запуск"
            NotesManager.shared.newNote(text: text,
                                        attributedText: NSAttributedString(string: text), textMods: nil)
            UserDefaults.standard.setValue(false, forKey: "firstLaunch")
        }
        return true
    }

}
