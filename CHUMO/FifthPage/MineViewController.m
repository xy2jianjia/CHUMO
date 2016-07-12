//
//  MineViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MineViewController.h"
#import "MyDataViewController.h"
#import "MyPhotoViewController.h"
#import "FriendController.h"
#import "PersonalController.h"
#import "Homepage.h"
#import "ConditionController.h"
#import "MeTouchController.h"
#import "TouchMeController.h"
#import "SeenMeController.h"
#import "NoVipController.h"
#import "SeenMeVipController.h"
#import "HFVipViewController.h"
#import "NPOpinionController.h"
#import "AccountController.h"
#import "MineTableViewCell.h"
#import "RefreshController.h"
#import "YS_VipCenterViewController.h"
#import "JYNavigationController.h"
@interface MineViewController () <UITableViewDataSource,UITableViewDelegate> {

    NSInteger *integerFir;
    UIImageView *backImageView;
}

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *IDLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyDataViewController *mydata;
@property (nonatomic,strong) DHUserInfoModel *userinfo;
////导航条
//@property (nonatomic,strong)JYNavigationController *nav;
////透明度
//@property (nonatomic,assign)CGFloat alphaNum;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [self.nav setNavigationBarBackgroundImage:@"w_wo_grzy_xpmb" andAlph:self.alphaNum];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.tableView reloadData];
    [self getUserInfosWhenUpdate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
//    //导航条
//    self.nav = (JYNavigationController *)self.navigationController;
//    //透明度
//    self.alphaNum=0.0;
//    [self.nav setAlph:self.alphaNum];
//    [self.nav setNavigationBarBackgroundImage:@"w_wo_grzy_xpmb"];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = HexRGB(0xffffff);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self getPersonalDetailInfo];
    self.navigationItem.title=@"我的";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentifier"];
    // Do any additional setup after loading the view.
    
    [self addHeaderView:nil];
    [self getUserHeaderImage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfosWhenUpdate) name:@"getUserInfosWhenUpdate" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeNickNameNotification:) name:@"ChangeNickNameNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeHeadImageNotification:) name:@"ChangeHeadImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
//改变昵称
-(void)ChangeNickNameNotification:(NSNotification *)sender{
    NSString *str=sender.object;
    _nameLabel.text = str;
}
//改变头像
- (void)ChangeHeadImageNotification:(NSNotification *)sender{
    NSString *str=sender.object;
    NSURL *url=[NSURL URLWithString:str];
    [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        [[DHTool shareTool] saveImage:image withName:@"headerImage.jpg"];
    });
    
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
/**
 *  获取用户头像LP-file-msc/f_107_11_1.service？a78-->156,120,90,72,1000(原图) （不传提取所有）
 */
