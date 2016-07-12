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
    [self p_setupProgressHud];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_124_10_1.service?a153=%@&a130=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,goodId,payType,p1,p2,appInfo];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wxPay_goodsInfos"];
    _goodsInfo = [wxpayDic copy];
    [[NSUserDefaults standardUserDefaults] setObject:_goodsInfo forKey:@"wxPay_goodsInfos"];
    dispatch_async(dispatch_get_main_queue(), ^{
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
            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
                [_delegate noticePayResult:NO msg:@"支付失败"];
                [self.HUD hide:YES];
            }
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
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:@"WXissendReq"];
            [userDefaults synchronize];
            
            [self.HUD hide:YES];
        }
    });
    
}
#pragma mark   ==============原生支付宝==============
//
//选中商品调用支付宝极简支付
//
- (void)sendZFBPay_demo:(NSDictionary*) wxpayDic
{
    
    _goodsInfo = [wxpayDic copy];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = wxpayDic[@"partner"];
    NSString *seller = wxpayDic[@"seller_email"];
    NSString *privateKey = wxpayDic[@"private_key"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        
        [_delegate noticePayResult:NO msg:@"缺少partner或者seller或者私钥"];
        [self.HUD hide:YES];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = wxpayDic[@"outTradeNo"]; //订单ID（由商家自行制定）
    order.productName = wxpayDic[@"subject"]; //商品标题
    order.amount = [NSString stringWithFormat:@"%.2f",[wxpayDic[@"total_fee"] floatValue]]; //商品价格
    order.notifyURL =  wxpayDic[@"notify_url"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"imchumosocialApp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [self.HUD hide:YES];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            switch ([resultDic[@"resultStatus"] integerValue]) {
                case 8000:
                {
                    [self.HUD hide:YES];
                    [_delegate noticePayResult:NO msg:@"正在处理中"];
                }
                    break;
                case 4000:
                {
                    [self.HUD hide:YES];
                    [_delegate noticePayResult:NO msg:@"订单支付失败"];
                }
                    break;
                case 6002:
                {
                    [self.HUD hide:YES];
                    [_delegate noticePayResult:NO msg:@"网络连接出错"];
                }
                    break;
                case 6001:
                {
                    [self.HUD hide:YES];
                    [_delegate noticePayResult:NO msg:@"支付已经取消"];
                }
                    break;
                case 9000:
                {
                    [self.HUD hide:YES];
                    // 保存用户支付成功的日期
                    [self saveCollectPayWithGoodsInfo:wxpayDic];
                    [_delegate noticePayResult:YES msg:@"订单支付成功"];
                }
                    break;
                    
                default:
                    break;
            }
            [self.HUD hide:YES];
        }];
    }
    
}
/**
 *  保存支付日期，用于判断机器人机制 --bydh 2016年06月14日15:41:43
 */
