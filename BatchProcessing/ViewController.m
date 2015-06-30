//
//  ViewController.m
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"
#import "PhoneObject.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize database;
@synthesize activityIndicator;

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Database initial procedures
    [self databaseInitialProcedures];
    
    // Activity Indicator
    [self stopAnimatingActivityIndicator];

}

#pragma mark - DataBase Methods
-(void)databaseInitialProcedures {
    
    self.database=[[Database alloc]init];
    
    // copy database from resource folder to documents folder
    [self.database copyDatabaseToWritableFolder];

    NSLog(@"");
}


#pragma mark - UI Actions
- (IBAction)batchProcessing:(id)sender {
    
    // Start activity indicator
    [self startAnimatingActivityIndicator];
    
    
    // get phones from database
    NSMutableArray *phoneObjects=[self.database getPhones];
    
    // iterate it
    for (PhoneObject *phoneObject in phoneObjects) {
        NSLog(@"---- id: %@         phone Number: %@",phoneObject.phoneId,phoneObject.phone);
    }
    
    // stop activity indicator
    [self stopAnimatingActivityIndicator];
    
}

#pragma mark - Working Methods
-(void)startAnimatingActivityIndicator{
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden=NO;
}

-(void)stopAnimatingActivityIndicator{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
}


@end
