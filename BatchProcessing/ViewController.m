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
@synthesize phoneObjects,outputScript;

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

    self.outputScript=[[NSMutableArray alloc]init];
    
    for (PhoneObject *objPhone in source) {
        
        // ------------------------------------------------
        // RULE #1
        // Search for phones with this pattern: "DDD+55DDD"
        // ------------------------------------------------
        
        // Check if row contains phone Country Code (Brazil)
        if ([[objPhone.phone substringWithRange:NSMakeRange(2, 3)]isEqualToString:BRAZILIAN_COUNTRY_CODE]) {
            
            // Extract data from the row
            NSString *areaCode1=[objPhone.phone substringWithRange:NSMakeRange(0, 2)];
            NSString *areaCode2=[objPhone.phone substringWithRange:NSMakeRange(5, 2)];

            // Check if it is a valid area code for rule #1
            if ([Utils isValidAreaCode:areaCode1] && [areaCode1 isEqualToString:areaCode2]) {
                NSLog(@"objPhoneId=%@",objPhone.phoneId);
                [self writeOutputWithPhone:objPhone];

            }
        }
    }
    
    // at end send sql script via email
    if (self.outputScript.count>0) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        
        [picker setSubject:[NSString stringWithFormat:@"Script On Demand"]];
        [picker setMessageBody:[self messageBody] isHTML:YES];
//        [picker addAttachmentData:[self.database getDatabaseFile] mimeType:@"application/x-sqlite3" fileName:@"MyPath.db"];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}


-(void)writeOutputWithPhone:(PhoneObject *)phone {
    // Rule #1 - Output results
    
    // get area code and phone row content
    NSString *row=[phone.phone substringWithRange:NSMakeRange(5, [phone.phone length]-5)];

    // extract area code from row
    NSString *areaCode=[row substringWithRange:NSMakeRange(0, 2)];
    NSString *phoneNUmber=[row substringWithRange:NSMakeRange(2, [row length]-2)];
    NSString *phonePrefix=[phoneNUmber substringWithRange:NSMakeRange(0, 4)];
    NSString *phoneSufix=[phoneNUmber substringWithRange:NSMakeRange(4, 4)];
    
    NSString *phoneString=[NSString stringWithFormat:@"('(%@) %@-%@',%d),",areaCode,phonePrefix,phoneSufix,[phone.phoneId intValue]];
    
    
//    NSString *sqlString=[NSString stringWithFormat:@"update usuario set celular='%@' where id=%d;",phoneString,[phone.phoneId intValue]];
    NSString *sqlString=[NSString stringWithFormat:@"%@",phoneString];
    
    NSLog(@"*** output string = %@",sqlString);
    [self.outputScript addObject:sqlString];
    

}

#pragma mark - Email Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Email Working Method
-(NSMutableString *)messageBody{
    NSMutableString *msg=[[NSMutableString alloc]init];
    for (NSString *row in self.outputScript) {
        [msg appendFormat:@"%@<br>",row];
    }
    return msg;
}
//NSLog([@"1234567890" substringWithRange:NSMakeRange(3, 5)]);

//NSString *str = @"A. rahul VyAs";
//NSString *newStr = [str substringWithRange:NSMakeRange(3, [str length]-3)];

@end
