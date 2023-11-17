//
//  PinRepository.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import OSLog
import FirebaseFirestore
import Firebase

final class PinRepository {
    func getAllPins(completion: @escaping ([Pin]) -> Void) {
        FirebaseFirestore.shared.db.collection("pins").getDocuments { (snapshot, error) in
            var pins = [Pin]()
            if let error = error {
                os_log("Error getting documents: %@", log: .default, type: .error, error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else {
                os_log("No documents", log: .default, type: .debug)
                return
            }
            
            for document in documents {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let pin = try JSONDecoder().decode(Pin.self, from: jsonData)
                    pins.append(pin)
                } catch let err {
                    os_log("Error decoding: %@", log: .default, type: .error, err.localizedDescription)
                }
            }
            completion(pins)
        }
    }
    
    func createPin(pin: Pin) async {
        let data = [
            "id": pin.id,
            "title": pin.title,
            "content": pin.content,
            "longitude": pin.longitude,
            "latitude": pin.latitude,
            "category": pin.category,
            "created": pin.created,
            "urls": pin.urls,
        ] as [String: Any]

        let documentReference = FirebaseFirestore.shared.db.collection("pins").document()
        await withCheckedContinuation { continuation in
            documentReference.setData(data)
            continuation.resume()
        }
    }
}
