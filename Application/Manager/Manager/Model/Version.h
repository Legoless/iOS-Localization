//
//  Version.h
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

@interface Version : NSObject

@property (nonatomic, readonly) NSURL* path;

@property (nonatomic, readonly) NSArray* files;

- (id)initWithPath:(NSURL *)path;

/*!
 * Returns YES if directory at path contains valid iOS directory
 */
+ (BOOL)isValidRootDirectory:(NSURL *)path;

/*!
 * Copies all translation files to target directory with creating version and device directories
 */
- (BOOL)copyToTargetDirectory:(NSURL *)path version:(NSString *)version device:(NSString *)device;

@end
