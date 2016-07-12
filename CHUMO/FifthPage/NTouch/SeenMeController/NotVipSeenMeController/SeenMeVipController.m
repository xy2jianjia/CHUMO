//
//  SeenMeVipController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SeenMeVipController.h"
#import "SeenVipView.h"
#import "DHSeenModel.h"
#import "RefreshController.h"
#import "YS_ApplePayVipViewController.h"
#import "YS_VipCenterViewController.h"

@interface SeenMeVipController ()
@property (nonatomic,strong)SeenVipView *tv;
@property (nonatomic,strong)NSMutableArray *seenMeArray;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation SeenMeVipController
- (void)loadView {
    
    self.tv = [[SeenVipView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.tv;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonAction)];
    [self n_Request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
- (void)leftButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---- request
- (void)n_Request {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_109_10_1.service?a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1",p1,p2,appInfo];
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
        for (NSString *keys in infoDic) {
            NSLog(@"错误信息----->:%@ 错误条件----->:%@",keys,[infoDic objectForKey:keys]);
        }
        NSNumber *codeNum = infoDic[@"code"];
        NSLog(@"%@",infoDic);
        if ([codeNum intValue] == 200) {
            
            NSArray *touchArray = infoDic[@"body"];
            
            for (NSDictionary *touchDic in touchArray) {
                
                DHSeenModel *seen = [[DHSeenModel alloc] init];
                seen.userId    = touchDic[@"b80"];  // ID传值用
                seen.photoUrl  = touchDic[@"b57"];  // 头像连接
                seen.nickName  = touchDic[@"b52"];  // 昵称
                seen.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                [self.seenMeArray addObject:seen];
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
- (void)n_layoutView {
    
    [self.tv addWithcupImage:@"kanguowo-normal" nameLabel:self.nametitle crown:@"crown-normal" someBoy:@"想知道是谁在偷偷看过你吗?" vip:@"成为会员享受实时访客列表查看功能"];
//    [self.tv.vipButton setImage:[UIImage imageNamed:@"button--normal"] forState:(UIControlStateNormal)];
    [self.tv.vipButton setTitle:@"成为会员" forState:(UIControlStateNormal)];
    [self.tv.vipButton addTarget:self action:@selector(vipButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
#pragma mark --- 改变字体颜色
    NSString *day = @"30";
    NSString *num = [NSString stringWithFormat:@"%ld",self.seenMeArray.count];
    self.tv.numLabel.text = [NSString stringWithFormat:@"最近%@天,有%@人来看过你",day,num];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.tv.numLabel.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kUIColorFromRGB(0x1b77bb)
     
                          range:NSMakeRange(2, day.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(5+day.length, num.length)];
    self.tv.numLabel.attributedText = AttributedStr;
    
    
}
#pragma mark --- 成为会员
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
//    [self.navigationController pushViewController:temp animated:true];
    if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
        YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
//        [self.navigationController pushViewController:temp animated:YES];
    }else{
#pragma mark 企业版
        YS_VipCenterViewController *vip = [[YS_VipCenterViewController alloc] init];
        vip.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vip animated:YES];
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
