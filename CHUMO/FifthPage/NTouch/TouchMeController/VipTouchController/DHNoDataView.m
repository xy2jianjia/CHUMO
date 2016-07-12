//
//  DHNoDataView.m
//  CHUMO
//
//  Created by xy2 on 16/2/18.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHNoDataView.h"

@implementation DHNoDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = kUIColorFromRGB(0xf0edf2);
        [self setnodataView];
    }
    return self;
}

- (void)gotoVc:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(emptyView:btnTag:)]) {
        [self.delegate emptyView:self btnTag:0];
    }
}
- (void)setnodataView{
    self.nodataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.bounds)-239/2, 10, 239, 290)];
    
    [self addSubview:_nodataImageView];
    self.doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"key-normal"] forState:(UIControlStateNormal)];
    _doneBtn.backgroundColor = kUIColorFromRGB(0x934de6);
    _doneBtn.layer.masksToBounds = YES;
    _doneBtn.layer.cornerRadius = 20.0f;
    [_doneBtn setTitle:@"现在去" forState:(UIControlStateNormal)];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _doneBtn.frame = CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds)-150/2, CGRectGetMaxY(_nodataImageView.frame)+25, 150, 40);
    [_doneBtn addTarget:self action:@selector(gotoVc:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_doneBtn];
}

-(void)layoutSubviews{
    self.frame = [[UIScreen mainScreen] bounds];
    CGRect imageVtemp = self.nodataImageView.frame;
    
    if (iPhone5) {
        imageVtemp.origin.y = 40;
    }else if (iPhone6){
        imageVtemp.origin.x = CGRectGetMidX([UIScreen mainScreen].bounds)-320/2;
        imageVtemp.origin.y = 40;
        imageVtemp.size.width = 320;
        imageVtemp.size.height = 390;
    }else if (iPhonePlus){
        imageVtemp.origin.x = CGRectGetMidX([UIScreen mainScreen].bounds)-350/2;
        imageVtemp.origin.y = 40;
        imageVtemp.size.width = 350;
        imageVtemp.size.height = 430;
    }
    self.nodataImageView.frame = imageVtemp;
    _doneBtn.frame = CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds)-150/2, CGRectGetMaxY(_nodataImageView.frame)+25, 150, 40);
}
@end
