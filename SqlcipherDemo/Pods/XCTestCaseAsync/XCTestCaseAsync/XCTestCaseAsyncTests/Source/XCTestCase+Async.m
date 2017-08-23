//
//  XCTestCase+Async.m
//  Mask
//
//  Created by bomo on 2017/3/15.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import "XCTestCase+Async.h"

@implementation XCTestCase (Async)

- (void)waitWithInterval:(NSTimeInterval)interval
{
    do {
        [NSRunLoop.mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        interval -= 0.1;
    } while (interval > 0);
}

- (void)waitFinishTimeAsync:(NSInteger)times complete:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    [self waitWithTimeout:INFINITY times:times asyncBlock:block];
}


- (void)waitWithAsync:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    [self waitWithTimeout:INFINITY asyncBlock:block];
}


- (BOOL)waitWithTimeout:(NSTimeInterval)timeout asyncBlock:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    return [self waitWithTimeout:timeout times:1 asyncBlock:block];
}

- (BOOL)waitWithTimeout:(NSTimeInterval)timeout times:(NSUInteger)times asyncBlock:(void (^ _Nonnull)(FinishBlock _Nonnull complete))block
{
    __block BOOL isFinished = NO;
    __block NSUInteger lastTimes = times;
    FinishBlock finishBlock = ^{
        lastTimes -= 1;
        if (lastTimes == 0) {
            isFinished = YES;
        }
    };
    
    BOOL isTimeOut = NO;
    NSDate *startDate = [NSDate date];
    //execute async block
    block(finishBlock);
    
    //wait with runloop
    do {
        [NSRunLoop.mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        
        //check whethere is timeout
        isTimeOut = [[NSDate date] timeIntervalSinceDate:startDate] > timeout;
    } while (!isFinished && !isTimeOut);
    
    return !isTimeOut;
}

- (BOOL)waitWithRetryTimes:(NSInteger)retryTimes asyncBlock:(void (^ _Nonnull)(CompleteBlock _Nonnull complete))block
{
    NSInteger retryTime = 0;
    
    while (retryTime++ < retryTimes) {
        __block BOOL isFinished = NO;
        __block BOOL retry = NO;
        
        CompleteBlock completeBlock = ^(BOOL finished){
            if (finished) {
                isFinished = YES;
            } else {
                retry = YES;
            }
        };
        
        block(completeBlock);
        
        do {
            [NSRunLoop.mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        } while (!isFinished && !retry);
        
        if (isFinished) {
            return YES;
        }
    }
    return NO;
}

@end
