//
//  LoadingIndicator.swift
//  pins
//
//  Created by 주동석 on 2023/11/10.
//

import UIKit

class LoadingIndicator {
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()

    func showLoading(with message: String = "") {
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first else { return }
        
        containerView.frame = window.frame
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        loadingLabel.text = message
        containerView.addSubview(loadingLabel)

        activityIndicator.centerXLayout(equalTo: containerView.centerXAnchor)
        activityIndicator.centerYLayout(equalTo: containerView.centerYAnchor)
        loadingLabel.topLayout(equalTo: activityIndicator.bottomAnchor, constant: 20)
        loadingLabel.centerXLayout(equalTo: containerView.centerXAnchor)
        
        window.addSubview(containerView)
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
