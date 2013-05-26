//
//  Comment.m
//  Test_JSON
//
//  Created by lakkey on 13-5-26.
//  Copyright (c) 2013年 lakkey. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (void)dealloc {
    self.strId = nil;
    self.strContent = nil;
    self.strAuthor = nil;
    
    [super dealloc];
}


- (id)initWithDictionary:(NSDictionary* )dic {
    if (self = [super init]) {
        self.strId = [dic objectForKey:@"id"];
        self.strContent = [dic objectForKey:@"content"];
        self.nFloor = [[dic objectForKey:@"floor"] integerValue];
        id user = [dic objectForKey:@"user"];
        if ((NSNull* )user != [NSNull null]) {
            self.strAuthor = [user objectForKey:@"login"];
        }
    }
    
    return self;
}


- (NSString* )description {
    return [NSString stringWithFormat:@"strId = %@\nstrContent = %@\nnFloor = %i\nstrAuthor = %@", _strId, _strContent, _nFloor, _strAuthor];
}

@end
