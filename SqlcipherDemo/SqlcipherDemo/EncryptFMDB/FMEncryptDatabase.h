//
//  FMEncryptDatabase.h
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/31.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "FMDatabase.h"

@interface FMEncryptDatabase : FMDatabase

+ (instancetype)databaseWithPath:(NSString*)aPath encryptKey:(NSString *)encryptKey;

- (instancetype)initWithPath:(NSString*)aPath encryptKey:(NSString *)encryptKey;

@end
