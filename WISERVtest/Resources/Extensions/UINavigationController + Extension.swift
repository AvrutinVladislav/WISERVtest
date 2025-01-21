//
//  UINavigationController + Extension.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 31.10.2024.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