- (void)getUserHeaderImage{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_107_11_1.service?a78=%@&p2=%@&p1=%@&%@",kServerAddressTest3,@"",userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSNumber *codeNum = infoDic[@"code"];
        NSArray *bodyArr = [infoDic objectForKey:@"body"];
//        NSDictionary *resultDict = [bodyDict objectForKey:@"b112"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addHeaderView:bodyArr];
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
            //b112
            _userinfo = [[DHUserInfoModel alloc]init];
            [_userinfo setValuesForKeysWithDictionary:resultDict];
//            [_userinfo setValuesForKeysWithDictionary:b113Dict];
            [_userinfo setValuesForKeysWithDictionary:bodyDict];
            
//            [[NSUserDefaults standardUserDefaults] setObject:resultDict forKey:@"personalDetailInfo"];
#pragma mark 计算百分比
            //性别和昵称是固定有的
            NSInteger totle=2;
            //计算数量
            if ([resultDict objectForKey:@"b4"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b67"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b74"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b5"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b33"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b19"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b62"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b86"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b88"]) {
                totle++;
            }
            
            //设置绑定账号
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"QQBindedAccount"];//账号
            [userDefaults removeObjectForKey:@"WXBindedAccount"];
            [userDefaults removeObjectForKey:@"QQBindedAccountState"];//是否开发状态
            [userDefaults removeObjectForKey:@"WXBindedAccountState"];
            if ([resultDict objectForKey:@"b157"]) {
                [userDefaults setObject:[resultDict objectForKey:@"b157"] forKey:@"WXBindedAccount"];
                [userDefaults setObject:[resultDict objectForKey:@"b159"] forKey:@"WXBindedAccountState"];
                
            }
            if ([resultDict objectForKey:@"b156"]) {
                [userDefaults setObject:[resultDict objectForKey:@"b156"] forKey:@"QQBindedAccount"];
                [userDefaults setObject:[resultDict objectForKey:@"b158"] forKey:@"WXBindedAccountState"];
            }
            
            [userDefaults synchronize];
            
            [NSGetTools updateUserNickName:[resultDict objectForKey:@"b52"]];
            // 详细信息
            // 邮箱
            //                            if ([Valuedic objectForKey:@"b88"]) {
            //                                [self.basicInfoArr addObject:[Valuedic objectForKey:@"b88"]];
            //                            }
            //                            // 注册意向
            //                            if ([Valuedic objectForKey:@"b88"]) {
            //                                [self.basicInfoArr addObject:[Valuedic objectForKey:@"b88"]];
            //                            }
            if ([resultDict objectForKey:@"b46"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b32"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b29"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b8"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b31"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b45"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b47"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b39"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b30"]) {
                totle++;
            }
