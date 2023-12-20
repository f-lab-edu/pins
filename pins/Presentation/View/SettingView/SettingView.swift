//
//  SettingView.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingView: UIView {
    // MARK: - 프로퍼티
    private var title: UILabel!
    private var backButton: UIButton!
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: "SettingViewCell")
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    private let tableData: [String] = ["로그아웃", "현재 캐시 100MB"]
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .background
        
        setTableViewLayout()
        configureDiffableDataSource()
        performInitialDataPopulation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 테이블 뷰
    private func setTableViewLayout() {
        addSubview(tableView)
        tableView
            .topLayout(equalTo: topAnchor)
            .bottomLayout(equalTo: bottomAnchor)
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
    }
    
    private func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, _ in
            guard let self else { fatalError("self is nil") }
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell
            cell?.setLabelText(self.tableData[indexPath.row])
            return cell
        })
    }
    
    private func performInitialDataPopulation() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(tableData)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - 타이틀 뷰
    private func configureTitleView() {
        addSubview(title)
    }
}
