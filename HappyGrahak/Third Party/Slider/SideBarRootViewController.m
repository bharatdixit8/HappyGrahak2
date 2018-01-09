//
//  SideBarRootViewController.m
//  JustHorses
//
//  Created by AKSIOS on 24/08/15.
//  Copyright (c) 2015 AKSInteractive. All rights reserved.
//

#import "SideBarRootViewController.h"
#import "SidePannelViewController.h"
#import "RightSideViewController.h"
#import "HappyGrahak-Swift.h"
#import "Macro.h"
#import "LLARingSpinnerView.h"
@import SQLite3;

@interface SideBarRootViewController ()

@end

@implementation SideBarRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clickMe];
    // Do any additional setup after loading the view from its nib.
}

-(void)createDb
{
    NSArray *dir=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dbPath=[NSString stringWithFormat:@"%@/userDb.sqlite",[dir lastObject]];
    
    sqlite3 *db;
    
    NSFileManager *fm=[NSFileManager new];
    
    if([fm fileExistsAtPath:dbPath isDirectory:nil])
    {
        NSLog(@"Database already exists..");
        return;
    }
    
    if (sqlite3_open([dbPath UTF8String],&db)==SQLITE_OK)
    {
        const char *query="create table user (userName VARCHAR(20),userAdd VARCHAR(20), userPass VARCHAR(20))";
        
        if (sqlite3_exec(db, query, NULL, NULL, NULL)==SQLITE_OK)
        {
            NSLog(@"User table created successfully..");
        }else
        {
            NSLog(@"User table creation failed..");
        }
        
    }else
    {
        NSLog(@"Open table failed..");
    }
    sqlite3_close(db);
    
}

-(void)clickMe{
//            let button1 = UIButton.init(type: .custom)
//            button1.setImage(UIImage.init(named: "left_menu_icon"), for: UIControlState.normal)
//            button1.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
//            button1.addTarget(self, action:#selector(self.openMenu), for:.touchUpInside)
//            let barButton1 = UIBarButtonItem.init(customView: button1)
//            let button2 = UIImageView.init(image: UIImage.init(named: "home_logo_icon"))
//            //button2.setImage(UIImage.init(named: "home_logo_icon"), for: UIControlState.normal)
//            button2.frame = CGRect.init(x: 50, y: 0, width: 100, height: 25)
//            //button2.addTarget(self, action:#selector(self.backAction), for:.touchUpInside)
//            let barButton2 = UIBarButtonItem.init(customView: button2)
//            self.navigationItem.leftBarButtonItems = [barButton1, barButton2]
//
//            let button3 = UIButton.init(type: .custom)
//            button3.setImage(UIImage.init(named: "right_menu_icon"), for: UIControlState.normal)
//            button3.frame = CGRect.init(x: 0, y: 0, width: 20, height: 40)
//            //button3.addTarget(self, action:#selector(self.moveToCart), for:.touchUpInside)
//            let barButton3 = UIBarButtonItem.init(customView: button3)
//
//            let button4 = UIButton.init(type: .custom)
//            button4.setImage(UIImage.init(named: "cart_icon"), for: UIControlState.normal)
//            button4.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
//            button4.addTarget(self, action:#selector(self.moveToCart), for:.touchUpInside)
//            let barButton4 = UIBarButtonItem.init(customView: button4)
//
//            self.navigationItem.rightBarButtonItems = [barButton3, barButton4]
//    //        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
//            let defaults = UserDefaults.standard
//            defaults.set(userDetails?.name, forKey: "name")
//            defaults.synchronize()
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 16.0/255.0, green: 32.0/255.0, blue: 38.0/255.0, alpha: 1)], for: .selected)
    
  
        SidePannelViewController *menuVCobject = [[SidePannelViewController alloc] initWithNibName:@"SidePannelViewController_iPhone" bundle:nil];
        
        
        
        UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menuVCobject];
    RightSideViewController *menuVCobject1 = [[RightSideViewController alloc] initWithNibName:@"RightSideViewController" bundle:nil];
    
    
    
    UINavigationController *rightMenu = [[UINavigationController alloc] initWithRootViewController:menuVCobject1];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    HomeViewController *homesellerObject = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homesellerObject];
            self.jaSidePanel = [[JASidePanelController alloc] init];
            self.jaSidePanel.shouldDelegateAutorotateToVisiblePanel = YES;
            self.jaSidePanel.centerPanel = homeNav;
            self.jaSidePanel.leftPanel = menuNav;
            //self.jaSidePanel.rightPanel = rightMenu;
    
        [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23.0/255.0 green:39.0/255.0 blue:86.0/255.0 alpha:1.0];
        [self.navigationController pushViewController:self.jaSidePanel animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
