//
//  FirebaseService.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import FirebaseFirestore

final class FirebaseFirestore {
    static let shared = FirebaseFirestore()
    let db = Firestore.firestore()
    private init() { }
}
