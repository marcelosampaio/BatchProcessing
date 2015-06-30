//
//  PhoneObject.m
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "PhoneObject.h"

@implementation PhoneObject
@synthesize phoneId,phone;



- (id)initWithPhoneId:(NSString *)p_PhoneId phone:(NSString *)p_Phone
{
    self = [super init];
    if (self) {
        phoneId=p_PhoneId;
        phone=p_Phone;
    }
    return self;
}

@end
