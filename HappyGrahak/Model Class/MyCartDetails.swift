//
//  MyCartDetails.swift
//  HappyGrahak
//
//  Created by IOS on 06/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MyCartDetails: NSManagedObject {
    @NSManaged var productName: String?
    @NSManaged var cartId: String?
    @NSManaged var productId: String?
    @NSManaged var invt_id: String?
    @NSManaged var imgPath: String?
    @NSManaged var price: String?
    @NSManaged var quantity: String?
    @NSManaged var unit: String?
}