//            if ([resultDict objectForKey:@"b145"]) {
//                totle++;
//            }
            if ([resultDict objectForKey:@"b146"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b57"]) {
                totle++;
            }
            if ([resultDict objectForKey:@"b194"]) {
                totle++;
            }// b194 交友目的
            if ([resultDict objectForKey:@"b197"]) {
                totle++;
            }// b197 爱爱地点
            if ([resultDict objectForKey:@"b196"]) {
                totle++;
            }// b196 约会干嘛
            if ([resultDict objectForKey:@"b195"]) {
                totle++;
            }// b195 恋爱观
            // 个性特征
            if ([resultDict objectForKey:@"b37"]) {
                
                if (![[[resultDict objectForKey:@"b37"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                    totle++;
                }
            }
            if ([resultDict objectForKey:@"b24"]) {
                
                if (![[[resultDict objectForKey:@"b24"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                    totle++;
                }
            }
            CGFloat sum = ((totle)/28.0)*100;
            
            [userDefaults setFloat:sum forKey:@"infoComplete"];
            [userDefaults synchronize];
            [self.tableView reloadData];
            
            if (b185Dict.count>0) {
                //b185
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"QQBindingInfo"];
                [userDefaults removeObjectForKey:@"WXBindingInfo"];
                for (NSDictionary *dictBind in b185Dict) {
                    if ([dictBind[@"b162"] integerValue]==2) {
                        [userDefaults setObject:dictBind forKey:@"QQBindingInfo"];
                    }if ([dictBind[@"b162"] integerValue]==1) {
                        [userDefaults setObject:dictBind forKey:@"WXBindingInfo"];
                    }
                    
                }

                [userDefaults synchronize];
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
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 头区
//            [self addHeaderView];
//        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
//    NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];
//    if ([attr isEqualToString:@"2,7"]) {
//        return 2;
//    }else{
      return 4;
//    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
    NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];

        if (section == 1) {
            return 4;
        }else if (section == 2) {
            return 3;
        }else if(section == 3){
            return 0;
        }else{
            return 1;
        }
//    }
    
}
// 请求用户信息
- (void)getUserInfosWhenUpdate
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    //    LP-bus-msc/ f_108_13_1
    //    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
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
            // 系统生成用户号
            NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSArray *array=[[NSArray alloc] initWithObjects:[dict2 objectForKey:@"b112"], nil];
            
            [self addHeaderView:array];
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
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for(UIView *view in [cell.setContetnView subviews])
    {
        [view removeFromSuperview];
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
    NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];
        if (indexPath.section == 0) {
            cell.sysimageView.image = [UIImage imageNamed:@"w_wo_vip.png"];
            cell.heightSysImageConstraint.constant=16;
            cell.labelText.text = @"会员中心";
            cell.labelText.textColor = kUIColorFromRGB(0x323232);
            cell.havingLineView.hidden=YES;
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"Promotion"];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(0, 10, CGRectGetWidth(cell.setContetnView.frame), 20);
            label.text = [dict objectForKey:@"b22"];
            label.font = [UIFont systemFontOfSize:14];
            [label setTextAlignment:(NSTextAlignmentRight)];
            label.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
            [cell.setContetnView addSubview:label];
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-data.png"];
                cell.labelText.text = @"我的资料";
                //            CGRectMake(got(5), gotHeight(0), got(80), gotHeight(20))
                
                UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.setContetnView.frame)-got(80), 10, got(80), 20)];
                
                [cell.setContetnView addSubview:introduceLabel];
                introduceLabel.backgroundColor = [UIColor whiteColor];
                introduceLabel.layer.borderColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000].CGColor;
                introduceLabel.layer.borderWidth = 1;
                introduceLabel.layer.masksToBounds = YES;
                introduceLabel.layer.cornerRadius = 10;
                //            introduceLabel.text = @"资料100%";
                //得到百分百
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                //读取数据
                if ([userDefaultes objectForKey:@"infoComplete"]) {
                    
                    NSString *str = [userDefaultes objectForKey:@"infoComplete"];
                    CGFloat sum = [str floatValue];
                    introduceLabel.text = [NSString stringWithFormat:@"资料%.0f%%",sum,nil];
                }else{
                    introduceLabel.text = [NSString stringWithFormat:@"更新资料",nil];
                }
                
                introduceLabel.textAlignment = NSTextAlignmentCenter;
                introduceLabel.font = [UIFont systemFontOfSize:got(11)];
                introduceLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
                //            [cell.contentView addSubview:imageView];
            }
            if (indexPath.row == 1) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-photo.png"];
                cell.labelText.text = @"我的相册";
            }
            if (indexPath.row == 2) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-declaration.png"];
                cell.labelText.text = @"交友宣言";
            }
            if (indexPath.row == 3) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-conditions.png"];
                cell.labelText.text = @"择友条件";
                cell.havingLineView.hidden=YES;
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row==0) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-safety.png"];
                cell.labelText.text = @"账号安全";
                NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
                NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
                if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
                    // 长度为11位，第二位不为0，为已经绑定手机
                    NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
                    if ([userName length] == 11 && [secNumber integerValue] != 0) {
                        
                        
                    }else{
                        //判断是否绑定QQ,微信
                        NSDictionary *WXBinding = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindingInfo"];
                        NSDictionary *QQBinding = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindingInfo"];
                        if (nil==WXBinding && nil==QQBinding) {
                            UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(cell.setContetnView.frame), 20)];
                            introduceLabel.text = @"您的账号存在风险!";
                            introduceLabel.font = [UIFont systemFontOfSize:10];
                            [introduceLabel setTextAlignment:(NSTextAlignmentRight)];
                            introduceLabel.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
                            [cell.setContetnView addSubview:introduceLabel];
                        }
                        
                        
                    }
                }
 
                
            }
            if (indexPath.row==1) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-Feedback.png"];
                cell.labelText.text = @"意见反馈";
            }
            if (indexPath.row==2) {
                cell.sysimageView.image = [UIImage imageNamed:@"icon-set.png"];
                cell.labelText.text = @"系统设置";
                //隐藏分隔符
                cell.havingLineView.hidden=YES;
                //            cell.contentView.layer.borderWidth= 0;
            }
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
//    
    
    
}

