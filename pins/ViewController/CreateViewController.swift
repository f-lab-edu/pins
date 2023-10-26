//
//  CreateViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit

class CreateViewController: UIViewController {
    var createView: CreateView {
        view as! CreateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = CreateView()
    }
}
