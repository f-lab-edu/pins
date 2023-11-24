//
//  DetailViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit

final class DetailViewController: UIViewController {
    private var detailView: DetailView {
        view as! DetailView
    }
    
    override func loadView() {
        view = DetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
}

extension DetailViewController: UITextFieldDelegate {
}
