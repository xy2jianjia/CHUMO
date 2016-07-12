//
//  WXPayController.h
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSignURL       @"http://posp.ipaynow.cn/ZyPluginPaymentTest_PAY/api/pay2.php"

@interface WXPayController : UITableViewController{
    NSMutableData* mData;
}
@property (nonatomic,strong)NSString *string;
@property (nonatomic,assign)NSInteger indxint;
@property (nonatomic,strong)NSDictionary *payDic;
@property (nonatomic,assign)BOOL payContinue;//yes:继续支付 no:重新支付
@end
