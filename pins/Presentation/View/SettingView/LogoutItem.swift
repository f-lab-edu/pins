//
//  LogoutItem.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import OSLog
import UIKit
import FirebaseAuth
import PinsUtilKit

final class LogoutItem: SettingItemHandling {
    var title: String = "로그아웃"
    var navigationController: UINavigationController?
    var onPresentAlert: ((UIAlertController) -> Void)?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func performAction() {
        let alert = ConfirmManager.makeAlert(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?") { [weak self] in
            self?.logout()
        }
        onPresentAlert?(alert)
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            navigationController?.viewControllers = [LoginViewController()]
        } catch {
            os_log("logout \(error)")
        }
    }
}
