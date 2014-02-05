//
//  VersionFilesVC.m
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "VersionFilesVC.h"
#import "Version.h"
#import "Translation.h"

@interface VersionFilesVC () <NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *targetTextField;
@property (weak) IBOutlet NSPopUpButton *devicePopupButton;
@property (weak) IBOutlet NSTextField *versionTextField;

@property (nonatomic, strong) NSArray* translations;

@end

@implementation VersionFilesVC

- (void)loadView
{
    [super loadView];
    
    self.translations = self.version.files;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //[self.tableView reloadData];
    
    [self.devicePopupButton removeAllItems];
    [self.devicePopupButton addItemsWithTitles:@[ @"iPhone", @"iPad", @"iPod Touch" ]];
    [self.devicePopupButton selectItemAtIndex:0];
    
    self.targetTextField.stringValue = @"file://Users/legoless/Desktop/";
}

- (IBAction)copyButtonClick:(NSButton *)sender
{
    //
    // This function will copy only the translation files including it's proper directories to a new location
    //
    
    NSString* path = self.targetTextField.stringValue;
    
    [self.version copyToTargetDirectory:[NSURL URLWithString:path] version:self.versionTextField.stringValue device:self.devicePopupButton.selectedItem.title];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.translations count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Translation* translation = self.translations[row];
    
    translation.selected = YES;
    
    if ([[tableColumn identifier] isEqualToString:@"Select"])
    {
        return @(translation.isSelected);
    }
    else
    {
        return translation.location;
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve the model object corresponding to `row'
    Translation *object = self.translations[row];
    
    // Set the object property corresponding to the column
    if([[tableColumn identifier] isEqualToString:@"Select"])
    {
        object.selected = [anObject boolValue];
    }
}

@end
