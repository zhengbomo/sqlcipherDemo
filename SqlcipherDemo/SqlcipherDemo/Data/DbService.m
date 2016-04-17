//
//  DbService.m
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/17.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "DbService.h"
#import "FMEncryptDatabaseQueue.h"
#import "FMDatabaseQueue.h"
#import "ColumnPropertyMappingDelegate.h"
#import <objc/runtime.h>


@interface DbService ()

@property (nonatomic, strong) FMEncryptDatabaseQueue *queue;
@end


@implementation DbService

- (instancetype)initWithPath:(NSString *)path encryptKey:(NSString *)encryptKey
{
    if (self = [super init]) {
        _queue = [FMEncryptDatabaseQueue databaseQueueWithPath:path encryptKey:encryptKey];
    }    
    return self;
}

- (BOOL)tableExists:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and name='%@'", tableName];
    
    __block BOOL result = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            result = [rs[0] integerValue] > 0;
        }
        [rs close];
    }];
    return result;
}

- (BOOL)executeUpdate:(NSString *)sql param:(NSArray *)param
{
    __block BOOL result = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        if (param && param.count > 0) {
            result = [db executeUpdate:sql withArgumentsInArray:param];
        } else {
            result = [db executeUpdate:sql];
        }
    }];
    
    return result;
}

- (id)executeScalar:(NSString *)sql param:(NSArray *)param
{
    __block id result;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:param];
        if ([rs next]) {
            result = rs[0];
        } else {
            result = nil;
        }
        [rs close];
    }];
    return result;
}

- (NSInteger)rowCount:(NSString *)tableName
{
    NSNumber *number = (NSNumber *)[self executeScalar:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName] param:nil];
    return [number longValue];
}

#pragma mark - Query
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass
{
    return [self executeQuery:sql withArgumentsInArray:args modelClass:modelClass performBlock:nil];
}

- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args modelClass:(Class)modelClass performBlock:(void (^)(id model, FMResultSet *rs))block
{
    __block NSMutableArray *models = [NSMutableArray array];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self resultForModels:rs modelClass:modelClass performBlock:block];
        [rs close];
    }];
    return models;
}

#pragma mark - Private Method
/** reflect for result */
- (NSArray *)resultForModels:(FMResultSet *)rs modelClass:(Class)modelClass
{
    return [self resultForModels:rs modelClass:modelClass performBlock:nil];
}

/** reflect for result */
- (NSArray *)resultForModels:(FMResultSet *)rs modelClass:(Class)modelClass performBlock:(void (^)(id model, FMResultSet *rs))block;
{
    NSDictionary *mapping = nil;
    
    NSMutableArray *models = [NSMutableArray array];
    while ([rs next]) {
        id model = [[modelClass alloc] init];
        if(!mapping && [model conformsToProtocol:@protocol(ColumnPropertyMappingDelegate)]) {
            //implement ColumnPropertyMappingDelegate protocal
            mapping = [model columnPropertyMapping];
        }
        
        for (int i = 0; i < [rs columnCount]; i++) {
            NSString *columnName = [rs columnNameForIndex:i];
            //propertyName and columnName mapping
            NSString *propertyName;
            
            if(mapping) {
                propertyName = mapping[columnName];
                if (propertyName == nil) {
                    propertyName = columnName;
                }
            } else {
                propertyName = columnName;
            }
            
            objc_property_t objProperty = class_getProperty(modelClass, propertyName.UTF8String);
            //property exists
            if (objProperty) {
                if(![rs columnIndexIsNull:i]) {
                    [self setProperty:model value:rs columnName:columnName propertyName:propertyName property:objProperty];
                }
            }
            
            NSAssert(![propertyName isEqualToString:@"description"], @"description is default method，cannot set property for description，plese ColumnPropertyMappingDelegate for column mapping");
        }
        
        //custom operation
        if (block) {
            block(model, rs);
        }
        
        [models addObject:model];
    }
    
    return models;
}

/** auto set property */
- (void)setProperty:(id)model value:(FMResultSet *)rs columnName:(NSString *)columnName propertyName:(NSString *)propertyName property:(objc_property_t)property
{
    //    @"f":@"float",
    //    @"i":@"int",
    //    @"d":@"double",
    //    @"l":@"long",
    //    @"c":@"BOOL",
    //    @"s":@"short",
    //    @"q":@"long",
    //    @"I":@"NSInteger",
    //    @"Q":@"NSUInteger",
    //    @"B":@"BOOL",
    
    NSString *firstType = [[[[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","] firstObject] substringFromIndex:1];
    
    
    if ([firstType isEqualToString:@"f"]) {
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.floatValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"i"]){
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.intValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"d"]){
        [model setValue:[rs objectForColumnName:columnName] forKey:propertyName];
        
    } else if([firstType isEqualToString:@"l"] || [firstType isEqualToString:@"q"]){
        [model setValue:[rs objectForColumnName:columnName] forKey:propertyName];
        
    } else if([firstType isEqualToString:@"c"] || [firstType isEqualToString:@"B"]){
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.boolValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"s"]){
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.shortValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"I"]){
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.integerValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"Q"]){
        NSNumber *number = [rs objectForColumnName:columnName];
        [model setValue:@(number.unsignedIntegerValue) forKey:propertyName];
        
    } else if([firstType isEqualToString:@"@\"NSData\""]){
        NSData *value = [rs dataForColumn:columnName];
        [model setValue:value forKey:propertyName];
        
    } else if([firstType isEqualToString:@"@\"NSDate\""]){
        NSDate *value = [rs dateForColumn:columnName];
        [model setValue:value forKey:propertyName];
        
    } else if([firstType isEqualToString:@"@\"NSString\""]){
        NSString *value = [rs stringForColumn:columnName];
        [model setValue:value forKey:propertyName];
        
    } else {
        [model setValue:[rs objectForColumnName:columnName] forKey:propertyName];
    }
}

@end
