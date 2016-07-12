//
//  WXPayController.m
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WXPayController.h"
#import "WXcell.h"
#import "WXPayCell.h"
#import "WXSubmitTableViewCell.h"

//APP端签名相关头文件
#import "payRequsestHandler.h"
//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>
#import "WXApiObject.h"
#import "WXApi.h"
//现在支付
//#import "IpaynowPluginApi.h"
//#import "IPNPreSignMessageUtil.h"
#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import <StoreKit/StoreKit.h>
#import "DHAlertView.h"

#import "JYPayWorking.h"
//#define AppleIdPayProductId @"com.imchumo.social"
@interface WXPayController ()<UIAlertViewDelegate,DHAlertViewDelegate,JYPayWorkingDelegate> {
    
    NSIndexPath *payindexPath;
//    NSDictionary *wxpayDic; // 微信支付
    enum WXScene _scene;
    NSInteger payInteger;  // 记录当前支付模式
    
    NSString *_presignStr;
    NSString *_orderNo;
    NSMutableArray *_payServiceArray;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)JYPayWorking *payWorking;
@end

@implementation WXPayController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Mynotification addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
//    wxpayDic = @{}.mutableCopy;
    self.dataArray = @[].mutableCopy;
    _payServiceArray = @[].mutableCopy;
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    //选中支付宝支付
    payindexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    
    
    [self ergodic]; // 把需要的数据分解出来 获取需要的东西
    
    [self getPayMethod];
    
    
    
}
//请求支付方式,根据支付方式生成cell
- (void)getPayMethod{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_125_12_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSString *codeNum = infoDic[@"body"];
        _payServiceArray = [codeNum componentsSeparatedByString:@","].mutableCopy;
        if ([_payServiceArray containsObject:@"3"]) {
            [_payServiceArray removeObject:@"3"];
        }
//        [_payServiceArray removeAllObjects];
//        [_payServiceArray addObject:@"2"];
        dispatch_async(dispatch_get_main_queue(), ^{
            payInteger=[_payServiceArray[0] integerValue];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:payInteger forKey:@"payInteger"];
            [userDefaults synchronize];
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
//通知
- (void)payAction:(NSNotification *)sender {
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    
    if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
        // 长度为11位，第二位不为0，为已经绑定手机
        NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
        if ([userName length] == 11 && [secNumber integerValue] != 0) {
            
        }else{
            
            DHAlertView *alert1 = [[DHAlertView alloc]init];
            [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"支付成功,为了避免您忘记自己的账号密码,请绑定手机号~"];
            [alert1.sureBtn setTitle:@"去绑定" forState:(UIControlStateNormal)];
            alert1.delegate = self;
            [self.view addSubview:alert1];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSGetTools showAlert:@"用户信息过期，请重新登录"];
        });
    }
}
-(void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger)index{
    if (index == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        NResetController *reset = [[NResetController alloc] init];
        reset.title = @"绑定手机号";
        reset.msgType = @"3";
        [self.navigationController pushViewController:reset animated:true];
    }
}
- (void)dealloc {
    [Mynotification removeObserver:self];
}
#pragma mark ====== alertView代理 ======
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            NSLog(@"不做操作");
        }else if (buttonIndex == 1) {
            NResetController *reset = [[NResetController alloc] init];
            reset.title = @"绑定手机号";
            reset.msgType = @"3";
            [self.navigationController pushViewController:reset animated:true];
        }
    }else {
        if (buttonIndex == 0) {
            NSLog(@"不做操作");
        }else if (buttonIndex == 1) {
            NResetController *reset = [[NResetController alloc] init];
            reset.title = @"绑定手机号";
            reset.msgType = @"3";
            [self.navigationController pushViewController:reset animated:true];
        }
    }
    
}
#pragma mark --- 下单

