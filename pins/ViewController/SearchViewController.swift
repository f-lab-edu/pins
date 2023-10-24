//
//  SearchViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit

class SearchViewController: UIViewController {
    var searchView: SearchView {
        view as! SearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = SearchView()
    }
}
