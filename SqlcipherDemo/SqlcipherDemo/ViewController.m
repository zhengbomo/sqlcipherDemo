//
//  ViewController.m
//  SqlcipherDemo
//
//  Created by ZhengXiankai on 16/4/17.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "DbTest.h"
#import "DbService.h"
#import "FMEncryptHelper.h"

@interface ViewController ()
{
    NSString *_dbPath;
}
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
@property (nonatomic, copy) NSString *encryptKey;
@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    self.encryptKey = @"32r32rdewfds";
    [super viewDidLoad];
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _dbPath = [directory stringByAppendingPathComponent:@"db1.db"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event
- (IBAction)init:(id)sender
{
    DbService *dbService = [[DbService alloc] initWithPath:_dbPath encryptKey:nil];
    if ([DbTest createTable:dbService]) {
        [DbTest insertPeople:dbService];
        [[[UIAlertView alloc] initWithTitle:nil message:@"create unencrypt database success with 100 row for People table" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"table was exists" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
 }
- (IBAction)query:(id)sender
{
    DbService *dbService = [[DbService alloc] initWithPath:_dbPath encryptKey:nil];
    NSInteger count = [DbTest peopleCount:dbService];
    
    NSString *msg = [NSString stringWithFormat:@"people count:%@", @(count)];
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
}

- (IBAction)encrypt:(id)sender
{
    BOOL res = [FMEncryptHelper encryptDatabase:_dbPath encryptKey:self.encryptKey];
    
    NSString *msg = res ? @"encrypt success" : @"encrypt fail";
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
}

- (IBAction)encryptQuery:(id)sender
{
    DbService *dbService = [[DbService alloc] initWithPath:_dbPath encryptKey:self.encryptKey];
    NSInteger count = [DbTest peopleCount:dbService];
    
    NSString *msg = [NSString stringWithFormat:@"people count:%@", @(count)];
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
}

- (IBAction)decrypt:(id)sender
{
    BOOL res = [FMEncryptHelper unEncryptDatabase:_dbPath encryptKey:self.encryptKey];
    
    NSString *msg = res ? @"decrypt success" : @"decrypt fail";
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
}


@end
