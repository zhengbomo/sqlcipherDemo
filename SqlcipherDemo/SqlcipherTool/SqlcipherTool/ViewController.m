//
//  ViewController.m
//  SqlcipherTool
//
//  Created by ZhengXiankai on 16/4/18.
//  Copyright © 2016年 bomo. All rights reserved.
//

#import "ViewController.h"
#import "FMEncryptHelper.h"

@interface ViewController ()
@property (weak) IBOutlet NSTextField *lbPath;
@property (weak) IBOutlet NSTextField *tfencryptKey;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (IBAction)open:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setMessage:@"select a sqlite file"];
    [openDlg setPrompt:@"OK"];
    [openDlg setCanCreateDirectories:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    openDlg.allowsOtherFileTypes = YES;
//    openDlg.allowedFileTypes = @[@"sqlite",@"db"];
    
    if ([openDlg runModal] == NSFileHandlingPanelOKButton)
    {
        NSURL *file = [[openDlg URLs] lastObject];
        self.lbPath.stringValue = file.path;
    }
}

- (IBAction)encrypt:(id)sender
{
    if ([self.lbPath.stringValue length] > 0) {
        
        if ([self.tfencryptKey.stringValue length] > 0) {
            BOOL res = [FMEncryptHelper encryptDatabase:self.lbPath.stringValue encryptKey:self.tfencryptKey.stringValue];
            
            NSString *msg = res ? @"encrypt success" : @"encrypt fail:file is not a sqlite file or encryptKey is not correct";
            
            [self alert:msg];
        } else {
            [self alert:@"encrypt key no found"];
        }
    } else {
        [self alert:@"file no found"];
    }
}

- (IBAction)decrypt:(id)sender
{
    if ([self.lbPath.stringValue length] > 0) {
        
        if ([self.tfencryptKey.stringValue length] > 0) {
            BOOL res = [FMEncryptHelper unEncryptDatabase:self.lbPath.stringValue encryptKey:self.tfencryptKey.stringValue];
            NSString *msg = res ? @"decrypt success" : @"decrypt fail:file is not a sqlite file or encryptKey is not correct";
            [self alert:msg];
        } else {
            [self alert:@"encrypt key no found"];
        }
    } else {
        [self alert:@"file no found"];
    }
}

- (void)alert:(NSString *)msg
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:msg];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end
