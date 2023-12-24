//
//  SettingViewController.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingViewController: UIViewController {
    private let viewModel: SettingViewModel = SettingViewModel()
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
        // 여기에서 selectedItem을 사용하여 필요한 동작을 수행합니다.
        // 예를 들어, "로그아웃"을 클릭하면 로그아웃 처리를 하거나,
        // "현재 캐시 100MB"를 클릭하면 캐시 정보를 보여주는 등의 동작을 구현할 수 있습니다.
    }
}
