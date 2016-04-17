//
//  ColumnPropertyMappingDelegate.h
//  FaciShare
//
//  Created by ZhengXiankai on 15/7/20.
//  Copyright (c) 2015年 facishare. All rights reserved.
//

#import <Foundation/Foundation.h>

//实现数据库列名到model属性名的映射
@protocol ColumnPropertyMappingDelegate <NSObject>

@required
- (NSDictionary *)columnPropertyMapping;

@end
