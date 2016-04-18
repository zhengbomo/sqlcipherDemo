//
//  FMEncryptHelper.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/8/26.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "FMEncryptHelper.h"
#import "sqlite3.h"

@implementation FMEncryptHelper

/** encrypt sqlite database (same file) */
+ (BOOL)encryptDatabase:(NSString *)path encryptKey:(NSString *)encryptKey
{
    NSString *sourcePath = path;
    NSString *targetPath = [NSString stringWithFormat:@"%@.tmp.db", path];
    
    if([self encryptDatabase:sourcePath targetPath:targetPath encryptKey:encryptKey]) {
        NSFileManager *fm = [[NSFileManager alloc] init];
        [fm removeItemAtPath:sourcePath error:nil];
        [fm moveItemAtPath:targetPath toPath:sourcePath error:nil];
        return YES;
    } else {
        return NO;
    }
}

/** decrypt sqlite database (same file) */
+ (BOOL)unEncryptDatabase:(NSString *)path encryptKey:(NSString *)encryptKey
{
    NSString *sourcePath = path;
    NSString *targetPath = [NSString stringWithFormat:@"%@.tmp.db", path];
    
    if([self unEncryptDatabase:sourcePath targetPath:targetPath encryptKey:encryptKey]) {
        NSFileManager *fm = [[NSFileManager alloc] init];
        [fm removeItemAtPath:sourcePath error:nil];
        [fm moveItemAtPath:targetPath toPath:sourcePath error:nil];
        return YES;
    } else {
        return NO;
    }
}

/** encrypt sqlite database to new file */
+ (BOOL)encryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey
{
    const char* sqlQ = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@';", targetPath, encryptKey] UTF8String];
    
    sqlite3 *unencrypted_DB;
    if (sqlite3_open([sourcePath UTF8String], &unencrypted_DB) == SQLITE_OK) {
        char *errmsg;
        // Attach empty encrypted database to unencrypted database
        sqlite3_exec(unencrypted_DB, sqlQ, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(unencrypted_DB);
            return NO;
        }

        // export database
        sqlite3_exec(unencrypted_DB, "SELECT sqlcipher_export('encrypted');", NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(unencrypted_DB);
            return NO;
        }

        // Detach encrypted database
        sqlite3_exec(unencrypted_DB, "DETACH DATABASE encrypted;", NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(unencrypted_DB);
            return NO;
        }

        sqlite3_close(unencrypted_DB);
        
        return YES;
    }
    else {
        sqlite3_close(unencrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(unencrypted_DB));
        
        return NO;
    }
}

/** decrypt sqlite database to new file */
+ (BOOL)unEncryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey
{
    const char* sqlQ = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS plaintext KEY '';", targetPath] UTF8String];
    
    sqlite3 *encrypted_DB;
    if (sqlite3_open([sourcePath UTF8String], &encrypted_DB) == SQLITE_OK) {
        
        
        char* errmsg;
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA key = '%@';", encryptKey] UTF8String], NULL, NULL, &errmsg);
        
        // Attach empty unencrypted database to encrypted database
        sqlite3_exec(encrypted_DB, sqlQ, NULL, NULL, &errmsg);
        
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(encrypted_DB);
            return NO;
        }
        
        // export database
        sqlite3_exec(encrypted_DB, "SELECT sqlcipher_export('plaintext');", NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(encrypted_DB);
            return NO;
        }
        
        // Detach unencrypted database
        sqlite3_exec(encrypted_DB, "DETACH DATABASE plaintext;", NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"%@", [NSString stringWithUTF8String:errmsg]);
            sqlite3_close(encrypted_DB);
            return NO;
        }
        
        sqlite3_close(encrypted_DB);
        
        return YES;
    }
    else {
        sqlite3_close(encrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(encrypted_DB));
        
        return NO;
    }
}

/** change secretKey for sqlite database */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey
{
    sqlite3 *encrypted_DB;
    if (sqlite3_open([dbPath UTF8String], &encrypted_DB) == SQLITE_OK) {
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA key = '%@';", originKey] UTF8String], NULL, NULL, NULL);
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA rekey = '%@';", newKey] UTF8String], NULL, NULL, NULL);
        
        sqlite3_close(encrypted_DB);
        return YES;
    }
    else {
        sqlite3_close(encrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(encrypted_DB));
        
        return NO;
    }
}

@end
