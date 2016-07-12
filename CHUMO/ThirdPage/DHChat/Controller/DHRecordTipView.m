//
//  DHRecordTipView.m
//  CHUMO
//
//  Created by xy2 on 16/5/17.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHRecordTipView.h"
#define screenwidth [[UIScreen mainScreen] bounds].size.width
#define screenheight [[UIScreen mainScreen] bounds].size.height
@implementation DHRecordTipView

+ (DHRecordTipView *)shareInstance{
    static dispatch_once_t onceToken;
    static DHRecordTipView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [[DHRecordTipView alloc]init];
    });
    return view;
}

+ (void)configTipInView:(UIView *)inView volume:(CGFloat )volume{
    
    [[DHRecordTipView shareInstance]  configTipInView:inView volume:volume];
}
- (void)configTipInView:(UIView *)inView volume:(CGFloat )volume{
    
    if (_warningImageV) {
        [_warningImageV removeFromSuperview];
        _warningImageV = nil;
    }
    if (_tipLabel) {
        [_tipLabel removeFromSuperview];
        _tipLabel = nil;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-50.0, CGRectGetMidY([[UIScreen mainScreen] bounds])-50.0, 130.0, 125.0);
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    // 录音视图左边图片（话筒）
    if (!_leftImageV) {
        _leftImageV = [[UIImageView alloc]init];
        _leftImageV.frame = CGRectMake(15, 0, 62.0, 100.0);
        _leftImageV.image = [UIImage imageNamed:@"RecordingBkg.png"];
        [self addSubview:_leftImageV];
    }
    // 音量提示
    if (!_volumeImageV) {
        _volumeImageV = [[UIImageView alloc]init];
        _volumeImageV.frame = CGRectMake(CGRectGetMaxX(_leftImageV.frame), 0, 38.0, 100.0);
        [self addSubview:_volumeImageV];
        [inView addSubview:self];
    }
    if (0<volume<=0.06) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal001.png"]];
    }else if (0.00<volume<=0.125) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal002.png"]];
    }else if (0.125<volume<=0.25) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal003.png"]];
    }else if (0.25<volume<=0.375) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal004.png"]];
    }else if (0.375<volume<=0.5) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal005.png"]];
    }else if (0.5<volume<=0.625) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal006.png"]];
    }else if (0.625<volume<=0.75) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal007.png"]];
    }else if (0.75<volume<=1.000) {
        [_volumeImageV setImage:[UIImage imageNamed:@"RecordingSignal008.png"]];
    }
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(_leftImageV.frame), self.bounds.size.width, 25);
        _tipLabel.text = @"正在录音~";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_tipLabel];
    }
}
+ (void)configWarningTipInView:(UIView *)inView{
    
    [[DHRecordTipView shareInstance]  configWarningTipInView:inView ];
}
- (void)configWarningTipInView:(UIView *)inView {
    if (_volumeImageV) {
        [_volumeImageV removeFromSuperview];
        _volumeImageV = nil;
    }
    if (_leftImageV) {
        [_leftImageV removeFromSuperview];
        _leftImageV = nil;
    }
    if (_tipLabel) {
        [_tipLabel removeFromSuperview];
        _tipLabel = nil;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-50.0, CGRectGetMidY([[UIScreen mainScreen] bounds])-50.0, 130.0, 125.0);
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    if (!_warningImageV) {
        _warningImageV = [[UIImageView alloc]init];
        _warningImageV.image = [UIImage imageNamed:@"MessageTooShort.png"];
        _warningImageV.frame = CGRectMake(15, 0, self.bounds.size.width-30, 100);
        [self addSubview:_warningImageV];
    }
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(_warningImageV.frame), self.bounds.size.width, 25);
        _tipLabel.text = @"说话时间太短";
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disMiss];
    });
}
+ (void)disMiss{
    [[DHRecordTipView shareInstance] disMiss];
}
-(void)disMiss{
//    [self removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    
}

@end
