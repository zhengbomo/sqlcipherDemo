# XCTestCaseAsync
async support for XCTestCase with timeout, retry feature using main runloop

## Feature
* Async Test
* Timeout support
* Retry support
* Waiting  

## Cocoapods
```bash
pod 'XCTestCaseAsync'
```

## Usage
### 1. Objective-C

```objc
//1. wait with a async block
[self waitWithAsync:^(FinishBlock  _Nonnull complete) {
    // async method
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // set finish flag, finish async
        complete();
    });
}];

//2. timeout
BOOL success = [self waitWithTimeout:3 asyncBlock:^(FinishBlock  _Nonnull complete) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
    });
}];
if (success) {
    NSLog(@"block execute success");
} else {
    NSLog(@"timeout");
}

//3. retry
BOOL success = [self waitWithRetryTimes:3 asyncBlock:^(CompleteBlock  _Nonnull complete) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{        
        NSLog(@"failure");
        complete(NO);
    });
}];
if (success) {
    NSLog(@"block execute success");
} else {
    NSLog(@"block execute fail after retrt");
}

// 4. finishTime
[self waitFinishTimeAsync:3 complete:^(FinishBlock  _Nonnull complete) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
        NSLog(@"waitFinishTimeAsync finish 1");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
        NSLog(@"waitFinishTimeAsync finish 2");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
        NSLog(@"waitFinishTimeAsync finish 3, the async Task is finished");
    });
}];
```



### 2. Swift
```swift
// 1. async test
self.wait { (complete) in
    let delay = DispatchTime.now() + .seconds(1)
    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
        complete()
    })
}

// 2. timeout test
let success = self.wait(withTimeout: 3) { (complete) in
    let delay = DispatchTime.now() + .seconds(5)
    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
        complete()
    })
}

// 3. retry test
let success = self.wait(withRetryTimes: 3) { (complete) in
    let delay = DispatchTime.now() + .seconds(1)
    DispatchQueue.main.asyncAfter(deadline: delay, execute: {    
        print("failure")
        complete(false);
    })
}
```
