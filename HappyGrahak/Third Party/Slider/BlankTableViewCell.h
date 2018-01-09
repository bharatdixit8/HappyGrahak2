//
//  BlankTableViewCell.h
//  HappyGrahak
//
//  Created by IOS on 14/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userMobile;
@property (strong, nonatomic) IBOutlet UIImageView *userProfile;

@end
