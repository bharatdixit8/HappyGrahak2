//
//  SidePannelViewController.m
//  JustHorses
//
//  Created by AKSIOS on 24/08/15.
//  Copyright (c) 2015 AKSInteractive. All rights reserved.
//

#import "SidePannelViewController.h"
#import "BlankTableViewCell.h"
#import "HappyGrahak-Swift.h"

@interface SidePannelViewController ()<UINavigationBarDelegate>
{
    id<UINavigationControllerDelegate> delegatevc;
   
    NSString * loginUser,*userId ;
    NSArray * menuTabledata,*menu2Tabledata,*menuimageList,*menu2imageList;
   NSIndexPath *selectedPath;
    NSString *imgUrl;
}
@property (strong, nonatomic) IBOutlet UITableView *menuTable;

@end

@implementation SidePannelViewController
//@synthesize carListArray;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
        menu2Tabledata = [[NSArray alloc]initWithObjects:@"Home", @"Change Password",@"User Setting", @"My Profile", @"My Orders", @"My Wishlist",  @"Contact Us", @"Terms and Condition", @"Invite", @"About Us", @"Logout", nil];
        
        menu2imageList = [[NSArray alloc]initWithObjects:@"home_icon", @"pass_icon", @"pass_icon", @"profile_icon", @"orders_icon", @"sliderWishList", @"contact_icon", @"terms_condition_icon", @"invite_icon", @"about_icon", @"logout_icon.png",nil];
    }else{
        menu2Tabledata = [[NSArray alloc]initWithObjects:@"Home", @"Login", @"Register", @"Contact Us", @"Terms and Condition", @"Invite", @"About Us", nil];
        menu2imageList = [[NSArray alloc]initWithObjects:@"home_icon", @"login_icon", @"registration_icon",@"contact_icon", @"terms_condition_icon" , @"invite_icon", @"about_icon", nil];
    }
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -  UITableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [menu2Tabledata count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if(indexPath.row == 0)
                return 60;
        else
            return 45;
        
        
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
            static NSString *CustomCellIdentifier=@"OPSidePanelCellID";
    BlankTableViewCell *cell=(BlankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if(indexPath.row==0){
        
        if (cell==Nil) {
            cell.accessibilityIdentifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BlankTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] != nil){
                cell.userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
            }else{
                cell.userName.text = @"Name";
            }
            cell.userMobile.text = [NSString stringWithFormat:@"M. %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"]];
            
            imgUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"img"];
            if (imgUrl != nil) {
                NSURL *url = [[NSURL alloc]initWithString:imgUrl];
                NSData *data1 = [[NSData alloc]initWithContentsOfURL:url];
                cell.userProfile.image = [[UIImage alloc]initWithData:data1];
            }
        } else {
            cell.userName.text = @"Name";
            cell.userMobile.text = @"Mobile";
            cell.userProfile.image = [UIImage imageNamed:@"defaultUser_icon"];
        }
            return cell;
    }else{
        SideBarTableViewCell *cell=(SideBarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            if (cell==Nil) {
                cell.accessibilityIdentifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SideBarTableViewCell_iPhone" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
             }
                cell.selectionStyle  = UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor clearColor];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider.png"]];
                imgView.frame = CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1);
                [cell.contentView addSubview:imgView];
                //return  customCell;
                
                cell.menutitle.text = [menu2Tabledata objectAtIndex:indexPath.row-1];
                cell.menutitle.textColor = [UIColor colorWithRed:17/255 green:112/255 blue:1/255 alpha:1];
                cell.logoImgview.image = [UIImage imageNamed:[menu2imageList objectAtIndex:indexPath.row-1]];
             return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndex = indexPath.row;
    
    [self moveToViewController:indexPath.row];
    [self.menuTable reloadData];
}


-(void)moveToViewController:(NSInteger)indexvalue{
    switch (indexvalue) {
        case 0:{
        }
        break;
        case 1:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
                
                UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
                
                UINavigationController *welcomeNav=[[UINavigationController alloc] initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 2:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ChangePasswordViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 3:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {

            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignUpViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"SignUpViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 4:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ProfileViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ContactUSViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"ContactUSViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 5:{
             if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 OrderHistoryViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
                 
                 UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                 [welcomeNav initWithRootViewController:buyerwelcomeVC];
                 [self.sidePanelController setCenterPanel:welcomeNav];
             }else{
                 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 TermsConditionsViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
                 
                 UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                 [welcomeNav initWithRootViewController:buyerwelcomeVC];
                 [self.sidePanelController setCenterPanel:welcomeNav];
             }
        }
            break;
        case 6:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WishListViewController * buyerwelcomeVC = [[WishListViewController alloc] initWithNibName:@"WishListViewController" bundle:nil];;
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }else{
                
            }
        }
            break;
        case 7:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ContactUSViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"ContactUSViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AboutUsViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 8:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TermsConditionsViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 9:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                NSURL *myWebsite = [NSURL URLWithString:@"https://itunes.apple.com/in/app/happygrahak/id1337048681?mt=8"];
                
                NSArray *objectsToShare = @[myWebsite];
                
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
                
                NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                               UIActivityTypePrint,
                                               UIActivityTypeAssignToContact,
                                               UIActivityTypeSaveToCameraRoll,
                                               UIActivityTypeAddToReadingList,
                                               UIActivityTypePostToFlickr,
                                               UIActivityTypePostToVimeo];
                
                activityVC.excludedActivityTypes = excludeActivities;
                
                [self presentViewController:activityVC animated:YES completion:nil];
            }
        }
            break;
        case 10:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AboutUsViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                
                UINavigationController *welcomeNav= [sb instantiateViewControllerWithIdentifier:@"navigationController"];
                [welcomeNav initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        case 11:{
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]);
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]);
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
            
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController * buyerwelcomeVC = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
            
                UINavigationController *welcomeNav=[[UINavigationController alloc]  initWithRootViewController:buyerwelcomeVC];
                [self.sidePanelController setCenterPanel:welcomeNav];
            }
        }
            break;
        default:{
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
