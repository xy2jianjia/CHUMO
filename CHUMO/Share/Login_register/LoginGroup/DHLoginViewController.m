//
//  DHLoginViewController.m
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DHLoginViewController.h"
#import "MainViewController.h"
#import "NResetController.h"
#import "SexSelectViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@interface DHLoginViewController ()<TencentLoginDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
//@property (weak, nonatomic) IBOutlet UIView *inputBgView;

@property (weak, nonatomic) IBOutlet UIView *inputUserNameBgView;
@property (weak, nonatomic) IBOutlet UIView *inputPasswordBgView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *userPassTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) UITableView *loginUserListTableView;
@property (strong, nonatomic) NSArray *loginUserList;

@property (assign, nonatomic) BOOL isLoginUserListBtnClicked;
@property (nonatomic,strong)CALayer *buttonLayer;
//微信
@property (weak, nonatomic) IBOutlet UIImageView *WXButton;
@property (weak, nonatomic) IBOutlet UILabel *WXLabel;
//分割线
@property (weak, nonatomic) IBOutlet UIImageView *orImageV;

//QQ
@property (weak, nonatomic) IBOutlet UIImageView *QQButton;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;

//约束设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;//距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdRightWidth;

//第三方登陆
@property (strong,nonatomic)TencentOAuth *tencentOAuth;
@property (nonatomic,strong)NSMutableDictionary *userInfoDict;
@property (nonatomic,assign)BOOL isNewUser;
@property (strong,nonatomic)NSArray *permissions;
@property (nonatomic,assign)BOOL isLoding;
@end

