//
//  JYPayWorking.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "JYPayWorking.h"

static bool hasAddObserver=NO;
@interface JYPayWorking () {
    
    NSString *_outTradeNo;
    SKProduct *_myProductNo;
}

@end

@implementation JYPayWorking

+ (JYPayWorking *)shareJYPayWorking{
    static JYPayWorking* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}
-(instancetype)init{
    if (self=[super init]) {
        // 监听购买结果
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
    
}
#pragma mark ----  下单
/**
 *  下单
 *
 *  @param goodId  产品编号
 *  @param payInteger 支付方式
 */
- (void)PaydataRuquesByGoodId:(NSString *)goodId payType:(NSString *)payType success:(void (^)(NSDictionary * dic)) success{ // 下单
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *appid = [NSGetTools getBundleID];
    
    NSString *url = [NSString stringWithFormat:@"%@f_124_10_1.service?m16=%@&a153=%@&a130=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,appid,goodId,payType,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
        success(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
    
}
#pragma mark ----  微信支付
- (void)sendPay_demo:(NSDictionary*) wxpayDic
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc] ;
    //初始化支付签名对象
    [req init:wxpayDic[@"appid"] mch_id:wxpayDic[@"mch_id"]];
    //设置密钥
    [req setKey:wxpayDic[@"key"]];
    
    //}}}
    //获取到实际调起微信支付的参数后，进行二次签名
    NSMutableDictionary *dict = [req sendPay_demononcestr:wxpayDic[@"nonce_str"] prepay_id:wxpayDic[@"prepay_id"]];
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [_delegate noticePayResult:NO msg:@"支付失败"];
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}
#pragma mark ----  现在支付
-(void)payByType:(NSDictionary *)payDic{
    //拼接请求参数
    NSString *str = [NSString stringWithFormat:@"%.0f",[payDic[@"mhtOrderAmt"] floatValue]*100 ,nil];
    NSMutableDictionary *signDict = [NSMutableDictionary dictionary];
    [signDict setObject:payDic[@"appId"] forKey:@"appId"];
    [signDict setObject:payDic[@"mhtOrderNo"] forKey:@"mhtOrderNo"];
    [signDict setObject:payDic[@"mhtOrderName"] forKey:@"mhtOrderName"];
    [signDict setObject:payDic[@"mhtOrderType"] forKey:@"mhtOrderType"];
    [signDict setObject:payDic[@"mhtCurrencyType"] forKey:@"mhtCurrencyType"];
    [signDict setObject:str forKey:@"mhtOrderAmt"];
    [signDict setObject:payDic[@"mhtOrderDetail"] forKey:@"mhtOrderDetail"];
    [signDict setObject:payDic[@"mhtOrderStartTime"] forKey:@"mhtOrderStartTime"];
    [signDict setObject:payDic[@"notifyUrl"] forKey:@"notifyUrl"];
    [signDict setObject:payDic[@"mhtCharset"] forKey:@"mhtCharset"];
    [signDict setObject:@"3600" forKey:@"mhtOrderTimeOut"];
    //    [signDict setObject:wxpayDic[@"mhtSignType"] forKey:@"mhtSignType"];
    [signDict setObject:payDic[@"outTradeNo"] forKey:@"outTradeNo"];
    [signDict setObject:payDic[@"payChannelType"] forKey:@"payChannelType"];
    
    
    // 客户端MD5
    //1.先按顺序组成字符串
    NSArray* arr = [signDict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    NSString *key1 = arr[0];
    
    NSString *preSignString = [NSString stringWithFormat:@"%@=%@",key1,signDict[key1]];
    
    for (int a = 1; a < [arr count]; a++) {
        NSString *key = arr[a];
        NSString *str2 = [NSString stringWithFormat:@"&%@=%@",key,signDict[key]];
        preSignString = [preSignString stringByAppendingString:str2];
        
    }
    
    //2.第二步对密钥MD5
    NSString *privateStr = payDic[@"md5Key"];
    NSString *secondStr = [self md5:privateStr];
    NSLog(@"---secondStr = %@",secondStr);
    
    //3.第三步拼接
    NSString *thirdStr = [NSString stringWithFormat:@"%@&%@",preSignString,secondStr];
    
    NSString *MDStr  = [self md5:thirdStr];
    
    NSLog(@"---%@ = %@",thirdStr,MDStr);
    NSString *payStr = [NSString stringWithFormat:@"%@&mhtSignature=%@&mhtSignType=MD5",preSignString,MDStr];
    
    [IpaynowPluginApi pay:payStr AndScheme:PayAPPKeyOfNow viewController:_delegate delegate:self];
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(void)IpaynowPluginResult:(IPNPayResult)result errCode:(NSString *)errCode errInfo:(NSString *)errInfo{
    NSString *resultString=nil;
    switch (result) { // UIAlertView
        case IPNPayResultSuccess: {
            
            resultString=@"支付成功";
            [_delegate noticePayResult:YES msg:@"支付成功"];
        }
            break;
        case IPNPayResultCancel:
            [_delegate noticePayResult:NO msg:@"支付被取消"];
            resultString=@"支付被取消";
            break;
        case IPNPayResultFail:
            [_delegate noticePayResult:NO msg:@"支付失败"];
            resultString=[NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errCode, errInfo];
            break;
        case IPNPayResultUnknown:
            [_delegate noticePayResult:NO msg:@"支付失败"];
            resultString=[NSString stringWithFormat:@"支付结果未知:%@",errInfo];
            break;
            
        default:
            break;
    }
}
#pragma mark ----  苹果内购

// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo:(NSString *)ProductID TradeNo:(NSString*) TradeNo {
    _outTradeNo=TradeNo;
    NSString *appleId = [NSString stringWithFormat:@"%@%@",AppleIdPayProductId,ProductID];
    NSSet * set = [NSSet setWithArray:@[appleId]];
    [self p_setupProgressHud];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        return;
    }
    
    
    NSString *str=_outTradeNo;
    if (nil==str|| NULL==str || [str isKindOfClass:[NSNull class]] ||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return ;
    }else{
        _myProductNo=myProduct[0];
        [self alertActionByMeg:[NSString stringWithFormat:@"%@",[myProduct[0] localizedDescription],nil]];
    }
    
    
}
-(void)startPayWorking{
    SKPayment * payment = [SKPayment paymentWithProduct:_myProductNo];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
-(void)dealloc{
    hasAddObserver=NO;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                
                [self completeTransaction:transaction];
                
                break;
            }
            case SKPaymentTransactionStateFailed://交易失败
            {
                
                [self failedTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                [self restoreTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                
                break;
            default:
                break;
        }
    }
}
//验证凭证,到苹果服务器
- (void)verifyPruchase:(NSString *)bookid
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    
    //    NSData* originData = [@"1000000196678278" dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSData* encodeData = [GTMBase64 encodeData:originData];
    //
    //    NSString *encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    //    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", bookid];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"服务器返回:%@", dict);
    
    if (dict != nil) {
        [_delegate noticePayResult:YES msg:@"成功"];
        NSLog(@"验证成功");
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    
    NSString * productIdentifier = transaction.payment.productIdentifier;
    
    NSData* encodeData = [GTMBase64 encodeData:transaction.transactionReceipt];
    
    NSString *encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    if ([encodeResult length] > 0) {
        
        NSArray *tt = [productIdentifier componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            //先苹果服务器验证
            //            [self verifyPruchase:encodeResult];
            NSString *str=_outTradeNo;
            if (nil==str|| NULL==str || [str isKindOfClass:[NSNull class]] ||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                [self.HUD hide:YES];
            }else{
                //向服务器验证
                [self sendverifyPruchase:encodeResult];
            }
            
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
//验证凭证,向自己的服务器,发送base64验证凭证
- (void) sendverifyPruchase:(NSString *)encodeResult{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@apple/callBack.service?orderNum=%@&receipt=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,_outTradeNo,encodeResult,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
        if ([dic[@"body"] isEqualToString:@"success"]) {
            [_delegate noticePayResult:YES msg:@"成功"];
            
        }else{
            [_delegate noticePayResult:NO msg:@"购买失败"];
            
        }
        [self.HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
        [self.HUD hide:YES];
    }];
    
    
}
//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        [_delegate noticePayResult:NO msg:@"购买失败"];
    } else {
        NSLog(@"用户取消交易");
        [_delegate noticePayResult:NO msg:@"用户取消交易"];
    }
    [self.HUD hide:YES];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)p_setupProgressHud
{
    self.HUD = [[MBProgressHUD alloc]initWithView: [(UIViewController *)_delegate view]];
    _HUD.frame = [[(UIViewController *)_delegate view] bounds];
    _HUD.minSize = CGSizeMake(100, 100);
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.color=[UIColor colorWithWhite:0.000 alpha:0.400];
    [[(UIViewController *)_delegate view] addSubview:_HUD];
    [_HUD show:YES];
}
#pragma mark ----弹窗

- (void) alertActionByMeg:(NSString*)meg{
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"我要购买" message:meg preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self startPayWorking];
        
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.HUD hide:YES];
        return ;
    }];
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    [(UIViewController *)_delegate presentViewController:alertController animated:YES completion:nil];
}
@end
