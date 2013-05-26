//
//  QiuShi.h
//  QiuShiDemo
//
//  Created by lakkey on 13-5-25.
//
//

#import <Foundation/Foundation.h>

// 代表一条糗事
@interface QiuShi : NSObject

@property (nonatomic, copy) NSString*       strSmallImageURL; //小图片链接地址
@property (nonatomic, copy) NSString*       strMediumImageURL; //中图片链接地址
@property (nonatomic, assign) NSTimeInterval publishTime; //发布时间
@property (nonatomic, copy) NSString*       strTag; //标签
@property (nonatomic, copy) NSString*       strId; //糗事id
@property (nonatomic, copy) NSString*       strContent; //内容
@property (nonatomic, assign) NSInteger     nCommentCount; //评论数量
@property (nonatomic, assign) NSInteger     nSmileCount; // 笑脸数量
@property (nonatomic, assign) NSInteger     nUnhappyCount; // 不高兴的数量
@property (nonatomic, copy) NSString*       strAuthor; // 作者

- (id)initWithDictionary:(NSDictionary* )dic;

@end
