//
//  DHWelfareView.m
//  CHUMO
//
//  Created by xy2 on 16/6/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHWelfareView.h"
#define screen [[UIScreen mainScreen] bounds]

@implementation DHWelfareView

+ (void)configViewsWithPermission:(BOOL)permission inView:(UIView *)inView delegate:(id <DHWelfareViewDelegate >)delegate{
    [[[DHWelfareView alloc] init] configViewsWithPermission:permission inView:inView delegate:delegate];
}
- (void)configViewsWithPermission:(BOOL)permission inView:(UIView *)inView delegate:(id <DHWelfareViewDelegate >)delegate{
    self.delegate = delegate;
    if (permission) {
        UIView *bannerView = [[UIView alloc]init];
        bannerView.frame = CGRectMake(0, 20, screen.size.width, 40);
        [inView addSubview:bannerView];
        _btnArr = [NSMutableArray array];
        // 两个button
        UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        leftBtn.tag = 100;
        leftBtn.frame = CGRectMake(0, 0, CGRectGetWidth(bannerView.bounds)/2, CGRectGetHeight(bannerView.bounds)-1);
        [leftBtn setTitle:@"兑换话费" forState:(UIControlStateNormal)];
        [leftBtn setTitleColor:kUIColorFromRGB(0x934de6) forState:(UIControlStateNormal)];
//        [leftBtn setTitleColor:kUIColorFromRGB(0xe62739) forState:(UIControlStateSelected)];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bannerView addSubview:leftBtn];
        [_btnArr addObject:leftBtn];
        
        if (!_selectedView) {
            _selectedView = [[UIView alloc]init];
        }
        _selectedView.frame = CGRectMake(CGRectGetMidX(leftBtn.bounds)-29, CGRectGetMaxY(leftBtn.bounds), 58, 3);
        _selectedView.backgroundColor = kUIColorFromRGB(0x934de6);
        [leftBtn addSubview:_selectedView];
        
        UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        rightBtn.tag = 101;
        rightBtn.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame), CGRectGetMinY(leftBtn.frame), CGRectGetWidth(leftBtn.frame), CGRectGetHeight(leftBtn.frame));
        [rightBtn setTitle:@"兑换会员" forState:(UIControlStateNormal)];
        [rightBtn setTitleColor:kUIColorFromRGB(0xaaaaaa) forState:(UIControlStateNormal)];
