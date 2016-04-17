//
//  DbTest.m
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/18.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "DbTest.h"

@implementation DbTest

+ (BOOL)createTable:(DbService *)service
{
    if (![service tableExists:@"People"]) {
        NSString *sql = @"CREATE TABLE People (                     \
        id INTEGER PRIMARY KEY AUTOINCREMENT,   \
        str1 TEXT,                              \
        str2 TEXT,                              \
        float1 REAL,                            \
        double1 INTEGER,                        \
        short1 REAL,                            \
        long1 REAL,                             \
        date1 TEXT,                             \
        bool1 INTEGER,                          \
        data1 BLOB                              \
        )";
        return [service executeUpdate:sql param:nil];
    } else {
        return NO;
    }
}

+ (void)insertPeople:(DbService *)service
{
    NSString *sql = @"insert into People(str1, str2, float1, double1, short1, long1, date1, bool1, data1) values(?,?,?,?,?,?,?,?,?)";
    
    NSString *text = @"dataValue";
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *param = @[@"bomo", @"male", @70, @175l, @22, @123, [NSDate date], @NO, data];
    
    
    for (int i = 0; i < 100; i++) {
        [service executeUpdate:sql param:param];
    }
}

+ (NSInteger)peopleCount:(DbService *)service
{
    return [service rowCount:@"People"];
}

@end
