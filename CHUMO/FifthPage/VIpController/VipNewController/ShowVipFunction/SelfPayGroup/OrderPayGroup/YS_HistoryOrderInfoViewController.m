//
//  YS_HistoryOrderInfoViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_HistoryOrderInfoViewController.h"
#import "DHAlertView.h"
#import "JYPayWorking.h"
#import "YS_OrderPayingView.h"

@interface YS_HistoryOrderInfoViewController ()<DHAlertViewDelegate,JYPayWorkingDelegate,YS_OrderPayingViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSString *codePrefix;
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,strong)YS_OrderPayingView *orderView;
@end

@implementation YS_HistoryOrderInfoViewController

-(void)loadView{
    self.orderView=[YS_OrderPayingView orderOverInfoWithFrame:[[UIScreen mainScreen] bounds] AndInfoModel:self.model];
    self.orderView.delegate=self;
    self.view=self.orderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"订单详情";

    [Mynotification addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark 支付代理
-(void)noticeInvalid{
    [self alertViewOfTitle:@"提示" msg:@"该订单已经无效!"];
}
-(void)noticeToPay{
   
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    NSInteger payType =  [self.model.b130 integerValue];
    NSString *prefix= [NSString stringWithFormat:@"%@",self.model.b131];
    payRequsestFlag payflag=(payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
    if ((payflag & payType)) {
        if (payType ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
            [self alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
        }
        NSString *strs=[[NSString stringWithFormat:@"%@",prefix] substringWithRange:NSMakeRange(0, 4)];
        [self setValue:strs forKey:@"codePrefix"];
        [self payAgainAction:payType GoodId:prefix];
    }
}

//订单支付
- (void) payAgainAction:(NSInteger)payRequsestFlag GoodId:(NSString *)GoodId {
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)payRequsestFlag];
    [self.payWorking PaydataRuquesByGoodId:GoodId payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:GoodId forKey:@"dh_goodId"];
            [wxpayDic setObject:payNum forKey:@"dh_payType"];
            if (payRequsestFlag==payRequsestFlagZFB) {
                [MobClick event:@"zfbPay"]; // 支付宝统计事件
                [self.payWorking sendZFBPay_demo:wxpayDic];
            }else if (payRequsestFlag==payRequsestFlagWX) {
                [MobClick event:@"wxPay"]; // 微信统计事件
                [self.payWorking sendPay_demo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagZF){
                [MobClick event:@"alPay"]; // 现在-支付宝统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagNG){
                [MobClick event:@"ngPay"]; // 内购统计事件
                [self.payWorking getProductInfo:GoodId info:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagYL){
                [MobClick event:@"ylPay"]; // 现在-银联统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBZF){
                [MobClick event:@"HFBalPay"]; // 汇付宝-支付宝统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBYL){
                [MobClick event:@"HFBylPay"]; // 汇付宝-银联统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBWX){
                [MobClick event:@"HFBwxPay"]; // 汇付宝-微信统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }
        }
    }];
}
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//通知
- (void)payAction:(NSNotification *)sender {
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    
    if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
        // 长度为11位，第二位不为0，为已经绑定手机
        NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
        if ([userName length] == 11 && [secNumber integerValue] != 0) {
            [self alertViewOfTitle:@"温馨提示" msg:@"支付成功"];
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
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"extractVipWhenPay" object:nil];
        [self payAction:nil];
    }else{
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
        if ([_codePrefix isEqualToString: [NSString stringWithFormat:@"%@",[goodDict objectForKey:@"b13"]]]) {//写信
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(6)];
        }else{//VIP
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(5)];
        }
        [self alertViewOfTitle:@"提示" msg:msg];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
