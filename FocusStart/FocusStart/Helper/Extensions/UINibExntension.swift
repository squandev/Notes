//
//  UINibExntension.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

extension UINib {
    static func createInstance(nibName: String) -> UIView? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
