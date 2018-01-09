//
//  SidePannelViewController.h
//  JustHorses
//
//  Created by AKSIOS on 24/08/15.
//  Copyright (c) 2015 AKSInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface SidePannelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSInteger selectedIndex;
}
@property(nonatomic,strong)JASidePanelController *jaSidePanel;
@property (nonatomic,retain) NSString * signUpPAge;
//@property (retain, nonatomic)NSArray *carListArray;
@end
