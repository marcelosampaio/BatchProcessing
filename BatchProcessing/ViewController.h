//
//  ViewController.h
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) Database *database;
@property (nonatomic,strong) NSArray *phoneObjects;
@property (nonatomic,strong) NSMutableArray *outputScript;




@end

