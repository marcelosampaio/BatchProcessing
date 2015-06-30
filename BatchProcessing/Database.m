//
//  Database.m
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "Database.h"
#import "PhoneObject.h"

@interface Database()

@property (nonatomic,strong) Database *database;

@end


@implementation Database

@synthesize database=_database;


#pragma mark - Lazy Instantiation
- (Database *) database
{
    if(!_database)
    {
        _database = [[Database alloc] init];
    }
    return _database;
}



#pragma mark - Database Methods
-(NSString *) dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"database Path: %@",[[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_IDENTIFIER]);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_IDENTIFIER];
}


-(void) openDB
{
    if (sqlite3_open([[self.database dbPath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Open database failure!");
        return;
    }
}

-(void) closeDB
{
    sqlite3_close(db);
}

-(void) copyDatabaseToWritableFolder
{
    // check if ther is already a writable copy of the database
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_IDENTIFIER];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        NSLog(@"there is a database file already");
        return;
    }
    
    
    NSLog(@"we are about to move database file");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_IDENTIFIER];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    NSLog(@"database copied succesfully");
}

#pragma mark - Data Manipulation Methods
-(NSMutableArray *)getPhones{
    
    // Open Database
    [self openDB];
    

    // Result array
    NSMutableArray *objectArray=[[NSMutableArray alloc]init];
    
    // Get timeline from database
    NSString *sql = [NSString stringWithFormat:@"select * from Phones"];
    
    NSLog(@"SQL=%@",sql);
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        
        
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            // id
            char *field0 = (char *) sqlite3_column_text(statement, 0);
            NSString *phoneId = [[NSString alloc] initWithUTF8String:field0];
            
            // phone
            char *field1 = (char *) sqlite3_column_text(statement, 1);
            NSString *phone = [[NSString alloc] initWithUTF8String:field1];
            
            // add result to array
            PhoneObject *phoneObject=[[PhoneObject alloc]initWithPhoneId:phoneId phone:phone];
            
            [objectArray addObject:phoneObject];

        }
    }

    // Close Database
    [self closeDB];
    
    // return data
    return objectArray;
}


@end
