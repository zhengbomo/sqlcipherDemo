//
//  PersonModel.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/21.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (NSDictionary *)columnPropertyMapping
{
    return @{@"id": @"peopleId",
             @"str1": @"name",
             @"str2": @"gender",
             @"float1": @"weight",
             @"double1": @"height",
             @"short1": @"age",
             @"long1": @"score",
             @"date1": @"createTime",
             @"bool1": @"married",
             @"data1": @"desc"};
}

@end
