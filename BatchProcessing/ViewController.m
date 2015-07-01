//
//  ViewController.m
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"
#import "PhoneObject.h"
#import "Utils.h"

#define BRAZILIAN_COUNTRY_CODE          @"+55"

@interface ViewController ()

@end

@implementation ViewController
@synthesize database;
@synthesize activityIndicator;
@synthesize phoneObjects;

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
    self.phoneObjects=[self.database getPhones];
    
    // batch processing itself
    [self batchProcessingWithSource:self.phoneObjects];
    
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

#pragma mark - Main Process
-(void)batchProcessingWithSource:(NSArray *)source{

    for (PhoneObject *objPhone in source) {
        
        // ------------------------------------------------
        // RULE #1
        // Search for phones with this pattern: "DDD+55DDD"
        // ------------------------------------------------
        
        NSLog(@"-%@",objPhone.phone);
        
        // Check if row contains phone Country Code (Brazil)
        if ([[objPhone.phone substringWithRange:NSMakeRange(2, 3)]isEqualToString:BRAZILIAN_COUNTRY_CODE]) {
            
            // Extract data from the row
            NSString *areaCode1=[objPhone.phone substringWithRange:NSMakeRange(0, 2)];
            NSString *areaCode2=[objPhone.phone substringWithRange:NSMakeRange(5, 2)];
            
            // Check if it is a valid area code for rule #1
            if ([Utils isValidAreaCode:areaCode1] && [areaCode1 isEqualToString:areaCode2]) {

                NSLog(@"PROCESSING phone");
                [self generateOutputWithString:objPhone.phone];

            }
        }
    }
}


-(void)generateOutputWithString:(NSString *)textRow{
    // Rule #1 - Output results
    
    
}


//NSLog([@"1234567890" substringWithRange:NSMakeRange(3, 5)]);

//NSString *str = @"A. rahul VyAs";
//NSString *newStr = [str substringWithRange:NSMakeRange(3, [str length]-3)];

@end
