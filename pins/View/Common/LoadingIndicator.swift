//
//  LoadingIndicator.swift
//  pins
//
//  Created by 주동석 on 2023/11/10.
//

import UIKit

class LoadingIndicator {
    private static var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    private static var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private static var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()

    static func showLoading(with message: String = "") {
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first else { return }

        containerView = UIView(frame: window.frame)
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        loadingLabel.text = message
        containerView.addSubview(loadingLabel)

        containerView.leadingLayout(equalTo: window.leadingAnchor)
        containerView.topLayout(equalTo: window.topAnchor)
        activityIndicator.centerXLayout(equalTo: containerView.centerXAnchor)
        activityIndicator.centerYLayout(equalTo: containerView.centerYAnchor)
        loadingLabel.topLayout(equalTo: activityIndicator.bottomAnchor, constant: 20)
        loadingLabel.centerXLayout(equalTo: containerView.centerXAnchor)
        
        window.addSubview(containerView)
    }
    
    static func hideLoading() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
