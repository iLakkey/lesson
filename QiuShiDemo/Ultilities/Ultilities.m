//
//  Ultilities.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-27.
//
//

#import "Ultilities.h"

@implementation Ultilities

// 显示消息视图
+ (void)showMessage:(NSString* )strMessage {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end
