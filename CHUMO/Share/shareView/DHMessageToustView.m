//
//  DHMessageToustView.m
//  CHUMO
//
//  Created by xy2 on 16/3/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHMessageToustView.h"



@implementation DHMessageToustView


+ (void) asyncConfigToustViewWithMessage:(DHMessageModel *)message inview:(UIView *)inview delegate:(id<DHMessageToustViewDelegate>)delegate showFrame:(void(^)(CGRect showFrame))showFrame hideFrame:(void(^)(CGRect hideFrame))hideFrame{
    static DHMessageToustView *toustView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toustView = [[DHMessageToustView alloc]init];
    });
    [toustView configMessageToustWithMessageItem:message inview:inview delegate:delegate showFrame:showFrame hideFrame:hideFrame];
}

- (void)configMessageToustWithMessageItem:(DHMessageModel *)message inview:(UIView *)inview delegate:(id<DHMessageToustViewDelegate>)delegate showFrame:(void(^)(CGRect showFrame))showFrame hideFrame:(void(^)(CGRect hideFrame))hideFrame{
    self.delegate = delegate;
    self.frame = CGRectMake(0, 0, ScreenWidth - 0, 44);
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    if (!self.bgView) {
        _bgView = [[UIView alloc]init];
    }
    _bgView.frame = self.bounds;
    [self addSubview:_bgView];
    [UIView animateWithDuration:0.5 animations:^{
        showFrame(_bgView.frame);
    }];
    if (!self.messageIconImageV) {
        _messageIconImageV = [[UIImageView alloc]init];
    }
    _messageIconImageV.frame = CGRectMake(8.0, 15.5, 18.0, 13.0);
    _messageIconImageV.image = [UIImage imageNamed:@"letter_normal.png"];
    [_bgView addSubview:_messageIconImageV];
    
    if (!self.messageLabel) {
        _messageLabel = [[UILabel alloc]init];
    }
    _messageLabel.frame = CGRectMake(CGRectGetMaxX(_messageIconImageV.frame)+6, 0,ScreenWidth-8-6-CGRectGetWidth(_messageIconImageV.frame)-8, 44);
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_messageLabel addGestureRecognizer:tap];
    
    NSString *targetId = message.targetId;
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:targetId];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSInteger badgeValue = [DHMessageDao getBadgeValueWithTargetId:nil currentUserId:userId];
    _messageLabel.text = [NSString stringWithFormat:@"您有%ld条新的私信~",badgeValue];
    [self addSubview:_messageLabel];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _messageLabel.alpha = 1;
    self.alpha = 1;
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _messageLabel.alpha = 0;
        _bgView.alpha = 0;
        self.alpha = 0;
        _bgView = nil;
        hideFrame(_bgView.frame);
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_bgView removeFromSuperview];
            _bgView = nil;
            [self removeFromSuperview];
        });
    });
    [inview addSubview:self];
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(onClicked)]) {
        [self.delegate onClicked];
    }
}

-(void)layoutSubviews{
    
    CGRect temp = _messageLabel.frame;
    CGFloat hight = [self configLabelHightWithString:_messageLabel.text fontSize:12];
    if (hight <= 44) {
        hight = 44;
    }
    temp.size.height = hight;
    _messageLabel.frame = temp;
    
    CGRect temp1 = self.frame;
    temp1.size.height = hight;
    self.frame = temp1;
    
    
}
- (CGFloat)configLabelHightWithString:(NSString *)str fontSize:(CGFloat)fontSize{
    CGSize size = [str boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
@end
