//
//  Database.h
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


#define DATABASE_IDENTIFIER         @"Phones.db"

@interface Database : NSObject
{
    sqlite3 *db;
}


#pragma mark - Database Methods
-(void) copyDatabaseToWritableFolder;

#pragma mark - Data Manipulation Methods
-(NSMutableArray *)getPhones;

@end
