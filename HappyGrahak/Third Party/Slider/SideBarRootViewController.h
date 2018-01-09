//
//  SideBarRootViewController.h
//  JustHorses
//
//  Created by AKSIOS on 24/08/15.
//  Copyright (c) 2015 AKSInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
//#import "UserDetailsModal.h"

@interface SideBarRootViewController : UIViewController{
    
}
@property(nonatomic,strong)JASidePanelController *jaSidePanel;
-(void)createDb;

//@property (nonatomic,retain) UserDetailsModal * modal;

@end
