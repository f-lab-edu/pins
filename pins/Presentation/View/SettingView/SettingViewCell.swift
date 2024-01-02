//
//  SettingTableCell.swift
//  pins
//
//  Created by 주동석 on 12/20/23.
//

import UIKit

final class SettingViewCell: UITableViewCell, ReuseIdentifying {
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor(asset: .defaultText)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(asset: .defaultBackground)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        addSubview(label)
        label.leadingLayout(equalTo: leadingAnchor, constant: 16)
            .centerYLayout(equalTo: centerYAnchor)
    }
    
    func setLabelText(_ text: String) {
        label.text = text
    }
}
