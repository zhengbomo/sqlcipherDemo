//
//  FMEncryptHelper.h
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/8/26.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMEncryptHelper : NSObject

/** encrypt sqlite database (same file) */
+ (BOOL)encryptDatabase:(NSString *)path encryptKey:(NSString *)encryptKey;

/** decrypt sqlite database (same file) */
+ (BOOL)unEncryptDatabase:(NSString *)path encryptKey:(NSString *)encryptKey;

/** encrypt sqlite database to new file */
+ (BOOL)encryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey;

/** decrypt sqlite database to new file */
+ (BOOL)unEncryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey;

/** change secretKey for sqlite database */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey;

@end