//        [rightBtn setTitleColor:kUIColorFromRGB(0xe62739) forState:(UIControlStateSelected)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bannerView addSubview:rightBtn];
        [_btnArr addObject:rightBtn];
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(bannerView.frame), 1);
        lineView.backgroundColor = kUIColorFromRGB(0xe6e1e1);
        [inView addSubview:lineView];

        _textV = [[UITextField alloc]init];
        _textV.keyboardType = UIKeyboardTypeNumberPad;
        _textV.frame = CGRectMake(10, CGRectGetMaxY(bannerView.frame)+30, CGRectGetWidth(bannerView.frame)-20, 40);
        _textV.placeholder = @"请输入手机号";
        _textV.borderStyle = UITextBorderStyleRoundedRect;
        [inView addSubview:_textV];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [inView addGestureRecognizer:tap];
        
        _doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _doneBtn.frame = CGRectMake(CGRectGetMidX(screen)-137.5, CGRectGetMaxY(_textV.frame)+30, 275, 40);
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 15;
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneBtn.backgroundColor = kUIColorFromRGB(0x934de6);
        [_doneBtn setTitle:@"领取话费" forState:(UIControlStateNormal)];
        [_doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [inView addSubview:_doneBtn];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = CGRectMake(10, CGRectGetMaxY(_doneBtn.frame)+48, ScreenWidth-80-10, 25/2);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text = @"参加活动即可获得100元话费";
        [inView addSubview:_contentLabel];
        
        _subContentLabel = [[UILabel alloc]init];
        _subContentLabel.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+5, CGRectGetWidth(_contentLabel.frame), 10);
        _subContentLabel.font = [UIFont systemFontOfSize:11];
        _subContentLabel.textColor = kUIColorFromRGB(0xaaaaaa);
        _subContentLabel.text = @"送完为止";
        [inView addSubview:_subContentLabel];
        
        _buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buyBtn.frame = CGRectMake(ScreenWidth-10-80, CGRectGetMinY(_contentLabel.frame), 80, 25);
        //    buyBtn.layer.masksToBounds = YES;
        //    buyBtn.layer.cornerRadius = 15;
        [_buyBtn setTitleColor:kUIColorFromRGB(0x934de6) forState:(UIControlStateNormal)];
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"w_wo_lqfl_button_ljgm.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:(UIControlStateNormal)];
        [_buyBtn setTitle:@"立即抢购" forState:(UIControlStateNormal)];
        _buyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        //    buyBtn.layer.borderWidth = 0.5;
        //    buyBtn.layer.borderColor = kUIColorFromRGB(0x934de6).CGColor;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [inView addSubview:_buyBtn];
    }else{
        UIView *bannerView = [[UIView alloc]init];
        bannerView.frame = CGRectMake(0, 0, screen.size.width, 0);
        [inView addSubview:bannerView];
        
        _textV = [[UITextField alloc]init];
//        _textV.keyboardType = UIKeyboardTypeNumberPad;
        _textV.frame = CGRectMake(10, CGRectGetMaxY(bannerView.frame)+30, CGRectGetWidth(bannerView.frame)-20, 40);
        _textV.placeholder = @"请输入兑换码";
        _textV.borderStyle = UITextBorderStyleRoundedRect;
        [inView addSubview:_textV];
        
        _doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _doneBtn.frame = CGRectMake(CGRectGetMidX(screen)-137.5, CGRectGetMaxY(_textV.frame)+30, 275, 40);
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 15;
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneBtn.backgroundColor = kUIColorFromRGB(0x934de6);
        [_doneBtn setTitle:@"领取VIP" forState:(UIControlStateNormal)];
        [_doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [inView addSubview:_doneBtn];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = CGRectMake(10, CGRectGetMaxY(_doneBtn.frame)+48, ScreenWidth-80-10, 25/2);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text = @"参加活动送100元话费";
        [inView addSubview:_contentLabel];
        
        _subContentLabel = [[UILabel alloc]init];
        _subContentLabel.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+5, CGRectGetWidth(_contentLabel.frame), 10);
        _subContentLabel.font = [UIFont systemFontOfSize:11];
        _subContentLabel.textColor = kUIColorFromRGB(0xaaaaaa);
        _subContentLabel.text = @"送完为止";
        [inView addSubview:_subContentLabel];
        
        _buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buyBtn.frame = CGRectMake(ScreenWidth-10-80, CGRectGetMinY(_contentLabel.frame), 80, 25);
        //    buyBtn.layer.masksToBounds = YES;
        //    buyBtn.layer.cornerRadius = 15;
        [_buyBtn setTitleColor:kUIColorFromRGB(0x934de6) forState:(UIControlStateNormal)];
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"w_wo_lqfl_button_ljgm.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:(UIControlStateNormal)];
        [_buyBtn setTitle:@"立即抢购" forState:(UIControlStateNormal)];
        _buyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        //    buyBtn.layer.borderWidth = 0.5;
        //    buyBtn.layer.borderColor = kUIColorFromRGB(0x934de6).CGColor;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [inView addSubview:_buyBtn];
    }
    [inView addSubview:self];
}
- (void)leftBtnAction:(UIButton *)sender{
    if (sender.tag == 101) {
        _contentLabel.hidden = YES;
        _subContentLabel.hidden = YES;
        _buyBtn.hidden = YES;
        [_doneBtn setTitle:@"领取VIP" forState:(UIControlStateNormal)];
        _textV.placeholder = @"输入兑换码";
        _textV.keyboardType = UIKeyboardTypeDefault;
    }else{
        _contentLabel.hidden = NO;
        _subContentLabel.hidden = NO;
        _buyBtn.hidden = NO;
        [_doneBtn setTitle:@"领取话费" forState:(UIControlStateNormal)];
        _textV.placeholder = @"请输入手机号码";
        _textV.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (!_selectedView) {
        _selectedView = [[UIView alloc]init];
    }
    for (UIButton *btn in _btnArr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:kUIColorFromRGB(0x934de6) forState:(UIControlStateNormal)];
            _selectedView.frame = CGRectMake(CGRectGetMidX(btn.bounds)-29, CGRectGetMaxY(btn.bounds), 58, 3);
            _selectedView.backgroundColor = kUIColorFromRGB(0x934de6);
            [btn addSubview:_selectedView];
        }else{
            [btn setTitleColor:kUIColorFromRGB(0xaaaaaa) forState:(UIControlStateNormal)];
        }
    }
    
}
- (void)buyBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selfareOnclickedGoBuyCalledBack)]) {
        [self.delegate selfareOnclickedGoBuyCalledBack];
    }
}
- (void)doneBtnAction:(UIButton *)sender{
    [_textV resignFirstResponder];
    NSString *btnTitle = [sender titleForState:(UIControlStateNormal)];
    NSInteger type = 0;
    // 区分要提交的是话费还是兑换vip,1--话费，2--vip
    if ([btnTitle isEqualToString:@"领取话费"]) {
        type = 1;
    }else{
        type = 2;
    }
    NSString *textInfo = self.textV.text;
    if ([textInfo length] == 0) {
        NSString *msg = nil;
        if (type == 1) {
            msg = @"电话号码不为空!";
        }else{
            msg = @"兑换码不为空";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // 检验手机号码格式
    if (type == 1) {
        BOOL isReady =[self checkedPhoneNumberWithNumber:textInfo];
        if (!isReady) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selfareOnclickedConformButtonCalledBackWithInfo:type:)]) {
        [self.delegate selfareOnclickedConformButtonCalledBackWithInfo:textInfo type:type];
    }
}

- (BOOL)checkedPhoneNumberWithNumber:(NSString *)str{
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((1[3578][0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    UIView *view = sender.view;
    for (UIView *aview in view.subviews) {
        if ([aview isKindOfClass:[UITextField class]]) {
            [aview resignFirstResponder];
        }
    }
}
@end
