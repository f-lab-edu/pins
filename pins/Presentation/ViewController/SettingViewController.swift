//
//  SettingViewController.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingViewController: UIViewController {
    private var settingView: SettingView {
        view as! SettingView
    }
    
    override func loadView() {
        view = SettingView()
    }
}
