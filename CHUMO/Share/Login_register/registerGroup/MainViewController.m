//
//  MainViewController.m
//  StrangerChat
//
//  Created by long on 15/10/16.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MainViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "CXAlertView.h"
#import "DHLoginViewController.h"
#import "WXApi.h"
#import "DHAlertView.h"
#import "JYRegisterView.h"
#import "SexSelectViewController.h"
#import "DHGroupButtonsView.h"
#define WQWidth 60
#define FWQWidth 35
@interface MainViewController ()<TencentSessionDelegate,DHAlertViewDelegate,JYRegisterViewDelegate,DHGroupButtonsViewDelegate>

@property (nonatomic,strong) UIButton *boyButton;// 注册按钮
@property (nonatomic,strong) UIButton *girlButton;// 找回密码按钮
@property (nonatomic,strong) UIButton *loginButton;// 登陆
@property (nonatomic,strong) UIPickerView *pickerView;// 登陆

@property (nonatomic,assign) NSInteger selectAge;
@property (strong,nonatomic)NSArray *permissions;
@property (strong,nonatomic)TencentOAuth *tencentOAuth;
@property (nonatomic,strong)NSMutableDictionary *userInfoDict;

@property (nonatomic,assign)BOOL isgender;
@property (nonatomic,assign)NSInteger gender;
@property (nonatomic,assign)BOOL isThird;
@property (nonatomic,assign)BOOL isThirdTool;//yes :QQ  no:微信
@property (nonatomic,assign)BOOL isNewUser;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.userInfoDict=[NSMutableDictionary dictionary];
    self.isThirdTool=YES;
    self.isNewUser=YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self setBackGroundView];
    [self setBackGroundViewV1];
    [Mynotification addObserver:self selector:@selector(dismissVC) name:@"dismissVC" object:nil];
    [Mynotification addObserver:self selector:@selector(WXBoundAction:) name:@"WXBoundAction" object:nil];
    [Mynotification addObserver:self selector:@selector(WXLoginAction:) name:@"WXLoginAction" object:nil];
    [Mynotification addObserver:self selector:@selector(WXBoundCancleAction:) name:@"WXBoundCancleAction" object:nil];
    
}
- (void)setBackGroundViewV1{
    [DHGroupButtonsView configActivityAlertViewInView:self.view delegate:self];
}
-(void)onClickedButtonWithButton:(UIButton *)button tag:(NSInteger)tag{
    switch (tag) {
            // qq
        case 1000:
            [self QQButtonAction:button];
            break;
            // 微信
        case 1001:
            [self WXButtonAction:button];
            break;
            // 注册
        case 1002:
            [self nextButtonAction:button];
            break;
            // 登录
        case 1003:
            [self nextThirdButtonAction:button];
            break;
        default:
            break;
    }
}
#pragma mark 设置背景图片
- (void)setBackGroundView{
    //图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(iPhone5){
        imageView.image=[UIImage imageNamed:@"w_denglu_bg5"];
    }else if(iPhone4){
        imageView.image=[UIImage imageNamed:@"w_denglu_bg4"];
    }else {
        imageView.image=[UIImage imageNamed:@"w_denglu_bg"];
    }
    
    [self.view addSubview:imageView];
    
//    UITapGestureRecognizer *imageGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerButtonAction)];
//    imageView.userInteractionEnabled=YES;
//    [imageView addGestureRecognizer:imageGesture];
    
    //按钮
    UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)-60, ScreenWidth, 44)];
    buttonView.backgroundColor=[UIColor clearColor];
    
