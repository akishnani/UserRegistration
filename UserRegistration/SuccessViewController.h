//
//  SuccessViewController.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/15/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SuccessViewController :UITableViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fbNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *fbImageView;

@property (strong) NSMutableArray *lineItems;

@end