- (void)wxPaydataRuques { // 下单
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)payInteger];
    [self.payWorking PaydataRuquesByGoodId:self.payDic[@"b13"] payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
//            wxpayDic = dic[@"body"];
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:self.payDic[@"b13"]  forKey:@"dh_goodId"];
            [wxpayDic setObject:payNum forKey:@"dh_payType"];
            if (payInteger==payRequsestFlagZFB) {
                [MobClick event:@"zfbPay"]; // 支付宝统计事件
                [self.payWorking sendZFBPay_demo:wxpayDic];
            }else if (payInteger==payRequsestFlagWX) {
                [MobClick event:@"wxPay"]; // 微信统计事件
                [self.payWorking sendPay_demo:wxpayDic];
            }else if(payInteger==payRequsestFlagZF){
                [MobClick event:@"alPay"]; // 现在-支付宝统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payInteger==payRequsestFlagNG){
                [MobClick event:@"ngPay"]; // 内购统计事件
                [self.payWorking getProductInfo:self.payDic[@"b13"] info:wxpayDic];
            }else if(payInteger==payRequsestFlagYL){
                [MobClick event:@"ylPay"]; // 现在-银联统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payInteger==payRequsestFlagHFBZF){
                [MobClick event:@"HFBalPay"]; // 汇付宝-支付宝统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payInteger==payRequsestFlagHFBYL){
                [MobClick event:@"HFBylPay"]; // 汇付宝-银联统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payInteger==payRequsestFlagHFBWX){
                [MobClick event:@"HFBwxPay"]; // 汇付宝-微信统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }
        }
        
    }];
    
    
}
- (void)ergodic {  // 把需要的数据分解出来
    
    NSString *name     = self.payDic[@"b51"];   // 明细名称
    NSString *month    = self.payDic[@"b137"];  // 时长
    NSString *price    = self.payDic[@"b126"];  // 价格
    NSString *advance  = self.payDic[@"b138"];  // 送几个月
    NSString *discount = self.payDic[@"b128"];  // 折扣
    NSLog(@"%@---%@---%@---%@----%@",name,month,price,advance,discount);
    [self.dataArray insertObject:name atIndex:0];
    [self.dataArray insertObject:[NSString stringWithFormat:@"%@个月",month] atIndex:1];
    [self.dataArray insertObject:[NSString stringWithFormat:@"%@ 元",price] atIndex:2];
    if (advance) {
        [self.dataArray insertObject:[NSString stringWithFormat:@"送%@个月",advance] atIndex:3];
    }
}

