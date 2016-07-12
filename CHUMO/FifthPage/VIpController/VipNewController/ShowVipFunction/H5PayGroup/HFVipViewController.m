//
//  HFVipViewController.m
//  StrangerChat
//
//  Created by zxs on 16/1/5.
//  Copyright © 2016年 long. All rights reserved.
//

#import "HFVipViewController.h"
#import "TempHFController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RefreshController.h"
#import "YS_ApplePayVipViewController.h"
#import "MonthlyViewController.h"
@interface HFVipViewController ()<UIWebViewDelegate>
{
    
    NSMutableDictionary *userInforDic;   // 完成
    NSMutableDictionary *systemVip;      // 提取系统Vip信息
    NSString *sex;
    NSString *returnVip;                 // 1 为True  2 为 False
    NSMutableArray *sytemArray;
    NSMutableArray *lastArray;
}
@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic, strong)UIWebView *myWeb;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation HFVipViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title=@"会员中心";
    
    userInforDic = [NSMutableDictionary dictionary];
    systemVip    = [NSMutableDictionary dictionary];
    sytemArray   = [NSMutableArray array];
    lastArray    = [NSMutableArray array];
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 1男2女
        sex = @"2";
    }else {
        sex = @"1";
    }
    self.myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_myWeb] ;
    self.myWeb.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_setupProgressHud];
    });
    [self Userinformation];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}

- (void)leftAction:(UIBarButtonItem *)sender {

    [self.navigationController popToRootViewControllerAnimated:true];

}

#pragma mark ----- 完成
- (void)extractVip { // 提取系统VIP信息  p1 p2 a78--> type分类     a13 code-->编码
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_11_1.service?a78=%@&a13=%@&p1=%@&p2=%@&%@",kServerAddressTest2,sex,@"",p1,p2,appInfo];
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
            NSDictionary *vipdict = infoDic[@"body"];

            for (NSDictionary *keydict in vipdict[@"b140"]) {
                
                
                [sytemArray addObject:keydict];
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
        dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutTempTableView];
        });
        [self addobjvs];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
}
- (void)addobjvs { // 提取用户信息反译给H5

    for (NSDictionary *dic in sytemArray) {
        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
        for (NSString *keys in dic) {
            
            if ([keys isEqualToString:@"b133"]) {
                NSString *strValue = [dic objectForKey:keys];
                NSString *keystr = @"vipCode";
                [dicss setObject:strValue forKey:keystr];
            }
            if ([keys isEqualToString:@"b136"]) {
                NSString *strValue = [dic objectForKey:keys];
                NSString *keystr = @"endTime";
                [dicss setObject:strValue forKey:keystr];
            }
            if ([keys isEqualToString:@"b80"]) {
                NSString *strValue = [dic objectForKey:keys];
                NSString *keystr = @"userId";
                [dicss setObject:strValue forKey:keystr];
            }
            
        }
        [lastArray addObject:dicss];
    }
}

