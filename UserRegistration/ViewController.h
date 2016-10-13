//
//  ViewController.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface ViewController : UIViewController <UITextFieldDelegate , FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UILabel *errorTextField;

//transfer property between segues
@property (weak, nonatomic) NSString* username;
- (IBAction)newUserClicked:(UIButton *)sender;

- (IBAction)loginClicked:(UIButton *)sender;
- (IBAction)mapViewClicked:(UIButton *)sender;
@end
