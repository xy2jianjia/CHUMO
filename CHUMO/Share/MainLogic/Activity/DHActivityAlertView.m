//
//  DHActivityAlertView.m
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHActivityAlertView.h"

#define screen [[UIScreen mainScreen] bounds]
@implementation DHActivityAlertView

+ (DHActivityAlertView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHActivityAlertViewDelegate>)delegate dataSource:(NSArray *)dataSource{
    
    return [[[DHActivityAlertView alloc]initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0)] configActivityAlertViewInView:inView delegate:delegate dataSource:dataSource];
    
}
- (DHActivityAlertView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHActivityAlertViewDelegate>)delegate dataSource:(NSArray *)dataSource{
    _dataArr = [dataSource copy];
    self.delegate = delegate;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
    UIView *bgView = [[UIView alloc]initWithFrame:inView.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    // 设置frame位置
    if (iPhone6 || iPhonePlus) {
        self.frame = CGRectMake(52.5, 164, inView.bounds.size.width-105, 105+20*(dataSource.count + 1)+25*dataSource.count+15+30);
    }else if (iPhone4 || iPhone5){
        self.frame = CGRectMake(30, 100, inView.bounds.size.width-60, 105+20*(dataSource.count + 1)+25*dataSource.count+15+30);
    }else{
        self.frame = CGRectMake(52.5, 164, inView.bounds.size.width-105, 105+20*(dataSource.count + 1)+25*dataSource.count+15+30);
    }
    // 背景图片
    UIImageView *bgImageV = [[UIImageView alloc]init];
    bgImageV.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), 105);
    bgImageV.image = [UIImage imageNamed:@"w_bg_banner.png"];
    bgImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openDetail:)];
    [bgImageV addGestureRecognizer:tap];
    [self addSubview:bgImageV];
    
    UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"w_tk_close"] forState:(UIControlStateNormal)];
    closeBtn.frame = CGRectMake(CGRectGetMaxX(bgImageV.bounds)-5-18, CGRectGetMinY(bgImageV.bounds)+5, 18, 18);
    [closeBtn addTarget:self action:@selector(didClosedBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImageV addSubview:closeBtn];
    
    // 商品列表
    for (int i = 0; i < dataSource.count ; i ++) {
        YS_PayModel *item = [dataSource objectAtIndex:i];
        CGSize titleSize = [self hightForContent:item.b51 fontSize:12];
        // 每行背景
        UIView *listView = [[UIView alloc]init];
        listView.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(bgImageV.frame)+20*(i+1)+i*25, CGRectGetWidth(self.bounds), 25);
        // 商品名称
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(CGRectGetMinX(listView.bounds)+10, CGRectGetMinY(listView.bounds), titleSize.width, CGRectGetHeight(listView.bounds));
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kUIColorFromRGB(0x323232);
//        titleLabel.backgroundColor = [UIColor yellowColor];
        titleLabel.text = item.b51;
        [listView addSubview:titleLabel];
        // 优惠
        UILabel *preferentialLabel = [[UILabel alloc]init];
        preferentialLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, CGRectGetMinY(listView.bounds), (CGRectGetWidth(listView.bounds) -45-40)-titleSize.width, CGRectGetHeight(titleLabel.frame));
        preferentialLabel.font = [UIFont systemFontOfSize:12];
        preferentialLabel.textAlignment = NSTextAlignmentLeft;
        preferentialLabel.textColor = kUIColorFromRGB(0xe62739);
        preferentialLabel.text = item.b48;
//        preferentialLabel.backgroundColor = [UIColor greenColor];
        [listView addSubview:preferentialLabel];
        // 充值按钮
        UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        payBtn.frame = CGRectMake(CGRectGetWidth(listView.bounds)-10-45, CGRectGetMinY(preferentialLabel.frame), 45, CGRectGetHeight(preferentialLabel.frame));
        payBtn.backgroundColor = kUIColorFromRGB(0x934de6);
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.cornerRadius = 11;
        payBtn.tag = i;
        [payBtn setTitle:@"充值" forState:(UIControlStateNormal)];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [payBtn addTarget:self action:@selector(payAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [listView addSubview:payBtn];
        [self addSubview:listView];
        
    }
    UIButton *conformBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    conformBtn.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds)-40, CGRectGetWidth(self.bounds), 30);
    [conformBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    conformBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    conformBtn.layer.borderWidth = 0.5;
    conformBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [conformBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [conformBtn addTarget:self action:@selector(conformBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:conformBtn];
    [bgView addSubview:self];
    [inView addSubview:bgView];
    return self;
}
- (void)conformBtnAction{
    [self didClosedBtn];
}
- (void)payAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityOnclickedWithModel:)]) {
        if (_dataArr.count > sender.tag) {
            [self.delegate activityOnclickedWithModel:[_dataArr objectAtIndex:sender.tag]];
        }
    }
//    [self.superview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self removeFromSuperview];
    [self.superview removeFromSuperview];
    
}
/**
 *  活动详情
 *
 *  @param sender 
 */
- (void)openDetail:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityOnclickedActivityDetail)]) {
        [self.delegate activityOnclickedActivityDetail];
    }
}
- (void)didClosedBtn{
    [self.superview removeFromSuperview];
}

- (CGSize)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake((CGRectGetWidth(screen)-60 - 45 - 40), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
@end
