//
//  MonthlyViewController.m
//  Monthly
//
//  Created by zxs on 16/4/19.
//  Copyright © 2016年 YSKS.cn. All rights reserved.
//  

#import "MonthlyViewController.h"
#import "MonthlyView.h"
#import "YS_PayInfoModel.h"
#import "JYPayWorking.h"
#import "DHAlertView.h"
#import "NPServiceViewController.h"
@interface MonthlyViewController () <MonthlyViewDelegate,JYPayWorkingDelegate,DHAlertViewDelegate>
@property (nonatomic,strong) UIScrollView *mainView;
@property (nonatomic, strong) MonthlyView *monthly;
@property (nonatomic, strong) NSMutableArray *mouthArray;
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSMutableArray *buyArray;//购买编号
@property (nonatomic, strong) NSMutableArray *giftArray;
@property (nonatomic,strong)JYPayWorking *payWorking;
@end

@implementation MonthlyViewController

- (void)loadView {
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.mainView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.monthly = [[MonthlyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+50)];
    self.monthly.monthlydelegate = self;
    self.monthly.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    self.mainView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight+50);
    self.mainView.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    [self.mainView addSubview:self.monthly];
    self.view = self.mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = MainBarBackGroundColor;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.title=@"写信包月";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    self.mouthArray=[NSMutableArray new];
    self.priceArray=[NSMutableArray new];
    self.buyArray=[NSMutableArray new];
    self.giftArray=[NSMutableArray new];
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"加载中...."];
    });
    [self getDataArr];

}
- (void)backAction{
    [Mynotification postNotificationName:@"getUserInfosWhenUpdate" object:nil];
    [Mynotification postNotificationName:@"extractVipWhenPay" object:nil];
    
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)p_setupProgressHud
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.HUD = [[MBProgressHUD alloc]initWithView: self.view];
//        _HUD.frame = [self.view bounds];
//        _HUD.minSize = CGSizeMake(100, 100);
//        _HUD.mode = MBProgressHUDModeIndeterminate;
//        _HUD.color=[UIColor colorWithWhite:0.000 alpha:0.400];
//        [self.view addSubview:_HUD];
//        [_HUD show:YES];
//    });
//    
//}
- (void)getDataArr{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
    
    NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service?p1=%@&p2=%@&a78=%@&a13=%@&%@",kServerAddressTest2,p1,p2,[goodDict objectForKey:@"b78"],[goodDict objectForKey:@"b13"],appInfo];//[goodDict objectForKey:@"b13"]写信编号
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block MonthlyViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            
            if ([(NSArray *)infoDic[@"body"] count]>0) {
                NSArray *vipArr = [infoDic[@"body"][0] objectForKey:@"b111"];//VIP信息
                NSMutableArray *allGoods=[NSMutableArray array];
                for (NSDictionary *oneDict in vipArr) {
                    if (MyJudgeNull([oneDict objectForKey:@"b193"])) {
                        [allGoods addObject:oneDict];
                    }
                    
                }
                
                for (NSDictionary *dict in allGoods) {
                    [payVC.priceArray addObject:dict[@"b126"]];//价格
                    [payVC.mouthArray addObject:dict[@"b137"]];//时长
                    [payVC.buyArray addObject:dict[@"b13"]];//编码
                    if (dict[@"b138"]!=nil) {
                        [payVC.giftArray addObject:dict[@"b138"]];//赠送
                    }else{
                        [payVC.giftArray addObject:@""];//赠送
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                });
                [payVC performSelectorOnMainThread:@selector(setDisplay) withObject:nil waitUntilDone:YES];
                
            }
            
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)setDisplay{
    
    [self.monthly setmonthlyArray:self.mouthArray priceArray:self.priceArray buyArray:self.buyArray giftArray:self.giftArray];
}
- (void)clickMonthlyButton:(MonthlyView *)monthly indexTag:(NSInteger)indextag {
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)8];//内购
    NSString *GoodId = [NSString stringWithFormat:@"%ld",indextag];//购买项目编号
    [self.payWorking PaydataRuquesByGoodId:GoodId payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:GoodId  forKey:@"dh_goodId"];
            [wxpayDic setObject:payNum forKey:@"dh_payType"];
            [MobClick event:@"ngPay"]; // 内购统计事件
            [self.payWorking getProductInfo:GoodId info:wxpayDic];
        }
        
    }];
    
}
- (void)gotoServiceAction{
    NPServiceViewController *temp = [[NPServiceViewController alloc] init];
    temp.urlWeb = [NSString stringWithFormat:@"%@p0.html",kServerAddressTestH5,nil]; ;
    [self.navigationController pushViewController:temp animated:true];
}
#pragma mark 弹框
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
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
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
        [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(6)];
        [self alert:@"提示" msg:msg];
        
    }
}
@end
