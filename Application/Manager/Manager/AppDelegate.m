//
//  AppDelegate.m
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "AppDelegate.h"
#import "VersionVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) IBOutlet VersionVC* versionVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.versionVC = [[VersionVC alloc] initWithNibName:@"VersionVC" bundle:nil];
}

- (IBAction)versionButtonClick:(NSButton *)sender
{
    self.versionVC.view.frame = ((NSView *)self.window.contentView).bounds;
    
    [self.window.contentView setSubviews:@[]];
    
    [self.window.contentView addSubview:self.versionVC.view];
}

@end
