//
//  UpgradeView.m
//  CHUMO
//
//  Created by xy2 on 16/5/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "UpgradeView.h"
#define screen [[UIScreen mainScreen] bounds]
@implementation UpgradeView

+ (UIView *)configUpgradeViewWithType:(NSInteger )tipType inview:(UIView *)inview versionDict:(NSDictionary *)versionDict{
    
    return [[[UpgradeView alloc]init] configUpgradeViewWithType:tipType inview:inview versionDict:versionDict];
    
}
- (UIView *)configUpgradeViewWithType:(NSInteger )tipType inview:(UIView *)inview versionDict:(NSDictionary *)versionDict{
    self.upgrade_dict = [versionDict copy];
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(screen), 0, 0, 0)];
    
    // 设置frame位置
    if (iPhone6 || iPhonePlus) {
        bgView.frame = CGRectMake(52.5, 164, inview.bounds.size.width-105, inview.bounds.size.height-350);
        
    }else if (iPhone4 || iPhone5){
        bgView.frame = CGRectMake(30, 164, inview.bounds.size.width-60, inview.bounds.size.height-350);
    }else{
        bgView.frame = CGRectMake(52.5, 164, inview.bounds.size.width-105, inview.bounds.size.height-350);
    }
    
    bgView.backgroundColor = [UIColor clearColor];
    //头部
    UIImageView *headerimag=[[UIImageView alloc]initWithFrame:CGRectMake(0, -20, CGRectGetWidth(bgView.bounds), 120)];
    headerimag.image=[UIImage imageNamed:@"w_shengji_banner_top"];
    [bgView addSubview:headerimag];
    if (tipType == 2) {
        // 24小时内，非强制更新，显示关闭按钮
        // 关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"w_tk_close"] forState:(UIControlStateNormal)];
        closeBtn.frame = CGRectMake(CGRectGetMaxX(bgView.bounds)-5-18, CGRectGetMinY(bgView.bounds)+5, 18, 18);
        [closeBtn addTarget:self action:@selector(didClosedBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:closeBtn];
    }
    
    
    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor=[UIColor whiteColor];
    
    // title
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(CGRectGetMinX(bgView.bounds), 0, CGRectGetWidth(bgView.bounds), 30);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor colorWithWhite:0.196 alpha:1.000];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@",[versionDict objectForKey:@"b6"]];
    [contentView addSubview:titleLabel];
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.frame = CGRectMake(CGRectGetMinX(bgView.bounds), CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(bgView.bounds), 20);
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textColor=[UIColor colorWithWhite:0.400 alpha:1.000];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    NSString *serverVersion = [versionDict objectForKey:@"b82"];
    versionLabel.text = [NSString stringWithFormat:@"V%@",serverVersion];
    [contentView addSubview:versionLabel];
    
    // content
    UITextView *contentLabel = [[UITextView alloc]init];
    contentLabel.editable = NO;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.frame = CGRectMake(CGRectGetMinX(bgView.bounds)+15, CGRectGetMaxY(versionLabel.frame)+5, CGRectGetWidth(bgView.bounds)-30, 100);
    contentLabel.font = [UIFont systemFontOfSize:13];
    //    contentLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *password = [dict objectForKey:@"password"];
    // 更新类型:1:商店版,2:企业版
    NSInteger upgradeType = [[versionDict objectForKey:@"b78"] integerValue];
    if (upgradeType==1) {
        contentLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n账号：%@\n密码：%@\n",[versionDict objectForKey:@"b76"],@"请截屏保存您的账号密码",[NSGetTools getUserAccount],password];
    }else{
        contentLabel.text = [NSString stringWithFormat:@"%@\n",[versionDict objectForKey:@"b76"]];
    }
    
    [contentView addSubview:contentLabel];
    
    //     线
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(CGRectGetMinX(bgView.bounds), CGRectGetMaxY(contentLabel.frame)+19, CGRectGetWidth(bgView.bounds), 1);
    line.backgroundColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
    [contentView addSubview:line];
    
    
    
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (upgradeType == 1) {
        //升商店版
        searchBtn.frame = CGRectMake(CGRectGetMinX(bgView.bounds), CGRectGetMaxY(line.frame)+0, CGRectGetWidth(bgView.bounds), 44);
        [searchBtn setTitle:@"去下载" forState:(UIControlStateNormal)];
        [searchBtn setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
        [searchBtn addTarget:self action:@selector(didDownloadBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [contentView addSubview:searchBtn];
        
        
    }else if (upgradeType == 2){
        // 稍后btn
        
        searchBtn.frame = CGRectMake(CGRectGetMinX(bgView.bounds), CGRectGetMaxY(line.frame)+0, CGRectGetWidth(bgView.bounds)/2-0.5, 44);
        [searchBtn setTitle:@"稍后再说" forState:(UIControlStateNormal)];
        [searchBtn setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
        [searchBtn addTarget:self action:@selector(didClosedBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [contentView addSubview:searchBtn];
        
        // 线
        UIView *lineV = [[UIView alloc]init];
        lineV.frame = CGRectMake(CGRectGetMaxX(searchBtn.frame), CGRectGetMinY(searchBtn.frame), 1, CGRectGetHeight(searchBtn.frame));
        lineV.backgroundColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
        [contentView addSubview:lineV];
        // 去下载btn
        UIButton *downBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        downBtn.frame = CGRectMake(CGRectGetMaxX(lineV.frame), CGRectGetMinY(searchBtn.frame), CGRectGetWidth(searchBtn.frame)-0.5, CGRectGetHeight(searchBtn.frame));
        [downBtn setTitle:@"立即去更新" forState:(UIControlStateNormal)];
        [downBtn setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
        downBtn.backgroundColor=[UIColor whiteColor];
        [downBtn addTarget:self action:@selector(didDownloadBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [contentView addSubview:downBtn];
    }
    contentView.frame=CGRectMake(0, CGRectGetMaxY(headerimag.frame), CGRectGetWidth(bgView.frame), CGRectGetMaxY(searchBtn.frame));
    //使用贝塞尔曲线设置左上 右上圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    
    //只能描绘边缘  不能填充
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineCap = kCALineCapSquare;
    contentView.layer.mask = maskLayer;
    [bgView addSubview:contentView];
    
    [self addSubview:bgView];
    self.frame = screen;
    [inview addSubview:self];
    // 设置frame位置
    if (iPhone6 || iPhonePlus) {
        bgView.frame = CGRectMake(52.5, 164, inview.bounds.size.width-105, CGRectGetHeight(titleLabel.frame)+10+CGRectGetHeight(contentLabel.frame)+5+CGRectGetHeight(line.frame)+19+44+18+100);
    }else if (iPhone4 || iPhone5){
        bgView.frame = CGRectMake(30, 100, inview.bounds.size.width-60, CGRectGetHeight(titleLabel.frame)+10+CGRectGetHeight(contentLabel.frame)+5+CGRectGetHeight(line.frame)+19+44+18+100);
    }else{
        bgView.frame = CGRectMake(30, 154, inview.bounds.size.width-60, CGRectGetHeight(titleLabel.frame)+10+CGRectGetHeight(contentLabel.frame)+5+CGRectGetHeight(line.frame)+19+44+18+100);
    }
    return bgView;
}
- (void)didDownloadBtn{
    // 更新类型:1:商店版,2:企业版
    NSInteger upgradeType = [[self.upgrade_dict objectForKey:@"b78"] integerValue];
    
    if (upgradeType == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.imchumo.com/?m=store"]];
    }else if (upgradeType == 2){
        [self asyncUpgradeWithEnterprise];
    }
    
    
    // 是否强制更新1:强制;2:非强制
    NSInteger isForceUpgrade = [[self.upgrade_dict objectForKey:@"b147"] integerValue];
    if (isForceUpgrade == 2) {
        [self didClosedBtn];
    }
    
}
- (void)didSearchBtn{
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    // 是否强制更新1:强制;2:非强制
    NSInteger isForceUpgrade = [[self.upgrade_dict objectForKey:@"b147"] integerValue];
    if (isForceUpgrade == 2) {
        [self didClosedBtn];
    }
    [self saveCollect];
}

- (void)didClosedBtn{
    [self removeFromSuperview];
}
- (void)asyncUpgradeWithEnterprise{
    NSString *url1 = [self.upgrade_dict objectForKey:@"b18"];
    NSString *downURL =[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",url1];
    NSString *url = [downURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:URL];
    });
    [self saveCollect];
}
/**
 *  保存升级统计
 */
- (void)saveCollect{
    
    NSString *version = [NSGetTools getAppVersion];
    NSString *appName = [NSGetTools getAPPName];
    
    [HttpOperation asyncCollectUpgradeSaveWithOldAppVer:version oldAppName:appName queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存升级统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
//            [alert show];
        });
    }];
}



@end
