//
//  QiuShi.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-25.
//
//

#import "QiuShi.h"

@implementation QiuShi

- (void)dealloc {
    self.strTag = nil;
    self.strId = nil;
    self.strContent = nil;
    self.strSmallImageURL = nil;
    self.strMediumImageURL = nil;
    self.strAuthor = nil;
    
    [super dealloc];
}


- (id)initWithDictionary:(NSDictionary* )dic {
    if (self = [super init]) {
        self.strTag = [dic objectForKey:@"tag"];
        self.strId = [dic objectForKey:@"id"];
        self.strContent = [dic objectForKey:@"content"];
        self.publishTime = [[dic objectForKey:@"published_at"] doubleValue];\
        
        id image = [dic objectForKey:@"image"];
        if ((NSNull* )image != [NSNull null]) {
            self.strSmallImageURL = SmallImageURLString(_strId, image);
            self.strMediumImageURL = MidiumImageURLString(_strId, image);
        }
        
        NSDictionary* dicVote = [dic objectForKey:@"votes"];
        self.nSmileCount = [[dicVote objectForKey:@"up"] integerValue];
        self.nUnhappyCount = [[dicVote objectForKey:@"down"] integerValue];
        
        id user = [dic objectForKey:@"user"];
        if ((NSNull* )user != [NSNull null]) {
            self.strAuthor = [user objectForKey:@"login"];
        }
    }
    
    return self;
}


- (NSString* )description {
    return [NSString stringWithFormat:@"strTag = %@\nstrId = %@\nstrContent = %@\npublishTime = %g\nstrSmallImageURL = %@\nstrMediumImageURL = %@\nnSmileCount = %i\nnUnhappyCount = %i\nStrAuthor = %@", _strTag, _strId, _strContent, _publishTime, _strSmallImageURL, _strMediumImageURL, _nSmileCount, _nUnhappyCount, _strAuthor];
}



@end
