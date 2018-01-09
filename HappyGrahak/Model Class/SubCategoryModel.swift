//
//  SubCategoryModel.swift
//  HappyGrahak
//
//  Created by IOS on 27/11/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

class SubCategoryModel: NSObject {
    var id: NSArray?
    var ukey: NSArray?
    var name: NSArray?
    var slug: NSArray?
    var title: NSArray?
    var image: NSArray?
    var image_path: NSArray?
    var keywords: NSArray?
    var descrip: NSArray?
    var type: NSArray?
    var parent: NSArray?
    var status: NSArray?
    var created_at: NSArray?
    
    init(id: NSArray?,ukey: NSArray?,name: NSArray?,slug: NSArray?,title: NSArray?,image: NSArray?, image_path: NSArray?,keywords: NSArray?,descrip: NSArray?,type: NSArray?,parent: NSArray?,status: NSArray?, created_at: NSArray?){
        self.id = id
        self.ukey = ukey
        self.name = name
        self.slug = slug
        self.title = title
        self.image = image
        self.image_path = image_path
        self.keywords = keywords
        self.descrip = descrip
        self.type = type
        self.parent = parent
        self.status = status
        self.created_at = created_at
    }
}
