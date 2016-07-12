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
#import "UIImageView+Tool.h"
//现在支付
//#import "IpaynowPluginApi.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
//汇付宝
//#import <HeePay/HeepaySDKManager.h>     //SDK头文件 必须导入。
//网站+产品id=产品号
#define AppleIdPayProductId @"com.imchumo.social"
#define PayAPPKeyOfNow @"StrangerChat1452244028173291"

#define IS_STRING_NULL_OR_EMPTY(x) ((x)==nil || (x).length<=0)
//所在ip地址
#import <ifaddrs.h>
#import <arpa/inet.h>
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

typedef enum{
    payRequsestFlagZFB=1,//支付宝
    payRequsestFlagWX=2,//微信
    payRequsestFlagXT = 3,
    payRequsestFlagYIL = 4,
    
    payRequsestFlagZF=6,//现在支付宝
    payRequsestFlagYL=7,//现在银联
    payRequsestFlagNG=8,//内购
    payRequsestFlagHFBYL=9,//汇付宝银联
    payRequsestFlagHFBZF=12,//汇付宝支付宝
    payRequsestFlagHFBWX=11,//汇付宝微信
    
}payRequsestFlag;
@protocol JYPayWorkingDelegate <NSObject>

- (void) noticePayResult:(BOOL)issuccess msg:(NSString *)msg;
@end
@interface JYPayWorking : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate,WXApiDelegate>
@property (nonatomic,assign)id<JYPayWorkingDelegate> delegate;
@property (nonatomic,strong)MBProgressHUD *HUD;

/**
 *  记录当前购买的商品的订单信息
 */
@property (nonatomic,strong)NSDictionary *goodsInfo;

+ (JYPayWorking *)shareJYPayWorking;
//下单
- (void)PaydataRuquesByGoodId:(NSString *)goodId payType:(NSString *)payType success:(void (^)(NSDictionary * dic)) success;
//微信
- (void)sendPay_demo:(NSDictionary*) wxpayDic;//wxpayDic:请求参数
//支付宝
- (void)sendZFBPay_demo:(NSDictionary*) wxpayDic;
//现在银联
-(void)payByType:(NSDictionary *)payDic;//payDic:请求参数
//苹果内购
- (void)getProductInfo:(NSString *)ProductID info:(NSDictionary *) info;//TradeNo:订单和ProductID:产品号
- (void)startPayWorking;//开始购买流程
//汇付宝
- (void) payByHUIFUBAOAndPayInfo:(NSDictionary *)wxpayDic;
@end
