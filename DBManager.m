//
//  DBManager.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/14/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "DBManager.h"
#import "NSString+MD5.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (BOOL)createDB {
    BOOL isSuccess = YES;
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"userdb3.sql"]];
    
     NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt ="create table if not exists userInfo (userInfoID primary key, firstname text, lastname text, age integer, username text, password text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    
    return isSuccess;
}

-(BOOL)saveData:(NSString*)firstname lastname:(NSString*)lastname age:(NSString*)age username:(NSString*) username password:(NSString*) password
{
    
    //get the MD5 hash of the password before storing it
    //store the password in md5 password
    NSString* md5Password = [password MD5];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into userInfo (firstname, lastname, age, username, password) values (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",firstname, lastname, age, username, md5Password];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_reset(statement);
            return NO;
        }
        
    }
    sqlite3_reset(statement);
    return NO;
}

-(NSArray*) findByUsername:(NSString*)username  {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select firstname, lastname, age, username, password from userInfo where username=\"%@\"",username];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                              query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *firstname = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:firstname];
                NSString *lastname = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:lastname];
                NSString *age = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:age];
                NSString *username = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:username];
                NSString *password = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:password];
                sqlite3_reset(statement);
                return resultArray;

            } else {
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
        }
    }
    sqlite3_reset(statement);
    return nil;
}


-(NSArray*) findByUsernameAndPassword:(NSString*)username password:(NSString*) password
{
    
    //get the MD5 hash of the password while looking up
    NSString* md5Password = [password MD5];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select firstname, lastname, age, username, password from userInfo where username=\"%@\" AND password=\"%@\"",username, md5Password];
        
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *firstname = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:firstname];
                NSString *lastname = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:lastname];
                NSString *age = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:age];
                NSString *username = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:username];
                NSString *password = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:password];
                sqlite3_reset(statement);
                return resultArray;
                
            } else {
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
        }
    }
    sqlite3_reset(statement);
    return nil;
}

@end