//
//  PurchasedTableViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/20/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "PurchasedTableViewController.h"

@interface PurchasedTableViewController ()

@end

@implementation PurchasedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Purchased Items";
}

-(void) viewWillAppear:(BOOL)animated {
    NSManagedObjectContext* context = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"LineItem"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"purchased = YES"];
    fetchRequest.predicate = predicate;
    
    self.lineItems = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //update the table
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

- (NSManagedObjectContext*) managedObjectContext {
    
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
