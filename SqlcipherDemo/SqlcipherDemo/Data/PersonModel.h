//
//  PersonModel.h
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/21.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "ColumnPropertyMappingDelegate.h"

@interface PersonModel : NSObject <ColumnPropertyMappingDelegate>

@property (nonatomic, assign) NSInteger peopleId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) float weight;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) short age;
@property (nonatomic, assign) long score;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, assign) BOOL married;
@property (nonatomic, strong) NSData *desc;

@end