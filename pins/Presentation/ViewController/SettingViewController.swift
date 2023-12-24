//
//  SettingViewController.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingViewController: UIViewController {
    private lazy var viewModel: SettingViewModel = {
        let logoutItem = LogoutItem(navigationController: navigationController)
        logoutItem.onPresentAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
        return SettingViewModel(tableData: [
            logoutItem,
            DiskCacheItem(title: "메모리 100MB 사용중")
        ])
    }()
    private var settingView: SettingView {
        view as! SettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
        setTableDelegate()
    }
    
    override func loadView() {
        view = SettingView(viewModel: viewModel)
    }
    
    private func setAction() {
        settingView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
    }
    
    private func setTableDelegate() {
        settingView.tableView.delegate = self
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.getTableData()[indexPath.row]
        selectedItem.performAction()
    }
}
