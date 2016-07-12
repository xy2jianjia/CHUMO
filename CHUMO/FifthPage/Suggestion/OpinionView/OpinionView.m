//
//  OpinionView.m
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "OpinionView.h"

@implementation OpinionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {

    self.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    self.feedback = [[UITextView alloc] init];
    self.feedback.font = [UIFont fontWithName:@"Arial" size:18.0f];
    self.feedback.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [self addSubview:self.feedback];
    
    self.submit = [[UIButton alloc] init];
    [self.submit.layer setMasksToBounds:true];
    [self.submit.layer setCornerRadius:20.0];
    self.submit.titleLabel.font = [UIFont fontWithName:Typeface size:17.0f];
    [self.submit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.submit.backgroundColor = kUIColorFromRGB(0x934de6);
    [self addSubview:self.submit];
    
    contactView =[[UIView alloc]init];
    contactView.backgroundColor=[UIColor whiteColor];
    [self addSubview:contactView];
    
    contactTitle=[[UILabel alloc]init];
    [contactTitle setTextColor:kUIColorFromRGB(0xaaaaaa)];
    contactTitle.text=@"联系方式";
    [contactTitle setFont:[UIFont systemFontOfSize:13]];
    [contactView addSubview:contactTitle];
    
    self.contactInfo=[[UITextField alloc]init];
    self.contactInfo.placeholder=@"输入QQ、邮箱、手机号,以便我们联系您!";
    self.contactInfo.font=[UIFont systemFontOfSize:13];
    self.contactInfo.textColor=kUIColorFromRGB(0xaaaaaa);
    [contactView addSubview:self.contactInfo];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kUIColorFromRGB(0xaaaaaa);
    [self addSubview:titleLabel];
    
    topLine = [[UILabel alloc] init];
    topLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.feedback addSubview:topLine];
    
    centreLine = [[UILabel alloc]init];
    centreLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.feedback addSubview:centreLine];
    
    bottomLine = [[UILabel alloc] init];
    bottomLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.feedback addSubview:bottomLine];
    
    [self.feedback mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(200);
    }];
    
    
    [contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedback.mas_bottom).offset(0.5);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.mas_right).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
    }];
    [contactTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contactView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.contactInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contactView.mas_centerY);
        make.left.equalTo(contactTitle.mas_right);
        make.right.equalTo(contactView.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
    [self.submit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(contactView.mas_bottom).offset(140);
        make.height.mas_equalTo(40);
    }];
    
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(contactView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake([[UIScreen mainScreen] bounds].size.width-20, 25));
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    centreLine.frame = CGRectMake(0, 209.5, self.bounds.size.width, 0.5);
    bottomLine.frame = CGRectMake(0, 249.5, self.bounds.size.width, 0.5);
}

- (void)addDataWithtitle:(NSString *)title {
    
    titleLabel.text = title;
}
@end
