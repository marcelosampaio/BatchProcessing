//
//  PhoneObject.h
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneObject : NSObject

@property (nonatomic,strong) NSString *phoneId;
@property (nonatomic,strong) NSString *phone;

- (id)initWithPhoneId:(NSString *)p_PhoneId phone:(NSString *)p_Phone;

@end
