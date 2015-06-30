//
//  Utils.h
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


#pragma mark - Brazilian Phone Area Codes
+(NSArray *)areaCodes;

+(BOOL)isValidAreaCode:(NSString *)areaCode;

@end
