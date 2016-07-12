//
//  MessageFrame.m
//  ChatDemo
//
//  Created by long on 15/4/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MessageFrame.h"
#import "DHMessageModel.h"
@implementation MessageFrame


- (void)setMessage:(DHMessageModel *)message{
    
    _message = message;
    _showTime = YES;//设置是否显示时间
    
    // 0、获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 1、计算时间的位置
    if (_showTime){
        
        CGFloat timeY = kMargin;
        //        CGSize timeSize = [_message.time sizeWithAttributes:@{UIFontDescriptorSizeAttribute: @"16"}];
        //CGSize timeSize = [_message.time sizeWithFont:kTimeFont];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"STHeitiSC-Light" size:12.f],NSFontAttributeName,nil];
        CGSize timeSize = [_message.timeStamp sizeWithAttributes:dict];
        
        //NSLog(@"----%@", NSStringFromCGSize(timeSize));
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    }
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    // 2.1 如果是自己发得，头像在右边
    if ([_message.messageType integerValue] == 0) {
        iconX = screenW - kMargin - kIconWH;
    }
    
    CGFloat iconY = CGRectGetMaxY(_timeF) + kMargin;
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY;
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"STHeitiSC-Light" size:gotHeight(16)],NSFontAttributeName,nil];
    
        CGRect contentSize = [_message.message boundingRectWithSize:CGSizeMake(kContentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil];
    
    if ([_message.messageType integerValue] == 0) {
        contentX = iconX - kMargin - contentSize.size.width - kContentLeft - kContentRight;
    }
    
    _contentF = CGRectMake(contentX, contentY, contentSize.size.width + kContentLeft + kContentRight, contentSize.size.height + kContentTop + kContentBottom);
    
    // 4、计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
}


@end
