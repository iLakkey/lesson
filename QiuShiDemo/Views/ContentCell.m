//
//  ContentCell.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-28.
//
//

#import "ContentCell.h"

@interface ContentCell () <EGOImageButtonDelegate>

@end

@implementation ContentCell


- (void)dealloc {
    self.imgbtnQiuShi = nil;
    self.strSmallImgURL = nil;
    self.strMediumImgURL = nil;
//    self.lblTag = nil;
    self.lblAuthor = nil;
    self.lblContent = nil;
    self.imgvwAvatar = nil;
    self.imgvwTag = nil;
    self.imgvwBackground = nil;
    self.imgvwFooter = nil;
    self.btnSmile = nil;
    self.btnUnhappy = nil;
    self.btnFavorite = nil;
    
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imgvwBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_center_background.png"]] autorelease];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, 200)];
        [self addSubview:_imgvwBackground];
        [_imgvwBackground release];
        
        //
        self.lblContent = [[[UILabel alloc] init] autorelease];
        [_lblContent setBackgroundColor:[UIColor clearColor]];
        [_lblContent setFrame:CGRectMake(20, 28, 280, 200)];
        [_lblContent setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
        // 以单词为单位换行，无论单行多行结尾都有省略号
        [_lblContent setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblContent setNumberOfLines:0];
        [self addSubview:_lblContent];
        [_lblContent release];
        
        //
        self.imgbtnQiuShi = [[[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"thumb_avatar.png"] delegate:self] autorelease];
        [_imgbtnQiuShi setFrame:CGRectZero];
        [_imgbtnQiuShi addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imgbtnQiuShi];
        [_imgbtnQiuShi release];
        
        //
        self.lblAuthor = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 200, 30)];
        [_lblAuthor setText:@"匿名"];
        [_lblAuthor setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
        [_lblAuthor setBackgroundColor:[UIColor clearColor]];
        [_lblAuthor setTextColor:[UIColor brownColor]];
        [self addSubview:_lblAuthor];
        [_lblAuthor release];
        
        //
        self.imgvwFooter = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_foot_background.png"]] autorelease];
        [_imgvwFooter setFrame:CGRectMake(0, _lblContent.frame.size.height, 320, 15)];
        [self addSubview:_imgvwFooter];
        [_imgvwFooter release];
        
        //
        self.btnSmile = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSmile setFrame:CGRectMake(10, _lblContent.frame.size.height - 30, 70, 44)];
        [_btnSmile setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnSmile setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        // 图片位置从居中偏左15个像素
        [_btnSmile setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_btnSmile setImage:[UIImage imageNamed:@"icon_for_enable.png"] forState:UIControlStateNormal];
        [_btnSmile setImage:[UIImage imageNamed:@"icon_for_active.png"] forState:UIControlStateHighlighted];
        // 图片位置从居中偏右15个像素
        [_btnSmile setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
        [_btnSmile.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [_btnSmile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnSmile setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_btnSmile setTitle:@"0" forState:UIControlStateNormal];
        [_btnSmile addTarget:self action:@selector(voteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSmile];
        [_btnSmile release];
        
        //
        self.btnUnhappy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnUnhappy setFrame:CGRectMake(100, _lblContent.frame.size.height - 30, 70, 44)];
        [_btnUnhappy setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnUnhappy setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [_btnUnhappy setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_btnUnhappy setImage:[UIImage imageNamed:@"icon_against_enable.png"] forState:UIControlStateNormal];
        [_btnUnhappy setImage:[UIImage imageNamed:@"icon_against_active.png"] forState:UIControlStateHighlighted];
        [_btnUnhappy setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
        [_btnUnhappy.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [_btnUnhappy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnUnhappy setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_btnUnhappy setTitle:@"0" forState:UIControlStateNormal];
        [_btnUnhappy addTarget:self action:@selector(voteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnUnhappy];
        [_btnUnhappy release];
        
        //
        self.btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFavorite setFrame:CGRectMake(270, _lblContent.frame.size.height - 30, 35, 44)];
        [_btnFavorite setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnFavorite setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [_btnFavorite setImage:[UIImage imageNamed:@"icon_fav_enable.png"] forState:UIControlStateNormal];
        [_btnFavorite setImage:[UIImage imageNamed:@"icon_fav_active.png"] forState:UIControlStateHighlighted];
        [_btnFavorite addTarget:self action:@selector(voteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFavorite];
        [_btnFavorite release];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)resizeCellHeight {
    CGFloat contentWidth = 280;
    UIFont* font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = [_lblContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    // 根据文字内容重设lblContent的高度
    [_lblContent setFrame:CGRectMake(20, 28, 280, size.height + 30)];
    
    // 载入糗事图片
    if ((_strSmallImgURL == nil) || ([_strSmallImgURL isEqualToString:@""])) {
        [_imgbtnQiuShi cancelImageLoad];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, size.height + 90)];
    }
    else {
        [_imgbtnQiuShi setFrame:CGRectMake(30, size.height + 70 , 72, 72)];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, size.height + 170)];
        [_imgbtnQiuShi setImageURL:[NSURL URLWithString:_strSmallImgURL]];
        [self imageButtonLoadedImage:_imgbtnQiuShi];
    }
    
    //
    CGFloat fBgEdge = _imgvwBackground.frame.size.height;
    [_imgvwFooter setFrame:CGRectMake(0, fBgEdge, 320, 15)];
    [_btnSmile setFrame:CGRectMake(10, fBgEdge - 28, 70, 44)];
    [_btnUnhappy setFrame:CGRectMake(100, fBgEdge - 28, 70, 44)];
    [_btnFavorite setFrame:CGRectMake(270, fBgEdge - 28, 35, 44)];
}


- (void)imageButtonClicked:(id)sender {

}


- (void)voteButtonClicked:(id)sender {

}

@end
