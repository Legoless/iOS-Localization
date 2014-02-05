//
//  Version.m
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "Version.h"
#import "Translation.h"

@interface Version ()

@property (nonatomic, strong, readwrite) NSURL* path;
@property (nonatomic, strong) NSMutableArray* filesBase;

@end

@implementation Version

- (NSMutableArray *)filesBase
{
    if (!_filesBase)
    {
        _filesBase = [NSMutableArray array];
    }
    
    return _filesBase;
}

- (NSArray *)files
{
    return [self.filesBase copy];
}

- (id)init
{
    return nil;
}

- (id)initWithPath:(NSURL *)path
{
    self = [super init];
    
    if (self)
    {
        self.path = [path copy];
        [self scanDirectoryAtPath:[path description]];
   
    }
    
    return self;
}

+ (BOOL)isValidRootDirectory:(NSURL *)path
{
    NSString* directoryPath = [path description];
    
    if ([directoryPath hasPrefix:@"file://"])
    {
        directoryPath = [directoryPath substringFromIndex:7];
    }
    
    if (![directoryPath hasSuffix:@"/"])
    {
        directoryPath = [NSString stringWithFormat:@"%@/", directoryPath];
    }
    
    NSError* error;
    
    NSArray* directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    
    BOOL foundApplication = NO;
    BOOL foundSystem = NO;
    BOOL foundLibrary = NO;
    
    for (NSString* file in directoryFiles)
    {
        BOOL isDirectory = NO;
        
        [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@%@", directoryPath, file] isDirectory:&isDirectory];
        
        if ([file isEqualToString:@"System"] && isDirectory)
        {
            foundSystem = YES;
        }
        else if ([file isEqualToString:@"Applications"] && isDirectory)
        {
            foundApplication = YES;
        }
        else if ([file isEqualToString:@"Library"] && isDirectory)
        {
            foundLibrary = YES;
        }
    }
    
    //
    // All three directories must exist to have a valid iOS root system
    //
    return foundApplication && foundSystem && foundLibrary;
}

- (void)scanDirectoryAtPath:(NSString *)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([path hasPrefix:@"file://"])
    {
        path = [path substringFromIndex:7];
    }
    
    if (![path hasSuffix:@"/"])
    {
        path = [NSString stringWithFormat:@"%@/", path];
    }
    
    NSError* error;
    
    NSArray* directoryFiles = [manager contentsOfDirectoryAtPath:path error:&error];
    
    for (NSString* file in directoryFiles)
    {
        BOOL isDirectory = NO;

        [manager fileExistsAtPath:[NSString stringWithFormat:@"%@%@", path, file] isDirectory:&isDirectory];
        
        NSLog(@"Scanning file: %@ Directory: %d", [NSString stringWithFormat:@"%@%@", path, file], isDirectory);
        
        NSString* lowercaseFile = [file lowercaseString];
        
        if (isDirectory && ([lowercaseFile hasSuffix:@"en.lproj"] || [lowercaseFile hasSuffix:@"english.lproj"]) )
        {
            Translation* translation = [[Translation alloc] init];
            
            translation.location = [NSString stringWithFormat:@"%@%@", path, file];
            
            [self.filesBase addObject:translation];
        }
        else if (isDirectory)
        {
            [self scanDirectoryAtPath:[NSString stringWithFormat:@"%@%@", path, file]];
        }
    }
}

- (BOOL)copyToTargetDirectory:(NSURL *)path version:(NSString *)version device:(NSString *)device
{
    NSString* targetPath = [self targetPathForPath:[path description] version:version device:device];
    
    NSString* rootPath = [self sanitizePath:self.path];
    //rootPath = [NSString stringWithFormat:@"/%@", rootPath];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //
    // Create target directory
    //
    
    NSError* error;
    
    [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSLog(@"Path: %@, %@", targetPath, error);
    
    //
    // Copy files
    //
    
    for (Translation* file in self.files)
    {
        BOOL isDirectory = NO;
        BOOL exists = [fileManager fileExistsAtPath:file.location isDirectory:&isDirectory];
        
        //
        // Copy all files in directory
        //
        
        NSLog(@"File Exists: %d Dir: %d Selected: %d: %@", exists, isDirectory, file.isSelected, file.location);
        
        if (exists && isDirectory && file.isSelected)
        {
            NSString* target = [file.location stringByReplacingOccurrencesOfString:rootPath withString:@""];
            
            target = [target substringFromIndex:1];
            target = [NSString stringWithFormat:@"%@/%@", targetPath, target];
            
            //
            // Create directory that is parent of the target directoy, so we can copy the target directory
            //
            
            NSString* parent = [target stringByDeletingLastPathComponent];
            
            [fileManager createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:nil];

            [fileManager copyItemAtPath:file.location toPath:target error:&error];
            
            
        }
    }
    
    
    return error == nil;
}

- (NSString *)sanitizePath:(id)sourcePath
{
    NSString* path = nil;
    
    if ([sourcePath isKindOfClass:[NSURL class]])
    {
        path = [sourcePath description];
    }
    else
    {
        path = [sourcePath copy];
    }
    
    if ([path hasPrefix:@"file://"])
    {
        path = [path substringFromIndex:7];
    }
    
    if ([path hasSuffix:@"/"])
    {
        path = [path substringToIndex:[path length] - 1];
    }
    
    return path;
}


- (NSString *)targetPathForPath:(NSString *)path version:(NSString *)version device:(NSString *)device
{
    path = [self sanitizePath:path];
    
    return [NSString stringWithFormat:@"/%@/%@/%@", path, version, device];
}

@end
