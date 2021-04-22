//
//  StoryboardedProtocol.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}
