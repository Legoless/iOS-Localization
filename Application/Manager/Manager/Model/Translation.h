//
//  Translation.h
//  Manager
//
//  Created by Dal Rupnik on 29/01/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Translation : NSObject

@property (nonatomic, strong) NSString* location;
@property (nonatomic, getter = isSelected) BOOL selected;

@end