//    CGFloat thirdLift=0;
//    NSInteger thirdNum=2;
    //QQ按钮
    UIButton *loginBut=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    loginBut.frame=CGRectMake(CGRectGetMidX(self.view.frame)-100,  gotHeightiphon6(200), 200, 40);
    [loginBut addTarget:self action:@selector(QQButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [loginBut setImage:[UIImage imageNamed:@"w_denglu_qq"] forState:(UIControlStateNormal)];
    [loginBut setTitle:@"   QQ" forState:(UIControlStateNormal)];
    [loginBut setBackgroundColor:kUIColorFromRGB(0x448fd0)];
    [loginBut setTintColor:kUIColorFromRGB(0xffffff)];
    loginBut.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    loginBut.layer.cornerRadius=5;
    loginBut.layer.masksToBounds=YES;
    [self.view addSubview:loginBut];
    //微信
    if ([WXApi isWXAppInstalled]) {
        //微信按钮
        UIButton *loginwxBut=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        loginwxBut.frame=CGRectMake(CGRectGetMidX(self.view.frame)-100, gotHeightiphon6(230)+40, 200, 40);
        [loginwxBut addTarget:self action:@selector(WXButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [loginwxBut setImage:[UIImage imageNamed:@"w_denglu_weixin"] forState:(UIControlStateNormal)];
        [loginwxBut setTitle:@"   微信" forState:(UIControlStateNormal)];
        loginwxBut.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [loginwxBut setBackgroundColor:kUIColorFromRGB(0x66ab14)];
        [loginwxBut setTintColor:kUIColorFromRGB(0xffffff)];
        loginwxBut.layer.cornerRadius=5;
        loginwxBut.layer.masksToBounds=YES;
        [self.view addSubview:loginwxBut];
        
//        CALayer *wxicon=[[CALayer alloc]init];
//        wxicon.frame=CGRectMake(CGRectGetMidX(loginwxBut.frame)-40, 10, 24, 24);
//        wxicon.contents=(id)[UIImage imageNamed:@"w_login_icon_weixin"].CGImage;
//        [loginwxBut.layer addSublayer:wxicon];
//        
//        CATextLayer *wxtext=[[CATextLayer alloc]init];
//        wxtext.frame=CGRectMake(CGRectGetMaxX(wxicon.frame)+5, 12, 50, 20);
//        wxtext.string=@"微信登录";
//        wxtext.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
//        wxtext.fontSize=13;
//        wxtext.contentsScale = [UIScreen mainScreen].scale;
//        wxtext.alignmentMode = kCAAlignmentCenter;
//        wxtext.foregroundColor=[UIColor whiteColor].CGColor;
//        [loginwxBut.layer addSublayer:wxtext];
//        
//        
//        thirdLift=(ScreenWidth-2)/3;
//        thirdNum=3;
        
//        //分割线
//        UIView *linefirstView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginwxBut.frame), 8, 1, 25)];
//        linefirstView.backgroundColor=kUIColorFromRGB(0xffffff);
//        [buttonView addSubview:linefirstView];
    }
    
    

//    CALayer *qqicon=[[CALayer alloc]init];
//    qqicon.frame=CGRectMake(CGRectGetMidX(loginBut.bounds)-40, 10, 24, 24);
//    qqicon.contents=(id)[UIImage imageNamed:@"w_login_icon_qq"].CGImage;
//    [loginBut.layer addSublayer:qqicon];
//    
//    CATextLayer *qqtext=[[CATextLayer alloc]init];
//    qqtext.frame=CGRectMake(CGRectGetMaxX(qqicon.frame)+5, 12, 50, 20);
//    qqtext.string=@"QQ登录";
//    qqtext.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
//    qqtext.fontSize=13;
//    qqtext.contentsScale = [UIScreen mainScreen].scale;
//    qqtext.alignmentMode = kCAAlignmentCenter;
//    qqtext.foregroundColor=[UIColor whiteColor].CGColor;
//    [loginBut.layer addSublayer:qqtext];
    
    
    
    
    //一键注册按钮
    UIButton *registerBut=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    registerBut.frame=CGRectMake(CGRectGetMidX(self.view.frame)-90-10, 0, 90, 44);
    [registerBut addTarget:self action:@selector(nextButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [registerBut setImage:[UIImage imageNamed:@"w_denglu_yjzc"] forState:(UIControlStateNormal)];
    [registerBut setTitle:@" 一键注册 " forState:(UIControlStateNormal)];
    [registerBut setTintColor:kUIColorFromRGB(0xffffff)];
    [buttonView addSubview:registerBut];
    
    //分割线
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(registerBut.frame)+10, CGRectGetMinY(registerBut.frame)+5, 1, 15)];
    lineView.centerY=registerBut.centerY;
    lineView.backgroundColor=kUIColorFromRGB(0xffffff);
    [buttonView addSubview:lineView];
    
    //登陆按钮
    UIButton *cmloginBut=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    cmloginBut.frame=CGRectMake(CGRectGetMidX(self.view.frame)+10, 0, 90, 44);
    [cmloginBut addTarget:self action:@selector(nextThirdButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cmloginBut setImage:[UIImage imageNamed:@"w_denglu_zh"] forState:(UIControlStateNormal)];
    [cmloginBut setTitle:@" 账号登录 " forState:(UIControlStateNormal)];
    [cmloginBut setTintColor:kUIColorFromRGB(0xffffff)];
    [buttonView addSubview:cmloginBut];
    
//    CALayer *cmicon=[[CALayer alloc]init];
//    cmicon.frame=CGRectMake(CGRectGetMidX(registerBut.bounds)-40, 10, 24, 24);
//    cmicon.contents=(id)[UIImage imageNamed:@"w_login_icon_chumo"].CGImage;
//    [registerBut.layer addSublayer:cmicon];
//    
//    CATextLayer *cmtext=[[CATextLayer alloc]init];
//    cmtext.frame=CGRectMake(CGRectGetMaxX(cmicon.frame)+5, 12, 50, 20);
//    cmtext.string=@"触陌登录";
//    cmtext.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
//    cmtext.fontSize=13;
//    cmtext.contentsScale = [UIScreen mainScreen].scale;
//    cmtext.alignmentMode = kCAAlignmentCenter;
//    cmtext.foregroundColor=[UIColor whiteColor].CGColor;
//    [registerBut.layer addSublayer:cmtext];
    
    
    [self.view addSubview:buttonView];
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

// 登陆
- (void)nextButtonAction:(UIButton *)sender{
    
    //触陌
    //当前页面
    SexSelectViewController *sexVC=[[SexSelectViewController alloc]init];
    UINavigationController *sexNav=[[UINavigationController alloc]initWithRootViewController:sexVC];
    sexVC.isNotThird=YES;
    [self presentViewController:sexNav animated:YES completion:nil];

}
- (void)nextThirdButtonAction:(UIButton *)sender{
    [MobClick event:@"useringCMLogin"]; // 触陌登陆按钮统计事件
    DHLoginViewController *loginVC = [DHLoginViewController new];
    loginVC.whoVC = @"login";
    loginVC.isthird=NO;
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginVC];
}
//注册
- (void)registerButtonAction{
    JYRegisterView *registerV=[[JYRegisterView alloc]init];
    registerV.delegate=self;
    [self.view addSubview:registerV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 第三方登陆
- (void)WXButtonAction:(id)sender{
    //微信
    [self showHudInView:self.view hint:@"请稍等.."];
    [MobClick event:@"WXRegister"]; // QQ统计事件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:LoginMethodsWX forKey:@"LoginMethodsInteger"];
    [userDefaults synchronize];
    SendAuthReq *req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo"; // 此处不能随意改
    req.state = @"123"; // 这个貌似没影响
    [WXApi sendReq:req];
    [self hideHud];
}
- (void)QQButtonAction:(id)sender{
    //QQ
    [self showHudInView:self.view hint:@"请稍等.."];
    [MobClick event:@"QQRegister"]; // QQ统计事件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:LoginMethodsQQ forKey:@"LoginMethodsInteger"];
    [userDefaults synchronize];
    self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1104937933"andDelegate:self];
    _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
    [self.tencentOAuth authorize:_permissions inSafari:NO];
    [self hideHud];
}
#pragma  mark 登录
//登陆
- (void)loginWithUserId:(NSString *)userId sessionId:(NSString *)sessionId username:(NSString *)username password :(NSString *)password{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&%@",kServerAddressTest,username,password,appinfoStr];
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            [NSGetTools updateUserSexInfoWithB69:[NSNumber numberWithInteger:[dict2[@"b69"] integerValue]]];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
            
            
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"SaveregUserAction"];
            
            NSLog(@"登陆成功");
            DHLoginUserForListModel *item = [[DHLoginUserForListModel alloc]init];
            item.userId = dict2[@"b80"];
            item.userName = username;
            item.passWord = password;
            item.sessionId = dict2[@"b101"];
            if (![DHLoginUserDao checkLoginUserWithUsertId:dict2[@"b80"]]) {
                [DHLoginUserDao asyncInsertLoginUserToDbWithItem:item];
            }
            
            
            [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"] username:username password:password];
            
        }else if ([codeNum intValue] == 2010){
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            NSLog(@"用户信息审核不通过,请检查用户信息,或者联系客服人员");
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else{
            [self showHint:[infoDic objectForKey:@"msg"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
#pragma mark 请求信息
// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2 username:(NSString *)userName password:(NSString *)passWord
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    //
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            
            
            NSDictionary *dict2 = infoDic[@"body"];
            NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
            if ([dict2 objectForKey:@"b112"][@"b69"]!=nil) {
                
                DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
                [item setValuesForKeysWithDictionary:dict2];
                if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                    [DHUserInfoDao insertUserToDBWithItem:item];
                }else{
                    [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
                }
                NSNumber *b34 = [dict2 objectForKey:@"b112"][@"b34"];
                [NSGetTools upDateB34:b34];
                NSNumber *b144 = [dict2 objectForKey:@"b112"][@"b144"];
                [NSGetTools upDateUserVipInfo:b144];
                [NSGetTools updateUserNickName:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"]];
                [NSGetTools updateUserSexInfoWithB69:b69];
                // 系统生成用户号
                NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
                [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
                [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
                [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
                [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
//                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",passWord,@"password",[dict2 objectForKey:@"b112"][@"b80"],@"userId",[dict2 objectForKey:@"b112"][@"b101"],@"sessionId",[dict2 objectForKey:@"b112"][@"b69"],@"gender", nil];
//                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
//                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"SaveregUserAction"];
                [_userInfoDict removeAllObjects];
                //登录
                [NSGetTools updateIsLoadWithStr:@"isLoad"];
                [self gotoMainView];
                
            }else{
                //当前页面
                SexSelectViewController *sexVC=[[SexSelectViewController alloc]init];
                UINavigationController *sexNav=[[UINavigationController alloc]initWithRootViewController:sexVC];
                sexVC.isNotThird=NO;
                [self presentViewController:sexNav animated:YES completion:nil];
            }
            
        }
        
        //        NSLog(@"用户信息-----%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
}
// 登陆成功
- (void)gotoMainView{
    //发送自动登陆状态通知
    //新用户跳转账号安全
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.isNewUser) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@"YES"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@"NO"];
    }
    
}
#pragma mark 第三方
#pragma mark 微信第三方
//微信绑定
- (void)WXBoundAction:(NSNotification *)sender{
    NSDictionary *dict=sender.object;
    [self.userInfoDict setDictionary:dict];
    
    [self sendUserInfoToServer];
}
//微信登陆
- (void)WXLoginAction:(NSNotification *)sender{
    NSDictionary *dict=sender.object;
    [self.userInfoDict setDictionary:dict];
    self.isNewUser=NO;
    
    [self loginWithUserId:[dict objectForKey:@"b80"] sessionId:[dict objectForKey:@"b101"] username:[dict objectForKey:@"b163"] password:[dict objectForKey:@"b56"]];
    
}
//微信取消登录
- (void)WXBoundCancleAction:(NSNotification *)sender{
    NSString *islode=sender.object;
    if ([islode isEqualToString:@"YES"]) {
        [self hideHud];
        [self showHint:@"登录取消了!再试一次"];
    }else{
        [self showHudInView:self.view hint:@"请稍等.."];
    }
    
    
}
#pragma mark QQ第三方
- (void)tencentDidLogin
{
    
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        //记录登录用户的OpenID、Token以及过期时间
        [self.tencentOAuth getUserInfo];
        NSLog(@"登陆返回");
        [self showHudInView:self.view hint:@"请稍等.."];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        NSString *appinfoStr = [NSGetTools getAppInfoString];
        
        NSString *url = [NSString stringWithFormat:@"%@f_132_10_1.service?a162=%@&a167=%@&a169=%@&%@",kServerAddressTest4,@"2",self.tencentOAuth.openId,self.tencentOAuth.accessToken,appinfoStr];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *datas = responseObject;
            NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
            NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
            NSNumber *codeNum=infoDic[@"code"];
            if ([codeNum integerValue]==200) {
                NSDictionary *dict=infoDic[@"body"];
                [self.userInfoDict removeAllObjects];
                if ([infoDic[@"body"][@"b168"] integerValue]==0) {
                    
                    //去注册--绑定
                    [self.userInfoDict setDictionary:infoDic[@"body"]];
                    [self sendUserInfoToServer];
                    
                }else{
                    //登陆
                    self.isNewUser=NO;
                    
                    [self loginWithUserId:[dict objectForKey:@"b80"] sessionId:[dict objectForKey:@"b101"] username:[dict objectForKey:@"b163"] password:[dict objectForKey:@"b56"]];
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
        
        
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
        
    }
    
}

-(void)getUserInfoResponse:(APIResponse *)response

{
    
    NSLog(@"respons:%@",response.jsonResponse);
    
}

//非网络错误导致登录失败：

-(void)tencentDidNotLogin:(BOOL)cancelled

{
    
    NSLog(@"tencentDidNotLogin");
    
    if (cancelled)
        
    {
        [self hideHud];
        [self showHint:@"取消登陆"];
        NSLog(@"取消登陆");
        
    }else{
        [self hideHud];
        [self showHint:@"取消登陆"];
        NSLog(@"取消登陆");
        
    }
    
}
// 网络错误导致登录失败：

-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
    [self hideHud];
    [self showHint:@"无网络连接，请设置网络"];
}
- (void)sendUserInfoToServer{
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *result = [identifierForVendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    NSString *identifierForVendor = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_119_11_1.service?a151=%@&%@",kServerAddressTest,result,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *dict2 = infoDic[@"body"];
        //注册成功,将信息保存到服务器
        if ([codeNum integerValue] == 200) {
            //b101 sessionId sessionID
            //b80 userId 用户ID
            //b56 password 密码
            //b81 userName 用户名称
            NSString *sessionId = [dict2 objectForKey:@"b101"];
            NSString *userId = [dict2 objectForKey:@"b80"];
            NSString *password = [dict2 objectForKey:@"b56"];
            NSString *userName = [dict2 objectForKey:@"b81"];
            
            // -------- start 记录用户注册，用于后面诱惑机器人机制判断-------
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
            
            NSInteger interval = 24*60*60;
            
            NSString *tomorrow = [[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:interval]] substringWithRange:NSMakeRange(0, 10)];
            NSString *afterTomorrow = [[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:interval * 2]] substringWithRange:NSMakeRange(0, 10)];
            // 某用户某天注册的
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
            // 明天
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_registerDate",tomorrow,userId]];
            // 后天
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_registerDate",afterTomorrow,userId]];
            // ---- end 记录用户注册，用于后面诱惑机器人机制判断-----
            
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"regUser"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"SaveregUserAction"];
            //绑定数据不为空,为空则不是第三方登陆
            if (_userInfoDict.count>0) {
                [_userInfoDict setObject:userName forKey:@"userName"];
                [_userInfoDict setObject:password forKey:@"password"];
                [_userInfoDict setObject:dict2[@"b80"] forKey:@"userId"];
                [_userInfoDict setObject:dict2[@"b101"] forKey:@"sessionId"];
                [self boundAccound:_userInfoDict];
            }
            [MobClick event:@"registerSuccess"]; // 注册统计事件
            // 成功统计
            [self collectSaveWithStatus:3];
            // 注册成功,去保存性别
            if ([[_userInfoDict objectForKey:@"b165"] integerValue]==1||[[_userInfoDict objectForKey:@"b165"] integerValue]==2) {
                [self saveUserInfo:_userInfoDict];
                
            }else{
                [self hideHud];
                //当前页面
                SexSelectViewController *sexVC=[[SexSelectViewController alloc]init];
                UINavigationController *sexNav=[[UINavigationController alloc]initWithRootViewController:sexVC];
                [self presentViewController:sexNav animated:YES completion:nil];
            }
            
            
        }else{
            // 失败统计
            [self collectSaveWithStatus:4];
            [MobClick event:@"registerfail"]; // 注册失败统计事件
            [NSGetTools showAlert:[infoDic objectForKey:@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:@YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
/**
 *  保存统计信息 --by大海 2016年06月28日15:35:48
 */
- (void)collectSaveWithStatus:(NSInteger )status{
    [HttpOperation asyncCollectSaveWithUserType:status queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存注册统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
            //            [alert show];
        });
    }];
}
//绑定
- (void) boundAccound:(NSDictionary *)dictionary{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    
    NSString *url = [NSString stringWithFormat:@"%@f_132_11_1.service?a162=%@&a167=%@&a163=%@&a164=%@&a165=%@&a166=%@&a56=%@&p2=%@&p1=%@&%@",kServerAddressTest4,dictionary[@"b162"],dictionary[@"b167"],dictionary[@"userName"],dictionary[@"b164"],dictionary[@"b165"],dictionary[@"b166"],dictionary[@"password"],dictionary[@"userId"],dictionary[@"sessionId"],appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum=infoDic[@"code"];
        if ([codeNum integerValue]==200) {
            // 保存用户ID
            [NSGetTools upDateUserID:infoDic[@"body"][@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:infoDic[@"body"][@"b101"]];
            
            [self hideHud];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    
    
}
//保存信息
- (void)saveUserInfo:(NSDictionary *)dictionary{
    
    
    NSString *sessionId = [dictionary objectForKey:@"sessionId"];
    NSString *userId = [dictionary objectForKey:@"userId"];
    NSString *password = [dictionary objectForKey:@"password"];
    NSString *userName = [dictionary objectForKey:@"userName"];
    NSString *appInfo = [NSGetTools getAppInfoString];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //a34:id a69：性别
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,sessionId,userId,appInfo];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:[NSNumber numberWithInteger:[[dictionary objectForKey:@"b165"] integerValue]] forKey:@"a69"];
    
    [manger POST:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSString *b34 = [dict2 objectForKey:@"b34"];
            [NSGetTools upDateB34:[NSNumber numberWithInteger:[b34 integerValue]]];
            // 保存账号 密码
            [NSGetTools updateUserAccount:userName];
            [NSGetTools updateUserPassWord:password];
            
            // 保存用户ID
            NSNumber *userid=[NSNumber numberWithInteger:[userId integerValue]];
            [NSGetTools upDateUserID:userid];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:sessionId];
            [NSGetTools updateUserSexInfoWithB69:[NSNumber numberWithInteger:[[dictionary objectForKey:@"b165"] integerValue]]];
            
            
            [self getUserInfosWithp1:sessionId p2:userId username:userName password:password];
            
        }else{
            [NSGetTools showAlert:infoDic[@"msg"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
#pragma jyRegisterDelegate  代理
-(void)getRegisterType:(NSInteger)type{
    switch (type) {
        case 1000:
        {
            //QQ
            [MobClick event:@"QQRegister"]; // QQ统计事件
            self.isThird=YES;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:LoginMethodsQQ forKey:@"LoginMethodsInteger"];
            [userDefaults synchronize];
            self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1104937933"andDelegate:self];
            _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
            [self.tencentOAuth authorize:_permissions inSafari:NO];
            
        }
            break;
        case 1001:
        {
            //微信
            [MobClick event:@"WXRegister"]; // QQ统计事件
            self.isThird=YES;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:LoginMethodsWX forKey:@"LoginMethodsInteger"];
            [userDefaults synchronize];
            SendAuthReq *req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo"; // 此处不能随意改
            req.state = @"123"; // 这个貌似没影响
            [WXApi sendReq:req];
        }
            break;
        case 1002:
        {
            //触陌
            //当前页面
            SexSelectViewController *sexVC=[[SexSelectViewController alloc]init];
            UINavigationController *sexNav=[[UINavigationController alloc]initWithRootViewController:sexVC];
            sexVC.isNotThird=YES;
            [self presentViewController:sexNav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
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
