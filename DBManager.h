//
//  DBManager.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject {
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

-(BOOL)createDB;

-(BOOL)saveData:(NSString*)firstname lastname:(NSString*)lastname age:(NSString*)age username:(NSString*) username password:(NSString*) password;

-(NSArray*) findByUsername:(NSString*)username;

-(NSArray*) findByUsernameAndPassword:(NSString*)username password:(NSString*) password;

@end