//
//  SuccessViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/15/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//


#import "SuccessViewController.h"
#import "AddLineItemViewController.h"
#import "PurchasedTableViewController.h"


@implementation SuccessViewController

-(void) viewDidLoad {
    
    //set the title to todo list
    self.title = @"Todo List";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(purchasedItems)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    //add the left nav item.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    
    /*FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.delegate = self;
*/

/*
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *nameOfLoginUser = [result valueForKey:@"name"];
                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                
                NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
                
                
                //set the name from the fb a/c
                self.fbNameTF.text = nameOfLoginUser;
                
                //get the image of fb a/c
                self.fbImageView.image = [self downloadImage:url];
            }
        }];
    }
 */
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSManagedObjectContext* context = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"LineItem"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"purchased = NO"];
    fetchRequest.predicate = predicate;
    
    self.lineItems = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //update the table
    [self.tableView reloadData];
}

-(IBAction)purchasedItems {
    PurchasedTableViewController* purchasedViewController = (PurchasedTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PurchasedItemSB"];
    
    [self.navigationController pushViewController:purchasedViewController animated:YES];
}

-(IBAction)addItem {
    
    AddLineItemViewController* addViewController = (AddLineItemViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"addLineItemSB"];
    
    [self.navigationController pushViewController:addViewController animated:YES];
}


- (UIImage*)downloadImage:(NSURL*)url {
    
    NSData *imagedata = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:imagedata];
}



- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    [self performSegueWithIdentifier:@"showHomeScreen" sender: self];
}

- (NSManagedObjectContext*) managedObjectContext {
    
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lineItems.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineItemCell" forIndexPath:indexPath];
     NSManagedObject *lineItem = [self.lineItems objectAtIndex:indexPath.row];
     
     
     NSNumber* qtyNum = [lineItem valueForKey:@"qty"];
     NSString* qtyStr = [qtyNum stringValue];
     
     //set the item name
     [cell.textLabel setText:[lineItem valueForKey:@"name"]];
     
     //set the qtystr
     [cell.detailTextLabel setText: [NSString stringWithFormat:@"Qty - %@",qtyStr]];
     
     //convert the base64 string to image
     NSString* photoBase64Str = [lineItem valueForKey:@"photo"];
     NSData *data = [[NSData alloc]initWithBase64EncodedString:photoBase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
     cell.imageView.image = [UIImage imageWithData:data];
     
     return cell;
 }

// Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *purchasedAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Purchased" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        //set the purchased value to true
        NSManagedObject* aLineItem = [self.lineItems objectAtIndex:indexPath.row];
        
        [aLineItem setValue:[NSNumber numberWithBool:YES] forKey:@"purchased"];
        
        NSError* error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        //remove the item from the list and the tableview
        [self.lineItems removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    purchasedAction.backgroundColor = [UIColor redColor];
    
    return @[purchasedAction];
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end