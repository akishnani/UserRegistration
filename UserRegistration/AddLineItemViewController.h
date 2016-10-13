//
//  AddLineItemViewController.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/20/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddLineItemViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *lineItemNameTF;

@property (weak, nonatomic) IBOutlet UITextField *qtyTF;

- (IBAction)okBtnLineItem:(UIButton *)sender;
- (IBAction)cancelLineItem:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *lineItemPhotoImage;

- (IBAction)photoLibraryClicked:(UIButton *)sender;

- (IBAction)cameraClicked:(UIButton *)sender;

@end
