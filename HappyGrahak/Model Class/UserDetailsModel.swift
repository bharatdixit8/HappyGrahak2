//
//  UserDetailsModel.swift
//  HappyGrahak
//
//  Created by IOS on 27/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class UserDetailsModel: NSObject {
    var id: Int?
    var role_id: Int?
    var name: String?
    var mobile: String?
    var email: String?
    var is_active: Bool?
    var cartCount: Int?
    
    
    init(id: Int?,roleId: Int?,name: String?,mobile: String?,email: String?,is_active: Bool?,cartCount: Int?){
        self.id = id
        self.role_id = roleId
        self.name = name
        self.mobile = mobile
        self.email = email
        self.is_active = is_active
        self.cartCount = cartCount
    }
}
