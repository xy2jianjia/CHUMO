//
//  AccountController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AccountController.h"
#import "PersonalController.h"
//#import "AccountCell.h"
//#import "NPhotoNumCell.h"
//#import "PassWordCell.h"
#import "NResetController.h"
#import "BindingController.h"
#import "DHAccountCell.h"
#import "DHPassWordCell.h"
#import "UserGuidedTwo.h"
//#define KCell_A @"cell_1"
#define KCell_B @"cell_2"
#define KCell_C @"cell_3"
#import "DHAlertView.h"
#import "YS_BindingThirdViewController.h"
#import "JYNavigationController.h"
@interface AccountController ()<UITableViewDataSource,UITableViewDelegate,DHAlertViewDelegate>
{
    UITableView *paraTabelView;
    
}

@end

@implementation AccountController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
    [paraTabelView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutParallax];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:
                        [UIColor whiteColor], NSForegroundColorAttributeName,
                        nil];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self showHudInView:self.view hint:@"请稍后..."];
    [self getPersonalDetailInfo];
    if (!self.isFromReg) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    }
    
    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES] ;
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)getPersonalDetailInfo{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *bodyDict = [infoDic objectForKey:@"body"];
        NSDictionary *resultDict = [bodyDict objectForKey:@"b112"];
        NSDictionary *b185Dict = [bodyDict objectForKey:@"b185"];
        if ([codeNum integerValue] == 200) {
            //用户信息保存
            NSDictionary *dict2 = infoDic[@"body"];
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
            [item setValuesForKeysWithDictionary:dict2];
            //            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b113"]];
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
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //设置绑定账号

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"QQBindedAccount"];//账号
            [userDefaults removeObjectForKey:@"WXBindedAccount"];
            [userDefaults removeObjectForKey:@"QQBindedAccountState"];//是否开发状态
            [userDefaults removeObjectForKey:@"WXBindedAccountState"];
            
            [userDefaults removeObjectForKey:@"QQBindingInfo"];
            [userDefaults removeObjectForKey:@"WXBindingInfo"];
            if ([resultDict objectForKey:@"b157"]) {
                [userDefaults setObject:[resultDict objectForKey:@"b157"] forKey:@"WXBindedAccount"];
                [userDefaults setObject:[resultDict objectForKey:@"b159"] forKey:@"WXBindedAccountState"];
                
            }
            if ([resultDict objectForKey:@"b156"]) {
                [userDefaults setObject:[resultDict objectForKey:@"b156"] forKey:@"QQBindedAccount"];
                [userDefaults setObject:[resultDict objectForKey:@"b158"] forKey:@"WXBindedAccountState"];
            }
            
            [userDefaults synchronize];
            
            if (b185Dict.count>0) {
                //b185
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                for (NSDictionary *dictBind in b185Dict) {
                    if ([dictBind[@"b162"] integerValue]==2) {
                        [userDefaults setObject:dictBind forKey:@"QQBindingInfo"];
                    }if ([dictBind[@"b162"] integerValue]==1) {
                        [userDefaults setObject:dictBind forKey:@"WXBindingInfo"];
                    }
                }
                
                [userDefaults synchronize];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [paraTabelView reloadData];
            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)layoutParallax
{
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
//    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    
    paraTabelView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//    [paraTabelView registerClass:[AccountCell class] forCellReuseIdentifier:KCell_A];
//    [paraTabelView registerClass:[NPhotoNumCell class] forCellReuseIdentifier:KCell_B];
//    [paraTabelView registerClass:[PassWordCell class] forCellReuseIdentifier:KCell_C];
    [paraTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:paraTabelView];
    UIView *bottomView = [[UIView alloc]init];
    if (_isFromReg) {
        bottomView.frame = CGRectMake(0, 0, ScreenWidth, 50);
        UIButton *gotoMainVcBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        gotoMainVcBtn.frame = CGRectMake(CGRectGetMidX(bottomView.bounds)-50, 10, 100, CGRectGetHeight(bottomView.bounds)-20);
        [gotoMainVcBtn setTitle:@"返回主页" forState:(UIControlStateNormal)];
        gotoMainVcBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [gotoMainVcBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1 ] forState:(UIControlStateNormal)];
        gotoMainVcBtn.layer.cornerRadius = 5;
        gotoMainVcBtn.layer.masksToBounds = YES;
        gotoMainVcBtn.backgroundColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
        [gotoMainVcBtn addTarget:self action:@selector(gotoMainVcBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [bottomView addSubview:gotoMainVcBtn];
        // 设置从注册过来的
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromRegitser"];
    }
    paraTabelView.tableFooterView = bottomView;
}

- (void)gotoMainVcBtnAction{
    NSString *Userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:Userid];
    if (item.b57!=nil) {
        
        UserGuidedTwo *vc = [[UserGuidedTwo alloc] init];
        vc.title = @"上传头像";
        vc.isFromRegister = self.isFromReg;
        vc.sex = item.b69;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
//        nav.navigationBar.translucent = NO;
//        nav.navigationBar.barTintColor = MainBarBackGroundColor;
        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        [Mynotification postNotificationName:@"loginStateChange" object:nil];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        // 账号
        if (indexPath.row == 0) {
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"ID";
            cell.nameLabel.font = [UIFont systemFontOfSize:14];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserAccount]];
            cell.phoneOrIdLabel.text = userId;
            cell.accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            return cell;
        }else if(indexPath.row == 1){
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"QQ";
            cell.nameLabel.font = [UIFont systemFontOfSize:14];

            NSDictionary *QQBinding = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindingInfo"];
            NSString *QQAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindedAccount"];
            if (nil!=QQBinding && !(nil==QQAccount|| NULL==QQAccount || [QQAccount isKindOfClass:[NSNull class]] ||[[QQAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)) {
                cell.phoneOrIdLabel.text=[NSString stringWithFormat:@"%@",QQAccount];
            }else if (nil!=QQBinding && (nil==QQAccount|| NULL==QQAccount || [QQAccount isKindOfClass:[NSNull class]] ||[[QQAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)){
                cell.phoneOrIdLabel.text = @"填写QQ号,约会更高效";
            }else{
                cell.phoneOrIdLabel.text = @"未绑定";
            }
            
            cell.phoneOrIdLabel.textColor = [UIColor colorWithRed:0.918 green:0.200 blue:0.353 alpha:1.000];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if(indexPath.row==2){
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"微信账号";
            cell.nameLabel.font = [UIFont systemFontOfSize:14];
            NSDictionary *WXBinding = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindingInfo"];
            NSString *WXAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindedAccount"];
            if (nil!=WXBinding && !(nil==WXAccount|| NULL==WXAccount || [WXAccount isKindOfClass:[NSNull class]] ||[[WXAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)) {
                cell.phoneOrIdLabel.text=[NSString stringWithFormat:@"%@",WXAccount];
            }else if (nil!=WXBinding && (nil==WXAccount|| NULL==WXAccount || [WXAccount isKindOfClass:[NSNull class]] ||[[WXAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)){
                cell.phoneOrIdLabel.text = @"填写微信号,约会更高效";
            }else{
                cell.phoneOrIdLabel.text = @"未绑定";
            }
            cell.phoneOrIdLabel.textColor = [UIColor colorWithRed:0.918 green:0.200 blue:0.353 alpha:1.000];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if(indexPath.row==3){
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"手机号";
            cell.nameLabel.font = [UIFont systemFontOfSize:14];

            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
            NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
            
            if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
                // 长度为11位，第二位不为0，为已经绑定手机
                NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
                if ([userName length] == 11 && [secNumber integerValue] != 0) {
                    cell.phoneOrIdLabel.text=[NSString stringWithFormat:@"可用%@登录",userName];
                }else{
                    cell.phoneOrIdLabel.text = @"绑定手机号,可用于登陆,找回密码!";
                }
            }
            cell.phoneOrIdLabel.textColor = [UIColor colorWithRed:0.918 green:0.200 blue:0.353 alpha:1.000];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            return nil;
        }
    }else{
        // 账号
        if (indexPath.row == 0) {
            
            
            // 密码
            DHPassWordCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHPassWordCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selected = NO;
            BOOL isShowPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowPassWord"];
            if (isShowPassWord) {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
                NSString *password = [dict objectForKey:@"password"];
                cell.passwordLabel.text = password;
                cell.passwordLabel.font = [UIFont systemFontOfSize:14];
                cell.eyeImageV.image = [UIImage imageNamed:@"睁眼.png"];
            }else{
                cell.passwordLabel.text = @"******";
                cell.eyeImageV.image = [UIImage imageNamed:@"闭眼.png"];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeShowPasswordStyle:)];
            //            cell.eyeImageV.userInteractionEnabled = YES;
            [cell.eyeView addGestureRecognizer:tap];
            return cell;
        }else if(indexPath.row == 1){
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"重置密码";
            cell.nameLabel.font = [UIFont systemFontOfSize:14];
            cell.phoneOrIdLabel.text = @"设置您自己的密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
           return nil;
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return @"账号";
        }
            break;
        case 1:
        {
            return @"安全";
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)changeShowPasswordStyle:(UITapGestureRecognizer *)sender{
    DHPassWordCell *cell = (DHPassWordCell *)[[sender.view superview] superview];
    BOOL isShowPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowPassWord"];
    if (isShowPassWord) {
        cell.passwordLabel.text = @"******";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowPassWord"];
        cell.eyeImageV.image = [UIImage imageNamed:@"闭眼.png"];
    }else{
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        NSString *password = [dict objectForKey:@"password"];
        cell.passwordLabel.text = password;
        cell.eyeImageV.image = [UIImage imageNamed:@"睁眼.png"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPassWord"];
    }
}
#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 60;
    }else{
       return 43;
    }
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//     UITouch *touch = [touches anyObject];
//    NSInteger tagNum = touch.view.tag;
//    if (tagNum==1300) {
//        DHPassWordCell *cell = (DHPassWordCell *)[paraTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//        BOOL isShowPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowPassWord"];
//        if (isShowPassWord) {
//            cell.passwordLabel.text = @"******";
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowPassWord"];
//            cell.eyeImageV.image = [UIImage imageNamed:@"dismiss_pwd.png"];
//        }else{
//            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
//            NSString *password = [dict objectForKey:@"password"];
//            cell.passwordLabel.text = password;
//            cell.eyeImageV.image = [UIImage imageNamed:@"show_pwd.png"];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPassWord"];
//        }
//    }
//}
#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"账号";
//    }else{
//        return <#expression#>
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return [self addtext:@"账号"];
//        
//    }else {
//        return [self addtext:@"安全"];
//        
//    }
//    
//}
//
///*
// * text 文字
// */
//- (UIView *)addtext:(NSString *)text {
//
//    UIView *allView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    allView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
//    UILabel *account = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 40, 35)];
//    account.text = text;
//    [account.font fontWithSize:20.0f];
//    account.textColor = kUIColorFromRGB(0x999999);
//    [allView addSubview:account];
//    return allView;
//}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 3) {
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
        NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
        if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
            // 长度为11位，第二位不为0，为已经绑定手机
            NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
            if ([userName length] == 11 && [secNumber integerValue] != 0) {
                BindingController *bind = [[BindingController alloc] init];
                bind.navigationItem.title = @"已绑定手机号";
                [self.navigationController pushViewController:bind animated:YES];
            }else{
                NResetController *reset = [[NResetController alloc] init];
                reset.msgType = @"3";
                reset.navigationItem.title=@"绑定手机号";
                [self.navigationController pushViewController:reset animated:YES];
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSGetTools showAlert:@"用户信息过期，请重新登录"];
            });
        }
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        NResetController *reset = [[NResetController alloc] init];
        reset.msgType = @"2";
        reset.navigationItem.title = @"重置密码";
        [self.navigationController pushViewController:reset animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        YS_BindingThirdViewController *bindThird=[[YS_BindingThirdViewController alloc]init];
        bindThird.ThirdBindFlag=ThirdBindingEnumQQ;
        [self.navigationController pushViewController:bindThird animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        YS_BindingThirdViewController *bindThird=[[YS_BindingThirdViewController alloc]init];
        bindThird.ThirdBindFlag=ThirdBindingEnumWX;
        [self.navigationController pushViewController:bindThird animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
