//
//  ViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "ViewController.h"
#import "RegistrationViewController.h"
#import "MapKitViewController.h"
#import "DBManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"User Login";

    //add the delegates
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    
    //clear the error text field:
    _errorTextField.text = @"";
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];


}

-(void) viewWillAppear:(BOOL)animated {
    if ((_username != nil) && ([_username length] > 0)){
        //update the UI to show successfully registered and pre-populate the username field.

        //successful registration
        _errorTextField.textColor = [UIColor greenColor];
        _errorTextField.text = [NSString stringWithFormat:@"Successfully Registered %@", _username];
        
        //also populate the username text field
        _userNameTF.text = _username;
        
        //set the focus to _password text field
        [self.passwordTF becomeFirstResponder];
    } else {
        //set the focus to username text field
        [self.userNameTF becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult*)result error:(NSError *)error
{
    //transition to success screen
    if (result.token != nil) {
        [self performSegueWithIdentifier:@"successScreen" sender: loginButton];
    }
}

/*!
 @abstract Sent to the delegate when the button was used to logout.
 @param loginButton The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}


- (IBAction)newUserClicked:(UIButton *)sender {
    
    RegistrationViewController* rvc = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationSB"];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)loginClicked:(UIButton *)sender {

    //clear the error text field:
    _errorTextField.text = @"";
    
    DBManager* db = [DBManager getSharedInstance];
    
    //look up if the username is taken
    NSArray* userInfoObj = [db findByUsernameAndPassword:_userNameTF.text password:_passwordTF.text];
    
    if (userInfoObj == nil) {
        
        //username is already taken
        _errorTextField.textColor = [UIColor redColor];
        _errorTextField.text = [NSString stringWithFormat:@"login failed"];
        
    } else {
        //transition to success screen
        [self performSegueWithIdentifier:@"successScreen" sender: sender];
    }
}

- (IBAction)mapViewClicked:(UIButton *)sender {
    
    MapKitViewController* mvc = (MapKitViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MapKitViewSB"];
    
    [self.navigationController pushViewController:mvc animated:YES];
}
@end
