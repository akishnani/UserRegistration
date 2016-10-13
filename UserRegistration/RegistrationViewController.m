//
//  RegistrationViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ViewController.h"
#import "DBManager.h"


@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"User Registration";
    
    //clear the error text field:
    _errorTextField.text = @"";
    
    self.firstNameTF.delegate = self;
    self.lastNameTF.delegate = self;
    self.ageTextField.delegate = self;
    self.usernameTF.delegate = self;
    self.passwordTF.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController* homeScreen = (ViewController*)[segue destinationViewController];
    
    if (homeScreen != nil) {
        //pass the username to the home screen
        homeScreen.username = _usernameTF.text;
    }
}


- (IBAction)registrationBtnClicked:(UIButton *)sender {
    
    //clear the error text field:
    _errorTextField.text = @"";
    
    DBManager* db = [DBManager getSharedInstance];
    
    //look up if the username is taken
    NSArray* userInfoObj = [db findByUsername:_usernameTF.text];
    
    if (userInfoObj == nil) {
        
        BOOL bRegistered = [db saveData:_firstNameTF.text lastname:_lastNameTF.text age:_ageTextField.text username:_usernameTF.text password:_passwordTF.text];
    
        if (bRegistered == YES) {
            
            //transition to success screen
            [self performSegueWithIdentifier:@"showHomeScreen" sender: sender];
        }
        
    } else {
        //get the username
        NSString* usernameVal = [userInfoObj objectAtIndex:3];
        
        //username is already taken
        _errorTextField.textColor = [UIColor redColor];
        _errorTextField.text = [NSString stringWithFormat:@"username %@ already taken", usernameVal];
    }
}
@end