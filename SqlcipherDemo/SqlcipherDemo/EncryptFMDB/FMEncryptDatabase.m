//
//  FMEncryptDatabase.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/31.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.

#import "FMEncryptDatabase.h"
#import <sqlite3.h>

@interface FMEncryptDatabase ()
{
    NSString *_encryptKey;
}

@end

@implementation FMEncryptDatabase

+ (instancetype)databaseWithPath:(NSString*)aPath encryptKey:(NSString *)encryptKey
{
    return [[[self class] alloc] initWithPath:aPath encryptKey:encryptKey];
}

- (instancetype)initWithPath:(NSString*)aPath encryptKey:(NSString *)encryptKey
{
    if (self = [self initWithPath:aPath]) {
        _encryptKey = encryptKey;
    }
    return self;
}


#pragma mark - Override Method
- (BOOL)open
{
    BOOL res = [super open];
    if (res && _encryptKey) {
        //数据库open后设置加密key
        [self setKey:_encryptKey];
    }
    return res;
}

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName
{
    BOOL res = [super openWithFlags:flags vfs:vfsName];
    if (res && _encryptKey) {
        //数据库open后设置加密key
        [self setKey:_encryptKey];
    }
    return res;
}

#endif

@end
