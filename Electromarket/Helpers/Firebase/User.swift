//
//  User.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 19.03.2021.
//

import Foundation
import FirebaseAuth

struct UserProfile {
    
    let uid: String
    
    init(user: User) {
        self.uid = user.uid
    }
}
