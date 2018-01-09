//
//  Macro.h
//  JustHorses
//
//  Created by AKSIOS on 21/08/15.
//  Copyright (c) 2015 AKSInteractive. All rights reserved.
//

#ifndef JustHorses_Macro_h
#define JustHorses_Macro_h
#endif


//#import "RequestResponseHandler.h"
//#import "HttpConnectionManager.h"

//////////////////JASidepannel Header////////////////////////////
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "SideBarTableViewCell.h"
#import "SideBarHorseCell.h"
#import "LLARingSpinnerView.h"

#define NAV_BACKGROUND_COLOR    [APPDELEGATE colorWithHexString:@"#005e3a"]

#define LABEL_TEXT_FontSIZE  [UIFont fontWithName:@"Helvetica" size:14]
#define LABEL_TEXT_COLOR     [UIColor darkGrayColor]


#define APPDELEGATE  (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define  _DEVICE_CONFIGURATION   @"Device has no camera"
#define  _ENTER_USER_NAME        @"Please enter valid UserName"
#define  _Password               @"Please enter password"
#define _ENTER_FIRST_NAME      @"Please enter first name"
#define _ENTER_LAST_NAME       @"Please enter last name"
#define _SELECT_GENDER         @"Please select gender"
#define _ENTER_State           @"Please enter state"
#define _SELECT_CITY           @"Please enter District"
#define _ENTER_EMAIL_ID        @"Please enter valid email id"
#define _ENTER_PASSWORD        @"Please enter password"
#define _ENTER_CINF_PWD        @"Please enter confirm password"
#define _ENTER_PHONE           @"Please enter phone number"



#define _DEFAULT_REQUEST_CONNECTION_ERROR       @"400"
#define SERVER_RESPONSE_SUCCESS_CODE            200

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width

//#define _SERVER_RESPONSE_TIMEOUT                30.0f
#define         RESPONSE_CODE               @"responseCode"
#define         RESPONSE_MESSAGE           @"responseMessage"
#define     _CONNECTION_ERROR_MESSAGE      @"Sorry, couldn't connect to server, please try again later."
#define     NETWORK_UNREACHABLE_ERR         @"Please check you internet connection"
#define     _REQUEST_HTTP_METHODE_TYPE      @"POST"
#define     _REQUEST_CONTENT_TYPE           @"application/json"
//#define     _REQUEST_CONTENT_TYPE           @"multipart/form-data"
#define  _FORGOT_PASSWORD  @"Your password is sent to your registered Email address"



#define    _SERVICE_BASE_URL  @"http://clients.aksinteractive.com/Carzeva/"

#define   _LOGIN_CONTEXT_VERB                 @"user_login_ios"
#define   _STATE_CONTEXT_VERB                 @"getSatate"
#define   _CITY_CONTEXT_VERB                  @"getCity"
#define   _SIGN_UP_CONTEXT_VERB               @"add_buyer_ios"
#define   _EDIT_CONTEXT_VERB                  @"edit_buyer"
#define   _RateThisApp_CONTEXT_VERB           @"rateApp"


#define   _FORGOT_PWD_CONTEXT_VERB            @"forgot_password"
#define   _ALL_HORSES_CONTEXT_VERB            @"all_horses"
#define   _HORSES_DETAILS_CONTEXT_VERB        @"horse_details"
#define   _ADD_HORSES_CONTEXT_VERB            @"add_product"
#define   _ADD_HORSE_IMAGE_CONTEXT_VERB       @"add_images"
#define   _EDIT_HORSES                        @"edit_product"
#define   _SELLER_MY_QUERY                    @"my_query_for_seller"
#define   _DELETE_HORSE                       @"delete_horse"
#define   _SOLD_HORSE                         @"sold_status"
#define   _ACTIVATE_DE_HORSE                  @"chg_status"
#define   _EDIT_PEDGREE_SELLER_HORSE                  @"add_pedigree"
#define   _FEEDBACK_HORSES                        @"feedback"
// for buyer

#define   _ALL_HORSE_Buyer                  @"all_horses_list"
#define   _ALL_HORSE_DETAIL_Buyer                  @"horse_details_for_buyer"

#define   _IAMINtrested_Buyer               @"my_interest_like"
#define   _FAV_LIKE_Buyer               @"favorites_like"
#define   _POSTQUERY_Buyer               @"send_query"
#define   _MY_QUERY_BUYER               @"my_query_for_buyer"
#define   _MY_FAV_BUYER                 @"my_favorites"
#define   _CHANGE_PWD_BUYER             @"change_password"
#define   _DeleteFile_BUYER             @"delete_files"


#define kHelviticaBold @"Helvetica-Bold"
#define kHelvitica @"Helvetica"
/////*************** Remove navigation Button******************/////
#define removeNavigationButton for (id obj in self.navigationController.navigationBar.subviews) {\
if ([obj isKindOfClass:[UIButton class]] || [obj isKindOfClass:[UILabel class]]) {\
[obj removeFromSuperview];\
}\
}\