#pragma mark --- 开通Vip
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
//    NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];
        if (indexPath.section == 0) { // vip会员
#pragma mark H5
//            HFVipViewController *vip = [[HFVipViewController alloc] init];
//            [self.navigationController pushViewController:vip animated:YES];
#pragma mark 支付原生
            YS_VipCenterViewController *vip = [[YS_VipCenterViewController alloc] init];
            vip.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vip animated:YES];
        }
        
        if (indexPath.section == 1 && indexPath.row == 0) { // 资料
            MyDataViewController *myDataVC = [MyDataViewController new];
            
            [self.navigationController pushViewController:myDataVC animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 1) { // 相册
            MyPhotoViewController *myPhotoVC = [MyPhotoViewController new];
            [self.navigationController pushViewController:myPhotoVC animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 2) { // 交友宣言
            FriendController *friend = [FriendController new];
            [self.navigationController pushViewController:friend animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 3) { // 交友宣言
            ConditionController *condition = [ConditionController new];
            condition.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:condition animated:YES];
        }
        if (indexPath.section == 2 && indexPath.row == 0) {  // 账号安全
            AccountController *account = [[AccountController alloc] init];
            account.title = @"账号安全";
            account.isFromReg=NO;
            account.navigationItem.hidesBackButton=YES;
            
            [self.navigationController pushViewController:account animated:YES];
        }
        if (indexPath.section == 2 && indexPath.row == 1) {  // 意见反馈
            // 意见反馈
            NPOpinionController *opinion = [[NPOpinionController alloc] init];
            opinion.title = @"意见反馈";
            self.navigationController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:opinion animated:YES];
        }
        if (indexPath.section == 2 && indexPath.row == 2) {  // 系统
            PersonalController *person = [[PersonalController alloc] init];
            person.title = @"系统设置";
            [self.navigationController pushViewController:person animated:YES];
        }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return gotHeight(8);
    }else if(section == 3){
        return 49;
    }else{
      return gotHeight(10);
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, gotHeight(8))];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

