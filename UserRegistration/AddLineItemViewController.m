//
//  AddLineItemViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/20/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "AddLineItemViewController.h"

@interface AddLineItemViewController ()
 @property (nonatomic) UIImagePickerController *imagePickerController;
 @property (nonatomic) NSMutableArray *capturedImages;
@end

@implementation AddLineItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Item";
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

- (IBAction)okBtnLineItem:(UIButton *)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new line item
     NSManagedObject *lineItem = [NSEntityDescription insertNewObjectForEntityForName:@"LineItem" inManagedObjectContext:context];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *qtyNumber = [f numberFromString:self.qtyTF.text];

    //encode the image as base64 encoding
    NSString* base64Encoding = [UIImagePNGRepresentation(self.lineItemPhotoImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [lineItem setValue:self.lineItemNameTF.text forKey:@"name"];
    [lineItem setValue:qtyNumber forKey:@"qty"];
    [lineItem setValue:[NSNumber numberWithBool:NO] forKey:@"purchased"];
    [lineItem setValue:base64Encoding forKey:@"photo"];
    
    NSError* error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelLineItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSManagedObjectContext*) managedObjectContext {
    
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (IBAction)photoLibraryClicked:(UIButton *)sender {

    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraClicked:(UIButton *)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.lineItemPhotoImage.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
