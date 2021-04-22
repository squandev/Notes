//
//  MainCoordinator.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

class MainCoordinator {

    static var shared: MainCoordinator = {
        let coordinator = MainCoordinator(navigationController: UINavigationController())
        return coordinator
    }()

    var navigationController: UINavigationController
    private(set) var window: UIWindow

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
    }

    func start() {
        let viewController = MainViewController.instantiate()
        navigationController.pushViewController(viewController, animated: true)
    }

    func note(note: Note?) {
        let viewController = NoteViewController.instantiate()
        viewController.note = note
        navigationController.pushViewController(viewController, animated: true)
    }
}
