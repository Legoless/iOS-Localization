//
//  VersionVC.m
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "Version.h"
#import "VersionVC.h"
#import "VersionFilesVC.h"

@interface VersionVC ()

@property (weak) IBOutlet NSTextField *directoryTextBox;

@property (strong, nonatomic) VersionFilesVC* filesVC;

@end

@implementation VersionVC

/*
- (void)loadView
{
    self.directoryTextBox.stringValue = @"file:///Users/legoless/Dropbox/Work/Library/iOS-Localization/iOS/";
}*/

- (IBAction)chooseButtonClick:(NSButton *)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton)
    {
        for (NSURL *url in [panel URLs])
        {
            self.directoryTextBox.stringValue = [url description];
            
            break;
        }
    }
}
- (IBAction)scanButtonClick:(NSButton *)sender
{
    //Version* version = [[Version alloc] initWithPath:[NSURL URLWithString:self.directoryTextBox.stringValue]];
    
    NSURL* path = [NSURL URLWithString:@"file:///Users/legoless/Dropbox/Work/Library/iOS-Localization/iOS/"];
    
    if ([Version isValidRootDirectory:path])
    {
        Version* version = [[Version alloc] initWithPath:path];
        
        self.filesVC = [[VersionFilesVC alloc] initWithNibName:@"VersionFilesVC" bundle:nil];
        self.filesVC.version = version;

        self.filesVC.view.bounds = [self.view.window.contentView bounds];
        
        self.view.subviews = @[];
        
        [self.view addSubview:self.filesVC.view];
    }
    else
    {
        NSAlert *alertView = [NSAlert alertWithMessageText:@"Manager" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The selected directory does not contain iOS system files.\n\nPlease choose a directory that has the correct file structure of iOS file system."];
        [alertView runModal];
    }
}

@end