@implementation DHLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)configView{
    self.isLoding=YES;
    [self.userNameTextFiled becomeFirstResponder];
    UIColor *color = HexRGB(0xaaaaaa);
    self.userNameTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入用户账号" attributes:@{NSForegroundColorAttributeName: color}];
    self.userPassTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.inputUserNameBgView.layer.masksToBounds = YES;
    
    self.inputUserNameBgView.layer.borderColor=HexRGB(0x934ce5).CGColor;
    self.inputUserNameBgView.layer.borderWidth=1;
    self.inputUserNameBgView.layer.cornerRadius=CGRectGetHeight(self.inputUserNameBgView.frame)/2;
    //    self.inputUserNameBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputPasswordBgView.layer.masksToBounds = YES;
    self.inputPasswordBgView.layer.borderColor=HexRGB(0x934ce5).CGColor;
    self.inputPasswordBgView.layer.borderWidth=1;
    self.inputPasswordBgView.layer.cornerRadius=CGRectGetHeight(self.inputPasswordBgView.frame)/2;
    self.loginBtn.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *WxtapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WXButtonAction:)];
    self.WXButton.userInteractionEnabled=YES;
    [self.WXButton addGestureRecognizer:WxtapGes];
    
    UITapGestureRecognizer *QqtapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(QQButtonAction:)];
    self.QQButton.userInteractionEnabled=YES;
    [self.QQButton addGestureRecognizer:QqtapGes];
    
    if (self.isthird) {
        self.WXButton.hidden=NO;
        self.WXLabel.hidden=NO;
        self.QQButton.hidden=NO;
        self.QQLabel.hidden=NO;
        self.orImageV.hidden=NO;
    }else{
        self.WXButton.hidden=YES;
        self.WXLabel.hidden=YES;
        self.QQButton.hidden=YES;
        self.QQLabel.hidden=YES;
        self.orImageV.hidden=YES;
    }
    if (![WXApi isWXAppInstalled]) {
        self.WXButton.hidden=YES;
        self.WXLabel.hidden=YES;
        
        self.thirdRightWidth.constant=ScreenWidth/2-20;
    }
    if (iPhone4) {
        self.topSpaceConstraint.constant=20;
        self.centerSpaceConstraint.constant=20;
        self.thirdSpaceConstraint.constant=40;
        self.thirdWidth.constant=40;

    }


    //b101 sessionId sessionID
    //b80 userId 用户ID
    //b56 password 密码
    //b81 userName 用户名称
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSArray *arr = [DHLoginUserDao asyncGetLoginUserList];
    DHLoginUserForListModel *user = [arr firstObject];
    if (user) {
        self.userNameTextFiled.text = user.userName;
        self.userPassTextField.text = user.passWord;
    }else{
        self.userNameTextFiled.text = [dict objectForKey:@"userName"];
        self.userPassTextField.text = [dict objectForKey:@"password"];
    }

    
    [self.buttonLayer removeFromSuperlayer];
    self.buttonLayer=[CALayer layer];
    self.buttonLayer.contentsScale=[[UIScreen mainScreen] scale];
    self.buttonLayer.contents=(id)[UIImage imageNamed:@"w_login_arrow"].CGImage;
    self.buttonLayer.frame=CGRectMake(10, 6, 24, 24);
    [self.oldloginButton.layer addSublayer:self.buttonLayer];
}
- (void)sethideKeyBoardAccessoryView{
    UIView *accessoryView = [[UIView alloc]init];
    accessoryView.frame = CGRectMake(0, 0, ScreenWidth, 30);
    accessoryView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    UIButton *doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    doneBtn.frame = CGRectMake(CGRectGetMaxX(accessoryView.bounds) - 50, CGRectGetMinY(accessoryView.bounds), 40,30);
    //    doneBtn.backgroundColor = [UIColor grayColor];
    [doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [doneBtn setTitleColor:[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000] forState:(UIControlStateNormal)];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.userNameTextFiled.inputAccessoryView = accessoryView;
    self.userPassTextField.inputAccessoryView = accessoryView;
}
- (IBAction)configLoginUserListAction:(id)sender {
    if (self.isLoginUserListBtnClicked) {
        //未选中
        UIButton *button=(UIButton *)sender;
        [self.buttonLayer removeFromSuperlayer];
        self.buttonLayer=[CALayer layer];
        self.buttonLayer.contentsScale=[[UIScreen mainScreen] scale];
        self.buttonLayer.contents=(id)[UIImage imageNamed:@"w_login_arrow"].CGImage;
        self.buttonLayer.frame=CGRectMake(10, 6, 24, 24);
        [button.layer addSublayer:self.buttonLayer];
        [_loginUserListTableView removeFromSuperview];
        _loginUserListTableView.delegate = nil;
        _loginUserListTableView.dataSource = nil;
        _loginUserListTableView = nil;
        
    }else{
        //选中
        UIButton *button=(UIButton *)sender;
        [self.buttonLayer removeFromSuperlayer];
        self.buttonLayer=[CALayer layer];
        self.buttonLayer.contentsScale=[[UIScreen mainScreen] scale];
        self.buttonLayer.contents=(id)[UIImage imageNamed:@"w_list_arrow"].CGImage;
        self.buttonLayer.frame=CGRectMake(10, 6, 24, 24);
        [button.layer addSublayer:self.buttonLayer];
        
        self.loginUserList = [DHLoginUserDao asyncGetLoginUserList];
        if (self.loginUserList.count > 0) {
            CGRect temp = self.inputUserNameBgView.frame;
            if (!self.loginUserListTableView) {
                self.loginUserListTableView = [[UITableView alloc]init];
            }
            
            if (self.loginUserList.count>5) {
                self.loginUserListTableView.frame = CGRectMake(CGRectGetMinX(temp)+20, CGRectGetMaxY(temp), CGRectGetWidth(temp)-40, 5 * 40);
            }else{
                self.loginUserListTableView.frame = CGRectMake(CGRectGetMinX(temp)+20, CGRectGetMaxY(temp), CGRectGetWidth(temp)-40, self.loginUserList.count * 40);
            }
            self.loginUserListTableView.delegate = self;
            self.loginUserListTableView.dataSource = self;
            self.loginUserListTableView.backgroundColor=[UIColor whiteColor];
            
            [self.view addSubview:_loginUserListTableView];
            
            [self.loginUserListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        }
    }
    self.isLoginUserListBtnClicked = !self.isLoginUserListBtnClicked;
    
}
//-(void)viewDidLayoutSubviews{
//    CGRect temp = _userNameTextFiled.frame;
//    self.loginUserListTableView.frame = CGRectMake(CGRectGetMinX(temp), CGRectGetMaxY(temp)+250, CGRectGetWidth(temp), self.loginUserList.count * 30);
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.loginUserList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    DHLoginUserForListModel *item = [self.loginUserList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.userName;
    cell.textLabel.textColor=[UIColor colorWithWhite:0.400 alpha:1.000];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DHLoginUserForListModel *item = [self.loginUserList objectAtIndex:indexPath.row];
    self.userNameTextFiled.text = item.userName;
    self.userPassTextField.text = item.passWord;
    [self.loginUserListTableView removeFromSuperview];
    self.isLoginUserListBtnClicked = !self.isLoginUserListBtnClicked;
    //改变按钮
    [self.buttonLayer removeFromSuperlayer];
    self.buttonLayer=[CALayer layer];
    self.buttonLayer.contentsScale=[[UIScreen mainScreen] scale];
    self.buttonLayer.contents=(id)[UIImage imageNamed:@"w_login_arrow"].CGImage;
    self.buttonLayer.frame=CGRectMake(10, 6, 24, 24);
    [self.oldloginButton.layer addSublayer:self.buttonLayer];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)doneAction{
    [self.userNameTextFiled resignFirstResponder];
    [self.userPassTextField resignFirstResponder];
}
#pragma mark 登录
- (IBAction)loginBtnAction:(id)sender {
    [self.userNameTextFiled resignFirstResponder];
    [self.userPassTextField resignFirstResponder];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userName = self.userNameTextFiled.text;
    NSString *userPass = self.userPassTextField.text;
    [self showHudInView:self.view hint:@"请稍等.."];
    self.isLoding=YES;
    [self loginWithUserId:[dict objectForKey:@"b80"] == nil ?@"":[dict objectForKey:@"b80"] sessionId:[dict objectForKey:@"b101"]==nil?@"":[dict objectForKey:@"b101"] username:userName password:userPass];
    
}
#pragma mark 注册
- (IBAction)regBtnAction:(id)sender {
    //触陌
    //当前页面
    SexSelectViewController *sexVC=[[SexSelectViewController alloc]init];
    UINavigationController *sexNav=[[UINavigationController alloc]initWithRootViewController:sexVC];
    sexVC.isNotThird=YES;
    [self presentViewController:sexNav animated:YES completion:nil];
    
}
#pragma mark 忘记密码
- (IBAction)forgetPassBtnAction:(id)sender {
    NResetController *reset = [[NResetController alloc] init];
    reset.title = @"重置密码";
    reset.msgType = @"2";
    reset.isFromLoginVc = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:reset];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:reset animated:YES];
    
}
#pragma mark 返回首页
- (IBAction)goBackGroudAction:(id)sender {
    MainViewController *vc = [[MainViewController alloc]init];
    vc.title = @"注册";
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginWithUserId:(NSString *)userId sessionId:(NSString *)sessionId username:(NSString *)username password :(NSString *)password{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p2=%@&p1=%@&%@",kServerAddressTest,username,password,userId,sessionId,appinfoStr];
    
    //    [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p1=%@&p2=%@",kServerAddressTest,username,password,userId,sessionId];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
//        NSLog(@"-登陆->%@",infoDic);
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
            if ([self.whoVC isEqualToString:@"check"]) {
                // 提交用户信息
                [self sendUserInfos];
                [self sendHeadIcon];// 提交头像
            }

            [_userInfoDict removeAllObjects];
            [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"] username:username password:password];
            

            
        }else if ([codeNum intValue] == 2010){
            [self hideHud];
            NSLog(@"输入密码错误,请检查");
            [NSGetTools shotTipAnimationWith:_userPassTextField];
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            [self hideHud];
            NSLog(@"用户信息审核不通过,请检查用户信息,或者联系客服人员");
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else{
            [self hideHud];
            [self showHint:[infoDic objectForKey:@"msg"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
// 提交用户保存信息
- (void)sendUserInfos
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service?",kServerAddressTest];
    NSMutableDictionary *dict = [NSGetTools getUserInfoDict];
    
//    NSLog(@"---dict->-%@----",dict);
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            NSNumber *b34 = dict2[@"b34"];
            [NSGetTools upDateB34:b34];
            
        }
        
        
//        NSLog(@"---提交用户信息--%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
    
}
// 提交头像保存信息  /LP-file-msc/f_107_10_2.service
- (void)sendHeadIcon
{
    
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_107_10_2.service?",kServerAddressTest3];
    
    UIImage *iconImage = [NSGetTools getHeadIcon];
    NSData *iconData = UIImageJPEGRepresentation(iconImage, 1.0);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    
//    NSLog(@"--DICT-%@---",dict);
    [manger POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:iconData name:@"a102" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        
        
        if ([codeNum intValue] == 200) {
            NSArray *iconArray = infoDic[@"body"];
            
            for (NSDictionary *dict in iconArray) {
                if ([dict[@"b78"] intValue] == 1000) {
                    NSNumber *b34Num = dict[@"b34"];
                    NSNumber *b75Num = dict[@"b75"];
                    NSString *iconUrl = dict[@"b57"];
                    [NSGetTools upDateIconB34:b34Num];
                    [NSGetTools upDateIconB75:b75Num];
                    [NSGetTools upDateIconB57:iconUrl];
                }
            }
        }
        
//        NSLog(@"头像保存--%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"头像保存--%@--",error);
    }];
    
    
}
// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2 username:(NSString *)userName password:(NSString *)passWord{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];

    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];

    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            
            NSDictionary *dict2 = infoDic[@"body"];
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
                NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
                [NSGetTools updateUserSexInfoWithB69:b69];
                [NSGetTools updateUserNickName:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"]];
                // 系统生成用户号
                NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
                [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
                [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
                [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
                [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
                [_userInfoDict removeAllObjects];
                [NSGetTools updateIsLoadWithStr:@"isLoad"];
                self.isLoding=NO;
                [self hideHud];
                [self gotoMainView];
            }else{
                [self hideHud];
                [_userInfoDict removeAllObjects];
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
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInfoDict=[NSMutableDictionary dictionary];
    self.isNewUser=YES;
    [self configView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self sethideKeyBoardAccessoryView];
    if (iPhone4) {
//        [self loadIPhone4];
    }
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [Mynotification addObserver:self selector:@selector(WXBoundAction:) name:@"WXBoundAction" object:nil];
    [Mynotification addObserver:self selector:@selector(WXLoginAction:) name:@"WXLoginAction" object:nil];
    [Mynotification addObserver:self selector:@selector(WXBoundCancleAction:) name:@"WXBoundCancleAction" object:nil];
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self.userNameTextFiled resignFirstResponder];
    [self.userPassTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 键盘事件处理
//键盘出现
- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    if (iPhone4) {
        CGRect rect=self.view.frame;
        rect.origin.y= -100;
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=rect;
        }];
        
    }
    if (iPhone5) {
        
        CGRect rect=self.view.frame;
        rect.origin.y= -50;
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=rect;
        }];
    }
    
}
//键盘消失
- (void)keyboardWillHide:(id)sender{
    [UIView animateWithDuration:1 animations:^{
        self.view.frame=CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    }];
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
                sexVC.isNotThird=NO;
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
