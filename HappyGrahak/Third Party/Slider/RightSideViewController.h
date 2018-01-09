//
//  RightSideViewController.h
//  HappyGrahak
//
//  Created by IOS on 13/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface RightSideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSInteger selectedIndex;
}
@property(nonatomic,strong)JASidePanelController *jaSidePanel;
@property (nonatomic,retain) NSString * signUpPAge;

@end