- (void)leftAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  //b138作为判断条件来判断是否有优惠
    
    if (self.payDic[@"b138"] == nil) { // 无优惠的
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }else if (section == 3){
            return 1;
        }else{
            return _payServiceArray.count;
        }
    }else {  // 有优惠的
        if (section == 0) {
            return 3;
        }else if (section == 1){
            return 2;
        }else if (section == 3){
            return 1;
        }else{
            return _payServiceArray.count;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    payindexPath = indexPath;
    if (indexPath.section == 0) {
        WXcell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
        if (!cell) {
            cell = [[WXcell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"YY"];
        }
        if (indexPath.row == 0) {
            cell.order.text = @"订单名称";
            cell.contents.text = [NSString stringWithFormat:@"%@",self.payDic[@"b51"]];
            
        }else if (indexPath.row == 1) {
            cell.order.text = @"优惠";
            cell.contents.text = [NSString stringWithFormat:@"送%@月",self.payDic[@"b138"]];
            cell.order.textColor = [UIColor redColor];
            cell.contents.textColor = [UIColor redColor];
        }else {
            UILabel *discount = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-80-40,0, 80, 35)];
            discount.text = [NSString stringWithFormat:@"%@折",self.payDic[@"b128"]];
            discount.textColor = [UIColor redColor];
            discount.textAlignment = NSTextAlignmentRight;
            [cell addSubview:discount];
        }
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }else if (indexPath.section == 1) {
        WXcell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
        if (!cell) {
            cell = [[WXcell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"YY"];
        }
        if (indexPath.row == 0) {
            cell.order.text = @"原价";
            cell.contents.text = [NSString stringWithFormat:@"%.ld元",[self.payDic[@"b126"] integerValue]];
        }else if (indexPath.row == 1) {
            cell.order.text = @"优惠";
            cell.contents.text = [NSString stringWithFormat:@"-%.f元",[self.payDic[@"b126"] integerValue]-[self.payDic[@"b126"] integerValue]*[self.payDic[@"b128"] integerValue]*0.1];
            cell.order.textColor = [UIColor redColor];
            cell.contents.textColor = [UIColor redColor];
        }
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }else if (indexPath.section == 3){
        WXSubmitTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SubmitCell"];
        
        if (!cell) {
            cell = [[WXSubmitTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SubmitCell"];
        }
        [cell.details setTitle:[NSString stringWithFormat:@"确认支付%.1f元",[self.payDic[@"b126"] integerValue]*[self.payDic[@"b128"] integerValue]*0.1] forState:(UIControlStateNormal)];
        [cell.details addTarget:self action:@selector(detailsAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }else{
        WXPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYPAY"];
        if (!cell) {
            cell = [[WXPayCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"YYPAY"];
        }
        
        switch ([_payServiceArray[indexPath.row] integerValue]) {
            case payRequsestFlagNG:
            {
                [cell setPayImage:@"icon-applePay" payLabel:@"Apple账号支付" payFlag:(payRequsestFlagNG)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
            case payRequsestFlagZF:
            {
                [cell setPayImage:@"icon-zhifubao" payLabel:@"支付宝支付" payFlag:(payRequsestFlagZF)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
                
            case payRequsestFlagWX:
            {
                [cell setPayImage:@"wxImage" payLabel:@"微信支付" payFlag:(payRequsestFlagWX)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
                
            case payRequsestFlagYL:
            {
                [cell setPayImage:@"icon-yinlian" payLabel:@"银联" payFlag:(payRequsestFlagYL)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
            case payRequsestFlagHFBYL:
            {
                [cell setPayImage:@"icon-yinlian" payLabel:@"汇付宝银联" payFlag:(payRequsestFlagHFBYL)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
            case payRequsestFlagHFBWX:
            {
                [cell setPayImage:@"wxImage" payLabel:@"汇付宝微信支付" payFlag:(payRequsestFlagHFBWX)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
            case payRequsestFlagHFBZF:
            {
                [cell setPayImage:@"icon-zhifubao" payLabel:@"汇付宝支付宝支付" payFlag:(payRequsestFlagHFBZF)];
                [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
                break;
            }
            default:
                break;
        }
        if (cell.payFlag==payInteger) {
            [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
        }
        
        return cell;
    }
}

#pragma mark -- 选中支付圆点
- (void)payDotAction:(UIButton *)sender {
    WXPayCell *cell = (WXPayCell *)[self.tableView cellForRowAtIndexPath:payindexPath];
    [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
    
}
- (void)changeDotActonAndIndexPath:(NSIndexPath *)indexPath{
    //移除之前cell的选中状态
    if (indexPath.row!=payindexPath.row) {
        WXPayCell *cell = (WXPayCell *)[self.tableView cellForRowAtIndexPath:payindexPath];
        [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
        //记录选中cell
        payindexPath=indexPath;
    }
    
}
#pragma mark -- cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 2) {
        WXPayCell *cell = (WXPayCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
        [self changeDotActonAndIndexPath:indexPath];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        payInteger=cell.payFlag;
        [userDefaults setInteger:payInteger forKey:@"payInteger"];
        [userDefaults synchronize];
        
        
    }
    
    
}


#pragma mark -- 支付方式和资费详情Image
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *views = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImageView *details = [[UIImageView alloc] initWithFrame:CGRectMake(40, 15, [[UIScreen mainScreen] bounds].size.width-40-40, 15)];
    if (section == 2) {
        details.image = [UIImage imageNamed:@"zhifu"];
    }else {
        details.image = [UIImage imageNamed:@"zifei"];
    }
    
    [views addSubview:details];
    return views;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }else if(section == 3){
        return 0;
    }else{
        return 30;
    }
}
#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return [WXPayCell wxPayCellHeight];
    }else if(indexPath.section == 3){
        return 60;
    }else{
        return [WXcell wxCellHeight];
    }
}

#pragma mark -- 支付按钮
- (void)detailsAction:(UIButton *)sender { // 点击支付
    dispatch_async(dispatch_get_main_queue(), ^{
    if (payInteger==payRequsestFlagWX) {
        
        if ([WXApi isWXAppInstalled]) {
            [MobClick event:@"wxPay"]; // 微信统计事件
            [self wxPaydataRuques];  // 签名数据
            
        }else{
            [self alert:@"未检测到微信客户端" msg:@"请安装微信"];
        }
        
    }else if(payInteger==payRequsestFlagZF||payInteger==payRequsestFlagYL){
        [MobClick event:@"ylPay"]; // 银联统计事件
        [self wxPaydataRuques];  // 签名数据
        
    }else if(payInteger==payRequsestFlagNG){
        if ([SKPaymentQueue canMakePayments]) {
            
            [MobClick event:@"ngPay"]; // 内购统计事件
            [self wxPaydataRuques];
            
        } else {
            [self alert:@"失败" msg:@"用户禁止应用内付费购买."];
        }
        
    }else if(payInteger==payRequsestFlagHFBYL||payInteger==payRequsestFlagHFBWX||payInteger==payRequsestFlagHFBZF){
        [self wxPaydataRuques];
    }
    });
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [self payAction:nil];
    }else{
        [self alert:@"提示" msg:msg];
    }
}
@end
