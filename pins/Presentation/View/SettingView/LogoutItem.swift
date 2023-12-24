//
//  LogoutItem.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import OSLog
import UIKit
import FirebaseAuth

final class LogoutItem: SettingItemHandling {
    var title: String = "로그아웃"
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func performAction() {
        do {
            try Auth.auth().signOut()
            navigationController?.viewControllers = [LoginViewController()]
        } catch {
            os_log("logout \(error)")
        }
    }
}
