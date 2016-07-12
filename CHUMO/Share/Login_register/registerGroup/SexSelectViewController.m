//
//  SexSelectViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "SexSelectViewController.h"
#import "NPServiceViewController.h"

@interface SexSelectViewController ()
@property (nonatomic,assign)NSInteger gender;
@end

@implementation SexSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"选择性别";
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=MainBarBackGroundColor;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
    self.trueButton.layer.cornerRadius=20;
    self.trueButton.layer.masksToBounds=YES;
    
    //默认选择帅哥
    self.gender=1;
    
    UITapGestureRecognizer *panManGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ManAction:)];
    self.manView.userInteractionEnabled=YES;
    [self.manView addGestureRecognizer:panManGesture];

    UITapGestureRecognizer *panWomanGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WoManAction:)];
    self.feManView.userInteractionEnabled=YES;
    [self.feManView addGestureRecognizer:panWomanGesture];
    

    
}
- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---注册---绑定账号
- (void)sendUserInfoToServer{
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    NSString *result = [identifierForVendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    NSString *identifierForVendor = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    
    NSString *result = [NSGetTools getIMEI];
    
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
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"SaveregUserAction"];
            
            //绑定数据不为空,为空则不是第三方登陆
            
            [MobClick event:@"registerSuccess"]; // 注册统计事件
            // 成功统计
            [self collectSaveWithStatus:3];

            [self saveUserInfo];
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


- (void)ManAction:(id)sender{
    self.gender=1;
    self.feManClickImage.image=[UIImage imageNamed:@"w_xuanzexingbie_q"];
    self.manClickImage.image=[UIImage imageNamed:@"w_xuanzexingbie_xz"];
}
- (void)WoManAction:(id)sender{
    self.gender=2;
    self.feManClickImage.image=[UIImage imageNamed:@"w_xuanzexingbie_xz"];
    self.manClickImage.image=[UIImage imageNamed:@"w_xuanzexingbie_q"];
    
}
- (IBAction)saveUserSexAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等..."];
    });
    if (self.gender==1) {
        [MobClick event:@"boyRegister"]; // 男孩统计事件
    }else{
        self.gender = 2;
        [MobClick event:@"girlRegister"]; // 女孩统计事件
    }
    if (!self.isNotThird) {//第三方登陆
        //去保存性别
        [self saveUserInfo];
        
    }else{
        [MobClick event:@"CMRegister"]; // 触陌统计事件
        //去注册并保存性别
        [self sendUserInfoToServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存信息
- (void)saveUserInfo{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveregUserAction"];
    
    NSString *sessionId = [dict objectForKey:@"sessionId"];
    NSString *userId = [dict objectForKey:@"userId"];
    NSString *password = [dict objectForKey:@"password"];
    NSString *userName = [dict objectForKey:@"userName"];
    NSString *appInfo = [NSGetTools getAppInfoString];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //a34:id a69：性别
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,sessionId,userId,appInfo];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];

    [dataDict setObject:[NSNumber numberWithInteger:self.gender] forKey:@"a69"];
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
            
            [self loginWithUserId:userId sessionId:sessionId username:userName password:password];
        }else{
            [NSGetTools showAlert:infoDic[@"msg"]];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
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
            //[NSGetTools updateIsLoadWithStr:@"isLoad"];
            NSLog(@"登陆成功");
            DHLoginUserForListModel *item = [[DHLoginUserForListModel alloc]init];
            item.userId = dict2[@"b80"];
            item.userName = username;
            item.passWord = password;
            item.sessionId = dict2[@"b101"];
            if (![DHLoginUserDao checkLoginUserWithUsertId:dict2[@"b80"]]) {
                [DHLoginUserDao asyncInsertLoginUserToDbWithItem:item];
            }
            
            [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"]];
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
// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    //    NSDictionary *dict = [NSGetTools getAppInfoDict];
    //    NSString *p1 = [dict objectForKey:@"p1"];
    //    NSString *p2 = [dict objectForKey:@"p2"];
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
            NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
            [NSGetTools updateUserSexInfoWithB69:b69];
            [NSGetTools updateUserNickName:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"]];
            // 系统生成用户号
            NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [NSGetTools updateIsLoadWithStr:@"isLoad"];
                [self gotoMainView];
            });
            
        }
        
        //        NSLog(@"用户信息-----%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
}
// 登陆成功
- (void)gotoMainView{
    //发送自动登陆状态通知
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@"YES"];
    
}
- (IBAction)userAgree:(id)sender {
    
    NPServiceViewController *temp = [[NPServiceViewController alloc] init];
    temp.urlWeb = [NSString stringWithFormat:@"%@service.html",kServerAddressTestH5,nil]; ;
    [self.navigationController pushViewController:temp animated:true];
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
