//
//  RightBarTableViewCell.m
//  HappyGrahak
//
//  Created by IOS on 13/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import "RightBarTableViewCell.h"

@implementation RightBarTableViewCell
@synthesize menutitle = _menutitle;
@synthesize logoImgview;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
