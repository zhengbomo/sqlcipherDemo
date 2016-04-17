//
//  DbService.h
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/17.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "FMDB.h"

@interface DbService : NSObject

- (instancetype)initWithPath:(NSString *)path encryptKey:(NSString *)encryptKey;

- (BOOL)tableExists:(NSString *)tableName;


/** query first row and column */
- (id)executeScalar:(NSString *)sql param:(NSArray *)param;

/** row for table */
- (NSInteger)rowCount:(NSString *)tableName;

/** update */
- (BOOL)executeUpdate:(NSString *)sql param:(NSArray *)param;

/** query table with default construction */
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass;

/** query table with default construction and custom operation */
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass performBlock:(void (^)(id model, FMResultSet *rs))block;

@end
