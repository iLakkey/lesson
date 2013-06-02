//
//  ContentCell.h
//  QiuShiDemo
//
//  Created by lakkey on 13-5-28.
//
//

#import <UIKit/UIKit.h>

@class QiuShi;

@interface ContentCell : UITableViewCell

@property (nonatomic, strong) EGOImageButton*   imgbtnQiuShi;      // 糗事图片
@property (nonatomic, copy) NSString*           strSmallImgURL; // 糗事图片的小图url
@property (nonatomic, copy) NSString*           strMediumImgURL;// 糗事图片的大图url
@property (nonatomic, strong) UILabel*          lblAuthor;      // 糗事作者
@property (nonatomic, strong) UILabel*          lblContent;     // 糗事内容
@property (nonatomic, strong) UIImageView*      imgvwAvatar;    // 作者头像
@property (nonatomic, strong) UIImageView*      imgvwTag;       // 标签图像
@property (nonatomic, strong) UIImageView*      imgvwBackground;// 背景图像
@property (nonatomic, strong) UIImageView*      imgvwFooter;    // 底部花边
@property (nonatomic, strong) UIButton*         btnSmile;       // 顶按钮
@property (nonatomic, strong) UIButton*         btnUnhappy;     // 踩按钮
@property (nonatomic, strong) UIButton*         btnFavorite;    // 收藏按钮

//
- (void)configWithQiuShi:(QiuShi* )qs;

//
- (void)resizeCellHeight;

@end
