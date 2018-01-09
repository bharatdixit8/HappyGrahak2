//
//  ProductDetailsModel.swift
//  HappyGrahak
//
//  Created by IOS on 02/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class ProductDetailsModel: NSObject {
    var id: NSArray?
    var name: NSArray?
    var title: NSArray?
    var image: NSArray?
    var image_path: NSArray?
    var keywords: NSArray?
    var descrip: NSArray?
    var deleted_at: NSArray?
    var updated_at: NSArray?
    var status: NSArray?
    var created_at: NSArray?
    var brand: NSArray?
    
    init(id: NSArray?,name: NSArray?,title: NSArray?,image: NSArray?, image_path: NSArray?,keywords: NSArray?,descrip: NSArray?,deleted_at: NSArray?,updated_at: NSArray?,status: NSArray?, created_at: NSArray?, brand:NSArray?){
        self.id = id
        self.name = name
        self.title = title
        self.image = image
        self.image_path = image_path
        self.keywords = keywords
        self.descrip = descrip
        self.deleted_at = deleted_at
        self.updated_at = updated_at
        self.status = status
        self.created_at = created_at
        self.brand = brand
    }
}