#pragma mark ----- 完成
- (void)Userinformation {  // 用户信息 （完成）

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
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
            NSDictionary *dict2 = infoDic[@"body"];
            for (NSString *key in dict2) {
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    
                    for (NSString *userinfo in Valuedic) {
                        
                        [self addWithKeyStr:userinfo EqualStr:@"b34"  userValuedic:Valuedic contentKey:@"id"];
                        [self addWithKeyStr:userinfo EqualStr:@"b37"  userValuedic:Valuedic contentKey:@"kidney"];
                        [self addWithKeyStr:userinfo EqualStr:@"b88"  userValuedic:Valuedic contentKey:@"weight"];
                        [self addWithKeyStr:userinfo EqualStr:@"b24"  userValuedic:Valuedic contentKey:@"favorite"];
                        [self addWithKeyStr:userinfo EqualStr:@"b39"  userValuedic:Valuedic contentKey:@"liveTogether"];
                        [self addWithKeyStr:userinfo EqualStr:@"b45"  userValuedic:Valuedic contentKey:@"loveType"];
                        [self addWithKeyStr:userinfo EqualStr:@"b47"  userValuedic:Valuedic contentKey:@"marrySex"];
                        [self addWithKeyStr:userinfo EqualStr:@"b46"  userValuedic:Valuedic contentKey:@"marriageStatus"];
                        [self addWithKeyStr:userinfo EqualStr:@"b19"  userValuedic:Valuedic contentKey:@"educationLevel"];
                        [self addWithKeyStr:userinfo EqualStr:@"b9"   userValuedic:Valuedic contentKey:@"city"];
                        [self addWithKeyStr:userinfo EqualStr:@"b67"  userValuedic:Valuedic contentKey:@"province"];
                        [self addWithKeyStr:userinfo EqualStr:@"b1"   userValuedic:Valuedic contentKey:@"age"];
                        [self addWithKeyStr:userinfo EqualStr:@"b69"  userValuedic:Valuedic contentKey:@"sex"];
                        [self addWithKeyStr:userinfo EqualStr:@"b74"  userValuedic:Valuedic contentKey:@"star"];
                        [self addWithKeyStr:userinfo EqualStr:@"b30"  userValuedic:Valuedic contentKey:@"hasChild"];
                        [self addWithKeyStr:userinfo EqualStr:@"b31"  userValuedic:Valuedic contentKey:@"hasLoveOther"];
                        [self addWithKeyStr:userinfo EqualStr:@"b32"  userValuedic:Valuedic contentKey:@"hasRoom"];
                        [self addWithKeyStr:userinfo EqualStr:@"b29"  userValuedic:Valuedic contentKey:@"hasCar"];
                        [self addWithKeyStr:userinfo EqualStr:@"b52"  userValuedic:Valuedic contentKey:@"nickName"];
                        [self addWithKeyStr:userinfo EqualStr:@"b86"  userValuedic:Valuedic contentKey:@"wageMax"];
                        [self addWithKeyStr:userinfo EqualStr:@"b87"  userValuedic:Valuedic contentKey:@"wageMin"];
                        [self addWithKeyStr:userinfo EqualStr:@"b4"   userValuedic:Valuedic contentKey:@"birthday"];
                        [self addWithKeyStr:userinfo EqualStr:@"b80"  userValuedic:Valuedic contentKey:@"userId"];
                        [self addWithKeyStr:userinfo EqualStr:@"b62"  userValuedic:Valuedic contentKey:@"profession"];
                        [self addWithKeyStr:userinfo EqualStr:@"b5"   userValuedic:Valuedic contentKey:@"blood"];
                        [self addWithKeyStr:userinfo EqualStr:@"b17"  userValuedic:Valuedic contentKey:@"describe"];
                        [self addWithKeyStr:userinfo EqualStr:@"b33"  userValuedic:Valuedic contentKey:@"height"];
                        [self addWithKeyStr:userinfo EqualStr:@"b8"   userValuedic:Valuedic contentKey:@"charmPart"];
                        [self addWithKeyStr:userinfo EqualStr:@"b44"  userValuedic:Valuedic contentKey:@"loginTime"];
                        [self addWithKeyStr:userinfo EqualStr:@"b57"  userValuedic:Valuedic contentKey:@"photoUrl"];
                        [self addWithKeyStr:userinfo EqualStr:@"b142" userValuedic:Valuedic contentKey:@"photoStatus"];
                        [self addWithKeyStr:userinfo EqualStr:@"b118" userValuedic:Valuedic contentKey:@"d1Status"];
                        [self addWithKeyStr:userinfo EqualStr:@"b75"  userValuedic:Valuedic contentKey:@"status"];
                        [self addWithKeyStr:userinfo EqualStr:@"b152" userValuedic:Valuedic contentKey:@"systemName"];
                        [self addWithKeyStr:userinfo EqualStr:@"b144" userValuedic:Valuedic contentKey:@"vip"];
                        [self addWithKeyStr:userinfo EqualStr:@"b143" userValuedic:Valuedic contentKey:@"userType"];
                    }
               }
            }
            [self extractVip];
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
}


/**
 *  Description
 *
 *  @param keystr       原来请求的b112里面的key 如b11 b2等
 *  @param equalStr     找到对应的b1 b3 b4等数
 *  @param userValuedic 根据key 取到的value
 *  @param contentKey   需要给h5的key
 */
