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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
    }
    
    override func loadView() {
        view = SettingView()
    }
    
    private func setAction() {
        settingView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
    }
}
