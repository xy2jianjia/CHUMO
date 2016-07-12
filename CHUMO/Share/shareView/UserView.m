//
//  UserView.m
//  CHUMO
//
//  Created by zxs on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "UserView.h"

@implementation UserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
    }
    return self;
}
static UILabel *_titlePi;
static UIImageView *_poImage;
static UIButton *_phograp;
static UILabel *_hoTitle;
static UILabel *_prTitle;
- (void)layoutViews {
    _allImage = [UIImageView new];
    _titlePi = [UILabel new];
    _poImage = [UIImageView new];
    _phograp = [UIButton new];
    _albumButton=[UIButton new];
    _hoTitle = [UILabel new];
    _prTitle = [UILabel new];
    
    _phograp.tag = 101;
    _albumButton.tag=102;
    _hoTitle.text = @"优质的头像,有可能被推荐到首页哦~";
    _hoTitle.textColor=[UIColor whiteColor];
    _prTitle.text = @"如果头像涉及色情等不良信息,审核小组会严格处理哦!";
    _prTitle.textColor=[UIColor whiteColor];
    
    [_allImage setImage:[UIImage imageNamed:@"Upload-background"]];
    
    [_phograp setTitle:@"照相" forState:(UIControlStateNormal)];
    [_phograp setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [_albumButton setTitle:@"从相册选取" forState:(UIControlStateNormal)];
    [_albumButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    _poImage.backgroundColor = [UIColor orangeColor];
    _phograp.backgroundColor = kUIColorFromRGB(0x934ce5);
    _albumButton.backgroundColor = kUIColorFromRGB(0x63b0dc);
    if (iPhone4 && iPhone5) {
        [_titlePi setFont:[UIFont systemFontOfSize:14.0f]];
        [_hoTitle setFont:[UIFont systemFontOfSize:16.0f]];
        [_prTitle setFont:[UIFont systemFontOfSize:13.0f]];
        _phograp.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [_phograp.layer setCornerRadius:30/2];
        [_phograp.layer setMasksToBounds:YES];
        _albumButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [_albumButton.layer setCornerRadius:30/2];
        [_albumButton.layer setMasksToBounds:YES];
    }else{
        [_titlePi setFont:[UIFont systemFontOfSize:15.0f]];
        [_hoTitle setFont:[UIFont systemFontOfSize:14.0f]];
        [_prTitle setFont:[UIFont systemFontOfSize:12.0f]];
        _phograp.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_phograp.layer setCornerRadius:35/2];
        [_phograp.layer setMasksToBounds:YES];
        _albumButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_albumButton.layer setCornerRadius:35/2];
        [_albumButton.layer setMasksToBounds:YES];
    }
    
    
    [_titlePi setTextColor:kUIColorFromRGB(0xffffff)];
    [_titlePi setTextAlignment:NSTextAlignmentCenter];
    [_hoTitle setTextAlignment:NSTextAlignmentCenter];
    [_prTitle setTextAlignment:NSTextAlignmentCenter];
    
    [_phograp addTarget:self action:@selector(groupAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_albumButton addTarget:self action:@selector(groupalbumAction:) forControlEvents:(UIControlEventTouchUpInside)];

    
    [self addSubview:_allImage];
    [self addSubview:_titlePi];
    [self addSubview:_poImage];
    [self addSubview:_phograp];
    [self addSubview:_albumButton];
    [self addSubview:_hoTitle];
    [self addSubview:_prTitle];
}
- (void)touchAction:(UIButton *)sender {

    if ([self.phograpDelegate respondsToSelector:@selector(setBut:btTag:)]) {
        [self.phograpDelegate setBut:self btTag:sender.tag];
    }
}
- (void)groupAction:(UIButton *)sender {
    if ([self.phograpDelegate respondsToSelector:@selector(setBut:btTag:)]) {
        [self.phograpDelegate setBut:self btTag:sender.tag];
    }
}
- (void)groupalbumAction:(UIButton *)sender{
    if ([self.phograpDelegate respondsToSelector:@selector(setBut:btTag:)]) {
        [self.phograpDelegate setBut:self btTag:sender.tag];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _allImage.frame = self.bounds;
    if (iPhone4 || iPhone5) {
        _titlePi.frame = CGRectMake(0,
                                    64+gotHeightiphon6(50),
                                    Width, 30);
        _poImage.frame = CGRectMake((Width-(ImageW-50))/2,
                                    CGRectGetMaxY(_titlePi.frame)+12,
                                    ImageW-50, ImageH-50);
        _albumButton.frame = CGRectMake(ScreenWidth/2-10-BcTW,
                                        CGRectGetMaxY(_poImage.frame)+20,
                                        BcTW, 30);
        _phograp.frame = CGRectMake(ScreenWidth/2+10,
                                    CGRectGetMaxY(_poImage.frame)+20,
                                    BcTW, 30);
        _hoTitle.frame = CGRectMake(0,
                                    CGRectGetMaxY(_phograp.frame)+25,
                                    Width, 26);
        _prTitle.frame = CGRectMake(0,
                                    CGRectGetMaxY(_hoTitle.frame)+12,
                                    Width, 22);
    }else {
        _titlePi.frame = CGRectMake(0,
                                    64+gotHeightiphon6(50),
                                    Width, 30);
        _poImage.frame = CGRectMake((Width-212)/2,
                                    CGRectGetMaxY(_titlePi.frame)+24,
                                    ImageW, ImageH);
        _albumButton.frame = CGRectMake(ScreenWidth/2-15-BcTW,
                                        CGRectGetMaxY(_poImage.frame)+24,
                                        BcTW, 35);
        _phograp.frame = CGRectMake(ScreenWidth/2+15,
                                    CGRectGetMaxY(_poImage.frame)+24,
                                    BcTW, 35);
        _hoTitle.frame = CGRectMake(0,
                                    CGRectGetMaxY(_phograp.frame)+43,
                                    Width, 26);
        _prTitle.frame = CGRectMake(0,
                                    CGRectGetMaxY(_hoTitle.frame)+12,
                                    Width, 22);
    }
    
}


@end
