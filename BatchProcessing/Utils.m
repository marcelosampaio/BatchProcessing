//
//  Utils.m
//  BatchProcessing
//
//  Created by Marcelo Sampaio on 6/30/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "Utils.h"

@implementation Utils


#pragma mark - Brazilian Phone Area Codes
+(NSArray *)areaCodes{
    return [[NSArray alloc]initWithObjects:
    @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"21",@"22",@"24",@"27",@"28",@"31",@"32",@"33",
    @"34",@"35",@"37",@"38",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"51",@"53",@"54",@"55",
    @"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"71",@"73",@"74",@"75",@"77",@"79",@"81",@"82",
    @"83",@"84",@"85",@"86",@"87",@"88",@"89",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",nil];
}

+(BOOL)isValidAreaCode:(NSString *)areaCode{
    
    for (NSString *base in [self areaCodes]) {
        if ([base isEqualToString:areaCode]) {
            return YES;
        }
    }
    return NO;
}

@end
