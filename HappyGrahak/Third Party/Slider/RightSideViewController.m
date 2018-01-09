//
//  RightSideViewController.m
//  HappyGrahak
//
//  Created by IOS on 13/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import "RightSideViewController.h"
#import "RightBarTableViewCell.h"

@interface RightSideViewController ()<UINavigationBarDelegate>
{
    id<UINavigationControllerDelegate> delegatevc;
    
    NSString * loginUser,*userId ;
    NSArray * menuTabledata,*menu2Tabledata,*menuimageList,*menu2imageList;
    NSIndexPath *selectedPath;
    
}
@property (strong, nonatomic) IBOutlet UITableView *menuTable;

@end

@implementation RightSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    HomeViewController * buyerwelcomeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //    [[[[UIApplication sharedApplication] delegate] window]willRemoveSubview:buyerwelcomeVC.workshopButton];
    //    [[[[UIApplication sharedApplication] delegate] window]willRemoveSubview:buyerwelcomeVC.reviewButton];
    //    HomeViewController *home = [[HomeViewController alloc]init];
    //    _carListArray = [[NSArray alloc]init];
    //    _carListArray = home.addCarArray;
    //NSLog(@"******%@", carListArray);
    userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    loginUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"userType"];
    
    if([self.signUpPAge isEqualToString:@"buyer"]){
        loginUser = @"buyer";
    }
    
    [_menuTable reloadData];
    
    selectedIndex = 0;
    
    //[_menuTable setBackgroundColor:[UIColor colorWithRed:(208.0 / 255.0) green:(251.0 / 255.0) blue:(201.0 / 255.0) alpha: 1]];
    _menuTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *nav_titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    nav_titlelbl.textAlignment = NSTextAlignmentCenter;
    nav_titlelbl.textColor = [UIColor whiteColor];
    UIFont *lblfont = [UIFont fontWithName:@"Helvetica-bold" size:18];
    [nav_titlelbl setFont:lblfont];
    nav_titlelbl.text = @"Just Horses";
    self.navigationItem.titleView = nav_titlelbl;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    // menuTabledata = [[NSArray alloc]initWithObjects:@"Home",@"Post Your Horse",@"My Queries",@"Rate the App",@"Share",@"Feedback",@"FAQ's",@"Logout", nil];
    
    //menuimageList = [[NSArray alloc]initWithObjects:@"home.png",@"post_add_icon.png", @"faq_icon.png",@"rate_icon.png",@"share.png",@"feedback.png",@"faq_icon1.png",@"logout_icon.png",nil];
    
    
    menu2Tabledata = [[NSArray alloc]initWithObjects:@"Mobile Recharge",@"Data Card",@"DTH",@"Electricity", @"Flight", @"Hotel",@"LandLine", @"Bus", @"Gas",nil];
    
    menu2imageList = [[NSArray alloc]initWithObjects:@"right_mobile_icon", @"right_datacard_icon",@"right_dth_icon",@"right_electricity_icon",@"right_flight_icon",@"right_hotel_icon",@"right_landline_icon", @"right_bus_icon", @"right_gas_icon",nil];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -  UITableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [menu2Tabledata count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 9)
        return 145;
    
    else
        return 45;
    
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier=@"OPSidePanelCellID";
    RightBarTableViewCell *cell=(RightBarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell==Nil) {
        cell.accessibilityIdentifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RightBarTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        cell.selectionStyle  = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor=[UIColor clearColor];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider.png"]];
        imgView.frame = CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1);
        [cell.contentView addSubview:imgView];
        //return  customCell;
        
        cell.menutitle.text = [menu2Tabledata objectAtIndex:indexPath.row];
        cell.menutitle.textColor = [UIColor colorWithRed:17/255 green:112/255 blue:1/255 alpha:1];
        UIImage *img = [UIImage imageNamed:[menu2imageList objectAtIndex:indexPath.row]];
        CGRect frame = cell.logoImgview.frame;
        frame.size = img.size;
        cell.logoImgview.frame = frame;
        cell.logoImgview.image = img;
        //[UIImage imageNamed:[menu2imageList objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndex = indexPath.row;
    
    [self moveToViewController:indexPath.row];
    [self.menuTable reloadData];
}


-(void)moveToViewController:(NSInteger)indexvalue{
    switch (indexvalue) {
            //        case 6:{
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            //            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            //            ViewController * buyerwelcomeVC = [st instantiateViewControllerWithIdentifier:@"ViewController"];
            //            [self.navigationController pushViewController:buyerwelcomeVC animated:YES];
            //            UINavigationController *aboutNav=[[UINavigationController alloc] initWithRootViewController:buyerwelcomeVC];
            //
            //            [self.sidePanelController setCenterPanel:aboutNav];
            //
            //            //[self.sidePanelController setCenterPanel:buyerwelcomeVC];
            //        }
            //        break;
            //        case 4:{
            //            ProfileViewController * buyerwelcomeVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            //            UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:buyerwelcomeVC];
            //            [self.sidePanelController setCenterPanel:welcomeNav];
            //        }
            //            break;
            //        case 0:{
            //            HomeViewController * buyerwelcomeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            //            buyerwelcomeVC.str = [NSString stringWithFormat:@"%li", (long)indexvalue];
            //            UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:buyerwelcomeVC];
            //            [self.sidePanelController setCenterPanel:welcomeNav];
            //        }
            //            break;
            //        case 2:{
            //            BookingHistoryViewController *book = [[BookingHistoryViewController alloc]initWithNibName:@"BookingHistoryViewController" bundle:nil];
            //            UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:book];
            //            [self.sidePanelController setCenterPanel:welcomeNav];
            //        }
            //            break;
            //        case 1:{
            //            CarListViewController *addCar = [[CarListViewController alloc]initWithNibName:@"CarListViewController" bundle:nil];
            //            UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:addCar];
            //            [self.sidePanelController setCenterPanel:welcomeNav];
            //        }
            //            break;
            //        case 3:{
            //            ParkingHistoryViewController *book = [[ParkingHistoryViewController alloc]initWithNibName:@"ParkingHistoryViewController" bundle:nil];
            //            UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:book];
            //            [self.sidePanelController setCenterPanel:welcomeNav];
            //        }
            //            break;
        default:{
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
