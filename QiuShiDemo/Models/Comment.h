//
//  Comment.h
//  Test_JSON
//
//  Created by lakkey on 13-5-26.
//  Copyright (c) 2013年 lakkey. All rights reserved.
//

#import <Foundation/Foundation.h>

// 代表一条评论
@interface Comment : NSObject

@property (nonatomic, assign) NSInteger     nFloor; // 楼层
@property (nonatomic, copy) NSString*       strContent; // 评论的内容
@property (nonatomic, copy) NSString*       strAuthor; // 作者
@property (nonatomic, copy) NSString*       strId; // 对应糗事的Id


- (id)initWithDictionary:(NSDictionary* )dic;

@end