#pragma mark --- headerView
- (void)addHeaderView:(NSArray *)dict{
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    NSDictionary *userinfodict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, got(270))];
    backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, got(270))];
    backImageView.image=[UIImage imageNamed:@"w_wo_bg"];
    [view2 addSubview:backImageView];
    view2.backgroundColor = [UIColor clearColor];
    
    UILabel *toptitle=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-gotiphon6(60/2), 20, gotiphon6(60), 44)];
    toptitle.text=@"我";
    toptitle.font=[UIFont fontWithName:Typeface size:20.0f];
    toptitle.textAlignment=NSTextAlignmentCenter;
    toptitle.textColor=[UIColor whiteColor];
    [view2 addSubview:toptitle];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-gotiphon6(60/2), 74, gotiphon6(60), gotiphon6(60))];

    _headImageView.layer.cornerRadius = gotiphon6(60/2);
    _headImageView.clipsToBounds = YES;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (dict.count > 0) {
       [_headImageView sd_setImageWithURL:[NSURL URLWithString:[dict[0] objectForKey:@"b57"]] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           NSString *strFlag=nil;
           if ([userinfodict[@"b112"][@"b142"] integerValue]!=1) {
               if ([userinfodict[@"b112"][@"b142"] integerValue]==2) {
                   strFlag=@"审核中";
               }else if([userinfodict[@"b112"][@"b142"] integerValue]==3){
                   strFlag=@"审核不通过";
               }
               CALayer *statusLayer=[[CALayer alloc]init];
               statusLayer.frame=CGRectMake(0, 0, CGRectGetWidth(_headImageView.frame), CGRectGetWidth(_headImageView.frame));
               statusLayer.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.300].CGColor;
               [_headImageView.layer addSublayer:statusLayer];
               
               CATextLayer *textLayer=[[CATextLayer alloc]init];
               textLayer.string=strFlag;
               textLayer.fontSize=10;
               textLayer.alignmentMode=kCAAlignmentCenter;
               textLayer.contentsScale = [UIScreen mainScreen].scale;
               textLayer.foregroundColor=[UIColor whiteColor].CGColor;
               textLayer.frame=CGRectMake(CGRectGetMidX(_headImageView.bounds)-50, CGRectGetMidY(_headImageView.bounds)-10, 100, 20);
               
               [statusLayer addSublayer:textLayer];
           }
           
       }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict[0] objectForKey:@"b57"]]];
 
            UIImage *image = [UIImage imageWithData:data];
            [[DHTool shareTool] saveImage:image withName:@"headerImage.jpg"];
        });
    }else{
        _headImageView.image = [UIImage imageNamed:@"list_item_icon.png"];
    }
    
    [view2 addSubview:_headImageView];
    
    // 名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-got(200/2), CGRectGetMaxY(_headImageView.frame)+5, got(200), got(20))];

    _nameLabel.text = userinfodict[@"b112"][@"b52"];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.textColor = HexRGB(0Xffffff);
    [view2 addSubview:_nameLabel];
    
    //审核状态
 
    _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-got(150/2), CGRectGetMaxY(_nameLabel.frame)+5, got(150), got(20))];
    
    if ([userinfodict[@"b112"][@"b75"] integerValue]!=1) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-got(150/2), CGRectGetMaxY(_nameLabel.frame)+5, got(150), gotHeight(20))];
        _statusLabel.textColor = HexRGB(0Xffffff);
        _statusLabel.textAlignment=NSTextAlignmentCenter;
        if ([userinfodict[@"b112"][@"b75"] integerValue]==2) {
            _statusLabel.text = [NSString stringWithFormat:@"(审核中)",nil];
        }else if ([userinfodict[@"b112"][@"b75"] integerValue]==3) {
            _statusLabel.text = [NSString stringWithFormat:@"(审核不通过)",nil];
        }
        _statusLabel.font = [UIFont systemFontOfSize:13];
        [view2 addSubview:_statusLabel];
        
        _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-got(150/2), CGRectGetMaxY(_statusLabel.frame)+5, got(150), got(20))];
    }
    
    
    
    // ID
    
    _IDLabel.textColor = HexRGB(0Xffffff);
    _IDLabel.textAlignment=NSTextAlignmentCenter;
    _IDLabel.text = [NSString stringWithFormat:@"账号 : %@",[NSString stringWithFormat:@"%@",[NSGetTools getUserAccount]]];
    _IDLabel.font = [UIFont systemFontOfSize:13];
    [view2 addSubview:_IDLabel];
#pragma mark ------- 个人资料
    UIButton *personBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-got(80/2), CGRectGetMaxY(_IDLabel.frame)+5, got(80), got(20))];
    [personBtn setImage:[UIImage imageNamed:@"btn-home-page-n.png"] forState:UIControlStateNormal];
    [personBtn setTitle:@" 个人主页" forState:(UIControlStateNormal)];
    personBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [personBtn addTarget:self action:@selector(personAction) forControlEvents:(UIControlEventTouchUpInside)];
    [view2 addSubview:personBtn];
    
    
    UIView *buttonBgV=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view2.frame)-got(40), ScreenWidth, got(40))];
    buttonBgV.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.500];
    [view2 addSubview:buttonBgV];
    // 我关注的
    UIButton *myCareLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(20), got(5), got(80), got(30))];

    [myCareLabel setTitle:@"我触动的" forState:(UIControlStateNormal)];
    myCareLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [myCareLabel setTitleColor:HexRGB(0Xffffff) forState:(UIControlStateNormal)];
    [myCareLabel addTarget:self action:@selector(myCareLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [buttonBgV addSubview:myCareLabel];
    
    // 关注我的
    UIButton *careMeLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(120), got(5), got(80), got(30))];
    [careMeLabel setTitle:@"触动我的" forState:(UIControlStateNormal)];
    careMeLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [careMeLabel setTitleColor:HexRGB(0Xffffff) forState:(UIControlStateNormal)];
    [careMeLabel addTarget:self action:@selector(careMeLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [buttonBgV addSubview:careMeLabel];
    
    // 最近访客
    UIButton *lookMeLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(220), got(5), got(80), got(30))];
    [lookMeLabel setTitle:@"看过我的" forState:(UIControlStateNormal)];
    lookMeLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [lookMeLabel setTitleColor:HexRGB(0Xffffff) forState:(UIControlStateNormal)];
    [lookMeLabel addTarget:self action:@selector(lookMeLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [buttonBgV addSubview:lookMeLabel];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(got(110), got(5), 1,got(30))];
    lineLabel2.backgroundColor = HexRGB(0X9ea4b6);
    [buttonBgV addSubview:lineLabel2];

    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(got(210), got(5), 1,got(30))];
    lineLabel3.backgroundColor = HexRGB(0X9ea4b6);
    [buttonBgV addSubview:lineLabel3];
    
    self.tableView.tableHeaderView = view2;
    [self.tableView reloadData];
    
}