- (void)saveCollectPayWithGoodsInfo:(NSDictionary *)goodsInfo{
//    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *today = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    //    [[NSUserDefaults standardUserDefaults] setObject:today forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
//    //明天时间
//    NSString *tomorrow = [[fmt stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay]] substringWithRange:NSMakeRange(0, 10)];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",tomorrow,userId]];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    // 某用户某天注册的
    BOOL istodayReg = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
    NSInteger newer = 2;
    if (istodayReg) {
        newer = 1;
    }else{
        newer = 2;
    }
    NSInteger payType = [[goodsInfo objectForKey:@"dh_payType"] integerValue];
    float price = 0.0;
    NSString *orderNum = [goodsInfo objectForKey:@"outTradeNo"];
    switch (payType) {
            // 支付宝
        case payRequsestFlagZFB:
            price = [[goodsInfo objectForKey:@"total_fee"] floatValue];
            break;
            // 微信
        case payRequsestFlagWX:
            price = [[goodsInfo objectForKey:@"realFeel"] floatValue];
            break;
//            // 系统
//        case payRequsestFlagXT:
//            price = [[goodsInfo objectForKey:@"total_fee"] floatValue];
//            orderNum = [goodsInfo objectForKey:@"outTradeNo"];
//            break;
            // 易联
        case payRequsestFlagYIL:
            price = [[goodsInfo objectForKey:@"amount"] floatValue];
            break;
            // 现在支付宝
        case payRequsestFlagZF:
            price = [[goodsInfo objectForKey:@"mhtOrderAmt"] floatValue];
            break;
//            // 现在银联
//        case payRequsestFlagYL:
//            price = [[goodsInfo objectForKey:@"total_fee"] floatValue];
//            orderNum = [goodsInfo objectForKey:@"outTradeNo"];
//            break;
            // 苹果内购
        case payRequsestFlagNG:
            price = [[goodsInfo objectForKey:@"total_fee"] floatValue];
            break;
            // 汇付宝银联
        case payRequsestFlagHFBYL:
            price = [[goodsInfo objectForKey:@"pay_amt"] floatValue];
            break;
            // 汇付宝支付宝
        case payRequsestFlagHFBZF:
            price = [[goodsInfo objectForKey:@"pay_amt"] floatValue];
            break;
            // 汇付宝微信
        case payRequsestFlagHFBWX:
            price = [[goodsInfo objectForKey:@"pay_amt"] floatValue];
            break;
            
        default:
            // 没有数据就停止
            return;
            break;
    }
    
    NSString *goodId = [goodsInfo objectForKey:@"dh_goodId"];
    
    [HttpOperation asyncCollectPaySaveWithPayType:payType price:price status:1 goodCode:goodId orderNum:orderNum userType:newer queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存支付统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
//            [alert show];
        });
    }];
    
    
}
#pragma mark ----  现在支付
//-(void)payByType:(NSDictionary *)payDic{
//    _goodsInfo = [payDic copy];
//    //拼接请求参数
//    NSString *str = [NSString stringWithFormat:@"%.0f",[payDic[@"mhtOrderAmt"] floatValue]*100 ,nil];
//    NSMutableDictionary *signDict = [NSMutableDictionary dictionary];
//    [signDict setObject:payDic[@"appId"] forKey:@"appId"];
//    [signDict setObject:payDic[@"mhtOrderNo"] forKey:@"mhtOrderNo"];
//    [signDict setObject:payDic[@"mhtOrderName"] forKey:@"mhtOrderName"];
//    [signDict setObject:payDic[@"mhtOrderType"] forKey:@"mhtOrderType"];
//    [signDict setObject:payDic[@"mhtCurrencyType"] forKey:@"mhtCurrencyType"];
//    [signDict setObject:str forKey:@"mhtOrderAmt"];
//    [signDict setObject:payDic[@"mhtOrderDetail"] forKey:@"mhtOrderDetail"];
//    [signDict setObject:payDic[@"mhtOrderStartTime"] forKey:@"mhtOrderStartTime"];
//    [signDict setObject:payDic[@"notifyUrl"] forKey:@"notifyUrl"];
//    [signDict setObject:payDic[@"mhtCharset"] forKey:@"mhtCharset"];
//    [signDict setObject:@"3600" forKey:@"mhtOrderTimeOut"];
//    //    [signDict setObject:wxpayDic[@"mhtSignType"] forKey:@"mhtSignType"];
//    [signDict setObject:payDic[@"outTradeNo"] forKey:@"outTradeNo"];
//    [signDict setObject:payDic[@"payChannelType"] forKey:@"payChannelType"];
//    
//    
//    // 客户端MD5
//    //1.先按顺序组成字符串
//    NSArray* arr = [signDict allKeys];
//    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//        NSComparisonResult result = [obj1 compare:obj2];
//        return result==NSOrderedDescending;
//    }];
//    
//    NSString *key1 = arr[0];
//    
//    NSString *preSignString = [NSString stringWithFormat:@"%@=%@",key1,signDict[key1]];
//    
//    for (int a = 1; a < [arr count]; a++) {
//        NSString *key = arr[a];
//        NSString *str2 = [NSString stringWithFormat:@"&%@=%@",key,signDict[key]];
//        preSignString = [preSignString stringByAppendingString:str2];
//        
//    }
//    
//    //2.第二步对密钥MD5
//    NSString *privateStr = payDic[@"md5Key"];
//    NSString *secondStr = [self md5:privateStr];
//    NSLog(@"---secondStr = %@",secondStr);
//    
//    //3.第三步拼接
//    NSString *thirdStr = [NSString stringWithFormat:@"%@&%@",preSignString,secondStr];
//    
//    NSString *MDStr  = [self md5:thirdStr];
//    
//    NSLog(@"---%@ = %@",thirdStr,MDStr);
//    NSString *payStr = [NSString stringWithFormat:@"%@&mhtSignature=%@&mhtSignType=MD5",preSignString,MDStr];
//    
//    [IpaynowPluginApi pay:payStr AndScheme:PayAPPKeyOfNow viewController:_delegate delegate:self];
//}
//
//- (NSString *)md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}
//
//-(void)IpaynowPluginResult:(IPNPayResult)result errCode:(NSString *)errCode errInfo:(NSString *)errInfo{
//    NSString *resultString=nil;
//    switch (result) { // UIAlertView
//        case IPNPayResultSuccess: {
//            
//            resultString=@"支付成功";
//            // 保存用户支付成功的日期
////            [self saveCollectPayWithGoodsInfo:wxpayDic];
//            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
//                [self.HUD hide:YES];
//                [_delegate noticePayResult:YES msg:@"支付成功"];
//            }
//        }
//            break;
//        case IPNPayResultCancel:
//            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
//                [self.HUD hide:YES];
//                [_delegate noticePayResult:NO msg:@"支付被取消"];
//            }
//            resultString=@"支付被取消";
//            break;
//        case IPNPayResultFail:
//            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
//                [self.HUD hide:YES];
//                [_delegate noticePayResult:NO msg:@"支付失败"];
//            }
//            resultString=[NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errCode, errInfo];
//            break;
//        case IPNPayResultUnknown:
//            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
//                [self.HUD hide:YES];
//                [_delegate noticePayResult:NO msg:@"支付失败"];
//            }
//            resultString=[NSString stringWithFormat:@"支付结果未知:%@",errInfo];
//            break;
//            
//        default:
//            break;
//    }
//}
#pragma mark ----  苹果内购

// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo:(NSString *)ProductID info:(NSDictionary *) info {
    _goodsInfo = [info copy];
    _outTradeNo=[info objectForKey:@"outTradeNo"];
    NSString *appleId = [NSString stringWithFormat:@"%@%@",AppleIdPayProductId,ProductID];
    NSSet * set = [NSSet setWithArray:@[appleId]];
    
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
        [self alertActionByMeg:[NSString stringWithFormat:@"%@",[myProduct[0] localizedTitle],nil]];
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
    NSURL *url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
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
        NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
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
        if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
            [self.HUD hide:YES];
            // 保存用户支付成功的日期
//            [self saveCollectPayWithGoodsInfo:wxpayDic];
            [_delegate noticePayResult:YES msg:@"成功"];
        }
        NSLog(@"验证成功");
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    
    NSString * productIdentifier = transaction.payment.productIdentifier;

    NSData* encodeData = [GTMBase64 encodeData:transaction.transactionReceipt];
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString *encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if ([encodeResult length] > 0) {
        
        NSArray *tt = [productIdentifier componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            //先苹果服务器验证
//                        [self verifyPruchase:encodeResult];
            NSString *str=_outTradeNo;
            if (nil==str|| NULL==str || [str isKindOfClass:[NSNull class]] ||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                [self.HUD hide:YES];
            }else{
                //向服务器验证
                [self sendverifyPruchase:encodeStr];
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
    
//    NSString *url = [NSString stringWithFormat:@"%@apple/callBack.service?orderNum=%@&receipt=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,_outTradeNo,encodeResult,p1,p2,appInfo];
    NSString *url = [NSString stringWithFormat:@"%@apple/callBack.service?orderNum=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,_outTradeNo,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSDictionary *dict=@{@"receipt":encodeResult};
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
        if ([dic[@"body"] isEqualToString:@"success"]) {
            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
                [self.HUD hide:YES];
                // 保存用户支付成功的日期
                [self saveCollectPayWithGoodsInfo:_goodsInfo];
                [_delegate noticePayResult:YES msg:@"成功"];
            }
            
        }else{
            if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
                [self.HUD hide:YES];
                [_delegate noticePayResult:NO msg:@"购买失败"];
            }
            
            
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
        if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
        [_delegate noticePayResult:NO msg:@"购买失败"];
        }
    } else {
        NSLog(@"用户取消交易");
        if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
        [_delegate noticePayResult:NO msg:@"用户取消交易"];
        }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD = [[MBProgressHUD alloc]initWithView: [(UIViewController *)_delegate view]];
        _HUD.frame = [[(UIViewController *)_delegate view] bounds];
        _HUD.minSize = CGSizeMake(100, 100);
        _HUD.mode=MBProgressHUDModeCustomView;
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(0, 0, 50, 50);
        
        NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
        [imageV yh_setImage:url];
        imageV.animationDuration = 1.5; //执行一次完整动画所需的时长
        imageV.animationRepeatCount = 0;  //动画重复次数
        [imageV startAnimating];
        _HUD.customView=imageV;
        [[(UIViewController *)_delegate view] addSubview:_HUD];
        [_HUD show:YES];
    });
    
}
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
#pragma mark 汇付宝----银联
//- (void) payByHUIFUBAOAndPayInfo:(NSDictionary *)wxpayDic{
//    _goodsInfo = [wxpayDic copy];
//    /***** 启动 HeepaySDK相关代码 ****/
//    HeepaySDKManager * manager = [[HeepaySDKManager alloc] initWithDelegate:_delegate];
//    [manager invokeHeepaySDKWithTokenID:wxpayDic[@"token_id"] agentID:wxpayDic[@"agent_id"] agentBillID:wxpayDic[@"outTradeNo"] payType:[wxpayDic[@"pay_type"] integerValue]];
//    manager.resultBlock = ^(NSString * result){
//        
//        //当SDK返回商户APP时回调。返回result为支付状态的描述。支付结果也可以通过查询接口查到。
//        if (_delegate && [_delegate respondsToSelector:@selector(noticePayResult:msg:)]) {
//            [_delegate noticePayResult:NO msg:result];
//        }
//        
//    };
//    [self.HUD hide:YES];
//
//}
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
