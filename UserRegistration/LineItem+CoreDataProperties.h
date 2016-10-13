//
//  LineItem+CoreDataProperties.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/19/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LineItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LineItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *qty;

@end

NS_ASSUME_NONNULL_END
