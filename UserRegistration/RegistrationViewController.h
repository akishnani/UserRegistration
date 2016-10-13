//
//  RegistrationViewController.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController :  UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UILabel *errorTextField;

- (IBAction)registrationBtnClicked:(UIButton *)sender;

@end
