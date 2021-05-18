//
//  User.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 19.03.2021.
//

import Foundation
import Firebase

struct UserProfile {
    
    let uid: String
//    let email: String
    
    init(user: User) {
        self.uid = user.uid
//        self.email = user.email!
    }
}