- (void)addWithKeyStr:(NSString *)keystr EqualStr:(NSString *)equalStr userValuedic:(NSDictionary *)userValuedic contentKey:(NSString *)contentKey{

    if ([keystr isEqualToString:equalStr]) {
        NSString *userinfoValue = [userValuedic objectForKey:keystr];
        NSString *birthday = contentKey;
        [userInforDic setValue:userinfoValue forKey:birthday];
        
    }
}

- (void)layoutTempTableView
{
#pragma mark --- web
    
    
    //@"http://115.236.55.163:9093/lp-h5-msc/p1.html"
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@p1.html",kServerAddressTestH5,nil]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1];
    [self.myWeb loadRequest:request];
    
}
#pragma mark --- web代理
- (void)webViewDidStartLoad:(UIWebView *)webView {

   dispatch_async(dispatch_get_main_queue(), ^{
       __block HFVipViewController *HFVC=self;
       self.jsCondex = [self.myWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
       NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
       NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
       NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
       self.jsCondex[@"getUserInfo"] = ^(){  // 2  完成
           NSString *str = [HFVipViewController dictionaryToJson:userInforDic];
           return str;
       };
       self.jsCondex[@"getUserID"] = ^(){  // 2  完成
           NSString *str = userId;
           return str;
       };
       self.jsCondex[@"getSID"] = ^(){  // 2  完成
           NSString *str = sessionId;
           return str;
       };
       self.jsCondex[@"getUrl"] = ^(){  // 2  完成
           NSString *str = kServerAddressTest2;
           return str;
       };
       
       self.jsCondex[@"getUserVipInfo"] = ^(NSString *orderdata){  // 3 f_115_12_1.service  提取系统VIP信息  需要根据文档转key
           NSString *str = [HFVipViewController addDictionaryToJson:lastArray];
           return str;
           
       };
       self.jsCondex[@"decryptJson"] = ^(NSString *orderdata){
           NSString *jsonStr = [NSGetTools DecryptWith:orderdata];// 解密
           NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
           NSString *str=nil;
           if (infoDic!=nil) {
               str = [HFVipViewController dictionaryToJson:infoDic];
           }
           dispatch_async(dispatch_get_main_queue(), ^{
               [HFVC.HUD hide:YES];
           });
           return str;
           
       };
       
       self.jsCondex[@"openWeb"] = ^(NSString *msg){ // 获取URL重新加载页面 完成
           dispatch_async(dispatch_get_main_queue(), ^{
           TempHFController *temp = [[TempHFController alloc] init];
           temp.urlWeb = msg;
           
           temp.dicts = userInforDic;
           [HFVC.navigationController pushViewController:temp animated:true];
           });
           
           
       };
       //新版支付页面
       self.jsCondex[@"openVipController"] = ^(){
           dispatch_async(dispatch_get_main_queue(), ^{
               YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
               UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
               [HFVC presentViewController:tempnc animated:YES completion:nil];
//               [HFVC.navigationController pushViewController:temp animated:YES];
           });
       };
       self.jsCondex[@"openMailController"] = ^(){
           dispatch_async(dispatch_get_main_queue(), ^{
               MonthlyViewController *moVC=[[MonthlyViewController alloc]init];
               UINavigationController *moenthnc=[[UINavigationController alloc]initWithRootViewController:moVC];
               [HFVC presentViewController:moenthnc animated:YES completion:nil];
//               [HFVC.navigationController pushViewController:moVC animated:YES];
           });
       };
       
   });
    
}

- (void)p_setupProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD = [[MBProgressHUD alloc]initWithView: self.myWeb];
        _HUD.frame = [self.view bounds];
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
        [self.myWeb addSubview:_HUD];
        [_HUD show:YES];
    });
    
}
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if(!policyData && error){
        NSLog(@"Error creating JSON: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
    NSString  *policyStr = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    
    return [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

+ (NSString *)addDictionaryToJson:(NSMutableArray *)dic {
    
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if(!policyData && error){
        NSLog(@"Error creating JSON: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
    NSString  *policyStr = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    
    return [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
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
