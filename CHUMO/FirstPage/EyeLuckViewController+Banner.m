//
//  EyeLuckViewController+Banner.m
//  CHUMO
//
//  Created by xy2 on 16/4/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "EyeLuckViewController+Banner.h"
#import "DHBannerModel.h"
#import "DHBannerViewController.h"
@implementation EyeLuckViewController (Banner)

- (void)asyncGetBannerList:(void(^)(UIView *bannerView,NSArray *arr))completed{
    self.bannerArr = [NSMutableArray array];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *info = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_135_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,info];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            for (NSDictionary *dict in modelArr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    DHBannerModel *item = [[DHBannerModel alloc]init];
                    [item setValuesForKeysWithDictionary:dict];
                    [self.bannerArr addObject:item];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 UIView *aview = [self configView];
                completed(aview,self.bannerArr);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (UIView *)configView{
    NSMutableArray *arr = [NSMutableArray array];
    for (DHBannerModel *item in self.bannerArr) {
        [arr addObject:item.b181];
    }
    CGRect temp = CGRectMake(0, 0, ScreenWidth, 64);
    if (self.bannerArr.count == 1) {
        UIView *bannerView = [[UIView alloc]init];
        bannerView.frame = temp;
        UIImageView *imagev = [[UIImageView alloc]init];
        imagev.frame = bannerView.bounds;
        [imagev sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@""]];
        [bannerView addSubview:imagev];
        [self.view addSubview:bannerView];
        
        // 关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"w_tk_close"] forState:(UIControlStateNormal)];
        closeBtn.frame = CGRectMake(CGRectGetMaxX(bannerView.bounds)-5-18, CGRectGetMinY(bannerView.bounds)+5, 18, 18);
        [closeBtn addTarget:self action:@selector(didClosedBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [bannerView addSubview:closeBtn];
        
        return bannerView;
    }else if (self.bannerArr.count > 1){
        SDCycleScrollView *scv = [SDCycleScrollView cycleScrollViewWithFrame:temp imageURLStringsGroup:arr];
        scv.delegate = self;
        scv.autoScrollTimeInterval = 5.0f;
        [self.view addSubview:scv];
        // 关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"w_tk_close"] forState:(UIControlStateNormal)];
        closeBtn.frame = CGRectMake(CGRectGetMaxX(scv.bounds)-5-18, CGRectGetMinY(scv.bounds)+5, 18, 18);
        [closeBtn addTarget:self action:@selector(didClosedBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [scv addSubview:closeBtn];
        
        
        return scv;
    }
    return nil;
}
- (void)didClosedBtn:(UIButton *)sender{
    UIView *view = [sender superview];
    [view removeFromSuperview];
    
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect temp = self.collectionView.frame;
        temp.origin.y = 0;
        temp.size.height=ScreenHeight;
        self.collectionView.frame = temp;
    } completion:^(BOOL finished) {
        
    }];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    DHBannerViewController *vc = [[DHBannerViewController alloc]init];
    vc.bannerItem = [self.bannerArr objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