#pragma mark --- button
- (void)myCareLabelAction {
    
    MeTouchController *mec = [[MeTouchController alloc] init];
    mec.title = @"我触动的";
    [self.navigationController pushViewController:mec animated:YES];
}

#pragma mark -- 区分会员
- (void)careMeLabelAction {
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
//    NSString *isvip = [[dict objectForKey:@"b112"] objectForKey:@"b144"];
//    NSString *name = [[dict objectForKey:@"b112"] objectForKey:@"b52"];
//    BOOL vip = [isvip integerValue] == 1?YES:NO;
#warning 此处为vip， --by大海2016年06月16日15:40:31
//    if (!vip) {   // 会员
//        TouchMeController *touch = [[TouchMeController alloc] init];
//        touch.title = @"触动我的";
//        [self.navigationController pushViewController:touch animated:YES];
//    }else {
//            // 不是会员
//            NoVipController *vip = [[NoVipController alloc] init];
//            vip.title = @"触动我的";
//            vip.nametitle = name;
//            [self.navigationController pushViewController:vip animated:YES];
//            
//            
////        }
//        
//    }
    TouchMeController *touch = [[TouchMeController alloc] init];
    touch.title = @"触动我的";
    [self.navigationController pushViewController:touch animated:YES];
}

- (void)lookMeLabelAction {
    
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
//    NSString *isvip = [[dict objectForKey:@"b112"] objectForKey:@"b144"];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    NSString *name = userInfo.b52;
    NSString *isvip = userInfo.b144;
//    [[dict objectForKey:@"b112"] objectForKey:@"b52"];
    BOOL vip = [isvip integerValue] == 1?YES:NO;
    //    BOOL vip = YES;
    if (vip) {  // 会员
        SeenMeController *seen = [[SeenMeController alloc] init];
        seen.title = @"看过我的";
        [self.navigationController pushViewController:seen animated:YES];
    }else {

            // 不是会员
            SeenMeVipController *vip = [[SeenMeVipController alloc] init];
            vip.title = @"看过我的";
            vip.nametitle = name;
            [self.navigationController pushViewController:vip animated:YES];
            
//        }
        
    }
}

- (void)personAction {

    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];//ID
    Homepage *home = [[Homepage alloc] init];
    home.touchP2 = userId;
    home.item = _userinfo;
    home.fromMyPage = YES;
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:home];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        backImageView.frame=CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, self.view.frame.size.width+ (-scrollView.contentOffset.y) * 2, got(270) - scrollView.contentOffset.y);
        
    }else if(scrollView.contentOffset.y<got(270) && scrollView.contentOffset.y>=0){
        backImageView.frame=CGRectMake(0, 0, ScreenWidth, got(270));
//        self.alphaNum=(scrollView.contentOffset.y)/gotHeight(270)-0.1;
//        [self.nav setAlph:self.alphaNum];
    }else{
        backImageView.frame=CGRectMake(0, 0, ScreenWidth, got(270));
//        self.alphaNum=1.0;
//        [self.nav setAlph:self.alphaNum];
    }
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
