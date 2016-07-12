//
//  NoVipController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NoVipController.h"
#import "TouchmeView.h"
#import "TouchModel.h"
#import "RefreshController.h"
#import "YS_ApplePayVipViewController.h"
#import "YS_SelfPayViewController.h"
@interface NoVipController ()
@property (nonatomic,strong)TouchmeView *tv;
@property (nonatomic,strong)NSMutableArray *touchMeArray;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation NoVipController
- (void)loadView {

    self.tv = [[TouchmeView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.tv;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden=NO;
}
// navigation-normal
- (void)viewDidLoad {
    [super viewDidLoad];
    [self n_Request];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonAction)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
    
}
- (void)n_Request {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_105_11_1.service?a78=%@&a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"2",@"20",p1,p2,appInfo];
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
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSArray *touchArray = infoDic[@"body"];
            
            for (NSDictionary *touchDic in touchArray) {
                
                TouchModel *touch = [[TouchModel alloc] init];
                touch.userId    = touchDic[@"b80"];
                touch.photoUrl  = touchDic[@"b57"];  // 头像连接
                touch.nickName  = touchDic[@"b52"];  // 昵称
                touch.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                touch.ageStr    = [NSString stringWithFormat:@"%@",touchDic[@"b1"]];   // 年龄
                [self.touchMeArray addObject:touch];
            }
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [self presentViewController:refre animated:YES completion:nil];
        }
        [self n_layoutView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}
- (void)leftButtonAction {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)n_layoutView {

    [self.tv addWithcupImage:@"chupeng-normal" nameLabel:self.nametitle crown:@"crown-normal" someBoy:@"想知道是谁在悄悄触动你吗?" vip:@"成为会员享受实时触动列表查看功能"];
    [self.tv.vipButton setImage:[UIImage imageNamed:@"button--normal"] forState:(UIControlStateNormal)];
    [self.tv.vipButton addTarget:self action:@selector(vipButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    NSString *day = @"30";
    NSString *num = [NSString stringWithFormat:@"%ld",self.touchMeArray.count];
    self.tv.numLabel.text = [NSString stringWithFormat:@"最近%@天,有%@人来触动过你",day,num];
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.tv.numLabel.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kUIColorFromRGB(0x1b77bb)
     
                          range:NSMakeRange(2, day.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(5+day.length, num.length)];
    self.tv.numLabel.attributedText = AttributedStr;
    
    
}

- (void)vipButtonAction {
//    NSDictionary *attrdict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
//    NSString *attr = [attrdict objectForKey:@"lp_pay_way_type_ios"];
//    if ([attr isEqualToString:@"2,7"]) {
//        
//    }else{
//        HFVipViewController *hf = [[HFVipViewController alloc] init];
//        [self.navigationController pushViewController:hf animated:true];
//    }
//    HFVipViewController *vip = [[HFVipViewController alloc] init];
//    [self.navigationController pushViewController:vip animated:YES];
//    TempHFController *temp = [[TempHFController alloc] init];
//    temp.urlWeb = [NSString stringWithFormat:@"%@p2.html",kServerAddressTestH5,nil];
//     [self.navigationController pushViewController:temp animated:true];
    if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
        YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
//        [self.navigationController pushViewController:temp animated:YES];
    }else{
#pragma mark 企业版
        YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
        
        temp.payMainCode=[goodDict objectForKey:@"b13"];
        temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//        temp.payMainCode=@"1006";
//        temp.payComboType=@"1";//套餐
        temp.navigationItem.title=@"开通VIP会员";
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
//        [self.navigationController pushViewController:temp animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 实时检测网络
-(void)havingNetworking:(NSNotification *)isNetWorking{
    NSString *sender = isNetWorking.object;
    self.isnetWroking=[sender boolValue];
    
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
