//
//  FirebaseService.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    let db = Firestore.firestore()
    private init() { }
}
