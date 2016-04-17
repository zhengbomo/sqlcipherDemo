//
//  DbTest.h
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/18.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "DbService.h"

@interface DbTest : NSObject

+ (BOOL)createTable:(DbService *)service;

+ (void)insertPeople:(DbService *)service;

+ (NSInteger)peopleCount:(DbService *)service;
@end
