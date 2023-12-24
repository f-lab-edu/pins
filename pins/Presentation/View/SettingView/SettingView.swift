//
//  SettingView.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingView: UIView {
    // MARK: - 프로퍼티
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "설정"
        label.textColor = UIColor(asset: .defaultText)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private let backButton: CustomButton = {
        let button = CustomButton(backgroundColor: UIColor(asset: .defaultBackground))
        button.setImage(systemName: "chevron.backward")
        return button
    }()
    let tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: "SettingViewCell")
        tableView.backgroundColor = UIColor(asset: .defaultBackground)
        tableView.separatorInset.left = 0
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    private var viewModel: SettingViewModel!
    // MARK: - 초기화
    init(viewModel: SettingViewModel) {
        super.init(frame: .zero)
        backgroundColor = UIColor(asset: .defaultBackground)
        self.viewModel = viewModel
        
        setBackButtonLayout()
        setTitleLabelLayout()
        setTableViewLayout()
        configureDiffableDataSource()
        performInitialDataPopulation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 타이틀
    private func setTitleLabelLayout() {
        addSubview(titleLabel)
        titleLabel
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor)
            .centerXLayout(equalTo: centerXAnchor)
        
    }
    // MARK: - 뒤로가기
    private func setBackButtonLayout() {
        addSubview(backButton)
        backButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor)
    }
    
    func setBackButtonAction(_ action: UIAction) {
        backButton.addAction(action, for: .touchUpInside)
    }
    // MARK: - 테이블 뷰
    private func setTableViewLayout() {
        addSubview(tableView)
        tableView
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: 16)
            .bottomLayout(equalTo: bottomAnchor)
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, _ in
            guard let self else { fatalError("self is nil") }
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell
            cell?.setLabelText(self.viewModel.getTableData()[indexPath.row])
            return cell
        })
    }
    
    private func performInitialDataPopulation() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.getTableData())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
