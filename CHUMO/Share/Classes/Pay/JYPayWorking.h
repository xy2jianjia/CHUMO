//
//  JYPayWorking.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <CommonCrypto/CommonDigest.h>
//现在支付
#import "IpaynowPluginApi.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
//网站+产品id=产品号
#define AppleIdPayProductId @"com.imchumo.social"
#define PayAPPKeyOfNow @"StrangerChat1452244028173291"
typedef enum{
    payRequsestFlagZF=6,
    payRequsestFlagWX=2,
    payRequsestFlagYL=7,
    payRequsestFlagNG=8,
}payRequsestFlag;
@protocol JYPayWorkingDelegate <NSObject>

- (void) noticePayResult:(BOOL)issuccess msg:(NSString *)msg;
@end
@interface JYPayWorking : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate,IpaynowPluginDelegate,WXApiDelegate>
@property (nonatomic,assign)id<JYPayWorkingDelegate> delegate;
@property (nonatomic,strong)MBProgressHUD *HUD;
+ (JYPayWorking *)shareJYPayWorking;
//下单
- (void)PaydataRuquesByGoodId:(NSString *)goodId payType:(NSString *)payType success:(void (^)(NSDictionary * dic)) success;
//微信
- (void)sendPay_demo:(NSDictionary*) wxpayDic;//wxpayDic:请求参数
//现在银联
-(void)payByType:(NSDictionary *)payDic;//payDic:请求参数
//苹果内购
- (void)getProductInfo:(NSString *)ProductID TradeNo:(NSString*) TradeNo;//TradeNo:订单和ProductID:产品号
- (void)startPayWorking;//开始购买流程
@end
