//
//  YS_VipCenterViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/3.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_VipCenterViewController.h"
#import "RefreshController.h"
#import "MonthlyViewController.h"
#import "YS_ApplePayVipViewController.h"
#import "TempHFController.h"
#import "YS_UserVipOrderCell.h"
#import "YS_UserVipInfoCell.h"
#import "YS_SelfPayViewController.h"
#import "YS_OrderListViewController.h"
#import "YS_SelfMailPayViewController.h"

#define VIPINFOCELL @"VipInfoCELL"
#define DetailCell @"DetailCELL"
#define ORDERCELL @"orderCELL"

@interface YS_VipCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *sex;
    CGFloat headHeight;
    NSString *orderNum;
}
@property (nonatomic,strong)UITableView *VipTableView;
@property (nonatomic,strong)NSMutableDictionary *userInfoDict;
@property (nonatomic,strong)NSMutableArray *UserVipDict;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation YS_VipCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    [self getOrderNumber];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"VIP会员";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    
    NSString *sexNum = userInfo.b69;
    if ([sexNum integerValue] == 1) { // 1男2女
        sex = @"1";
    }else {
        sex = @"2";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"加载中...."];
    });
    [self Userinformation];
//    [self extractVip];
    [self setUpTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
- (void)setUpTableView{
    self.VipTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight-64) style:(UITableViewStyleGrouped)];
    self.VipTableView.delegate=self;
    self.VipTableView.dataSource=self;
    self.VipTableView.backgroundColor=kUIColorFromRGB(0xffffff);
    [self.VipTableView registerNib:[UINib nibWithNibName:@"YS_UserVipOrderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ORDERCELL];
    [self.VipTableView registerNib:[UINib nibWithNibName:@"YS_UserVipInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VIPINFOCELL];
    [self.view addSubview:_VipTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 请求

#pragma mark ----- 完成
- (void)Userinformation {  // 用户信息 （完成）
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];//ID
    
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:p2];
    if (!userInfo) {
        [HttpOperation asyncGetUserInfoWithUserId:p2 queue:dispatch_get_main_queue() completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
            
        }];
        NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
        NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        __weak YS_VipCenterViewController *userVC=self;
        [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *datas = responseObject;
            
            NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
            NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
            NSNumber *codeNum = infoDic[@"code"];
            if ([codeNum intValue] == 200) {
                NSDictionary *dict2 = infoDic[@"body"];
                for (NSString *key in dict2) {
                    if ([key isEqualToString:@"b112"]) {
                        [userVC setValue:dict2[@"b112"] forKey:@"userInfoDict"];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                    [self.VipTableView reloadData];
                });
                [self extractVip];
            }else if([infoDic[@"code"] integerValue] == 500){
                if (self.isnetWroking) {
                    RefreshController *refre = [[RefreshController alloc] init];
                    [self presentViewController:refre animated:YES completion:nil];
                }else{
                    [self showHint:@"没有网络,还怎么浪~~"];
                }
//                RefreshController *refre = [[RefreshController alloc] init];
//                [self presentViewController:refre animated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        NSLog(@"系统参数请求失败--%@-",error);
            //        RefreshController *refre = [[RefreshController alloc] init];
            //        [self presentViewController:refre animated:YES completion:nil];
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self.VipTableView reloadData];
        });
        
        [self extractVip];
    }
    
    
}
- (void)extractVip { // 提取系统VIP信息  p1 p2 a78--> type分类     a13 code-->编码
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_18_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __weak YS_VipCenterViewController *VIpVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *vipdict = infoDic[@"body"];
            for (NSString *key in vipdict) {
                if ([key isEqualToString:@"b140"]) {
                    NSArray *arr=vipdict[@"b140"];
                    [VIpVC setValue:arr forKey:@"UserVipDict"];
                    if ([arr count]>1) {
                        [VIpVC setValue:[NSNumber numberWithFloat:([arr count]-1)*18]forKey:@"headHeight"];
                    }
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [VIpVC.VipTableView reloadData];
                
            });
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
//请求历史订单数量
- (void) getOrderNumber{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_125_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak YS_VipCenterViewController *vipVc=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas= responseObject;
        NSString *result=[[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr=[NSGetTools DecryptWith:result];//解密
        NSDictionary *infoDic=[NSGetTools parseJSONStringToNSDictionary:jsonStr];
        
        NSNumber *codeNum=infoDic[@"code"];
        
        if ([codeNum integerValue]==200) {
            NSDictionary *dict=infoDic[@"body"];
            [vipVc setValue:dict[@"b15"] forKey:@"orderNum"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [vipVc.VipTableView reloadData];
            });
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
#pragma mark tableview 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        if ([sex isEqualToString:@"1"]) {
            return 2;
        }else{
            return 1;
        }
        
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        return 60+headHeight;
    }else{
        return 50;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *detailcell=nil;
    if (indexPath.section==0) {
        YS_UserVipInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:VIPINFOCELL forIndexPath:indexPath];
        NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];//ID
        
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:p2];
        if (!userInfo) {
            [HttpOperation asyncGetUserInfoWithUserId:p2 queue:dispatch_get_main_queue() completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
                [cell setCellWithUserInfo:userInfoModel ByVipDictionary:_UserVipDict];
            }];
        }else{
            [cell setCellWithUserInfo:userInfo ByVipDictionary:_UserVipDict];
        }
        
//        [cell setCellByDictionary:_userInfoDict ByVipDictionary:_UserVipDict];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        detailcell=cell;
    }else if (indexPath.section==1) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:DetailCell];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:DetailCell];
        }
        if (indexPath.row==0) {
            
            if ([sex isEqualToString:@"1"]) {
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
      
                cell.imageView.image=[UIImage imageNamed:@"letter"];
                
                cell.textLabel.text=[goodDict objectForKey:@"b51"];
                cell.textLabel.font=[UIFont systemFontOfSize:15];
                cell.textLabel.textColor=kUIColorFromRGB(0x323232);
                
                cell.detailTextLabel.text=[goodDict objectForKey:@"b48"];
                cell.detailTextLabel.textColor=kUIColorFromRGB(0x737171);
                cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else{
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
                cell.imageView.image=[UIImage imageNamed:@"vip"];
                
                cell.textLabel.text=[goodDict objectForKey:@"b51"];
                cell.textLabel.font=[UIFont systemFontOfSize:15];
                cell.textLabel.textColor=kUIColorFromRGB(0x323232);
                
                cell.detailTextLabel.text=[goodDict objectForKey:@"b48"];
                cell.detailTextLabel.textColor=kUIColorFromRGB(0x737171);
                cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }else if(indexPath.row==1){
            NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
            cell.imageView.image=[UIImage imageNamed:@"vip"];
            
            cell.textLabel.text=[goodDict objectForKey:@"b51"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=kUIColorFromRGB(0x323232);
            
            cell.detailTextLabel.text=[goodDict objectForKey:@"b48"];
            cell.detailTextLabel.textColor=kUIColorFromRGB(0x737171);
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        detailcell=cell;
    }else{
        YS_UserVipOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ORDERCELL forIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if ( nil == orderNum || [orderNum integerValue]==0) {
            cell.detailLabel.text=@"查看全部订单";
        }else{
            cell.detailLabel.textColor=kUIColorFromRGB(0xe62739);
            cell.detailLabel.text=[NSString stringWithFormat:@"您有%@条待支付订单!",orderNum,nil];
        }
        
        detailcell=cell;
    }
    
    return detailcell;
}
//分区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    if (section==0) {
        view.frame=CGRectMake(0, 0, ScreenWidth, 130);
        view.layer.contents=(id)[UIImage imageNamed:@"banner_activity"].CGImage;
        view.layer.contentsScale=[[UIScreen mainScreen]scale];
    }else{
        view.frame=CGRectMake(0, 0, ScreenWidth, 10);
        view.backgroundColor=[UIColor clearColor];
    }
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openTapAction:)];
    [view addGestureRecognizer:openTap];
    view.userInteractionEnabled = YES;
    return view;
}
/**
 *  去活动详情
 *
 *  @param sender 
 */
- (void)openTapAction:(UITapGestureRecognizer *)sender{
    
    if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]) {
        //请求官方支付账号
        NSString *officialID = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
        if (officialID==nil) {
#pragma mark 商店版
            MonthlyViewController *moVC=[[MonthlyViewController alloc]init];
            UINavigationController *moenthnc=[[UINavigationController alloc]initWithRootViewController:moVC];
            [self presentViewController:moenthnc animated:YES completion:nil];
            //                    [self.navigationController pushViewController:moVC animated:YES];
        }else{
            YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
            NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
            
            temp.payMainCode=[goodDict objectForKey:@"b13"];
            temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
            //        temp.payMainCode=@"1005";
            //        temp.payComboType=@"2";//单买
            temp.navigationItem.title=@"写信包月服务";
            UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
            [self presentViewController:tempnc animated:YES completion:nil];
        }

    }else{
#pragma mark 企业版
        
        YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
        
        temp.payMainCode=[goodDict objectForKey:@"b13"];
        temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
        //        temp.payMainCode=@"1005";
        //        temp.payComboType=@"2";//单买
        temp.navigationItem.title=@"写信包月服务";
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
//        YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
//        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
//        
//        temp.payMainCode=[goodDict objectForKey:@"b13"];
//        temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
////        temp.payMainCode=@"1005";
////        temp.payComboType=@"2";//单买
//        temp.navigationItem.title=@"写信包月服务";
//        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
//        [self presentViewController:tempnc animated:YES completion:nil];
////                            [self.navigationController pushViewController:temp animated:YES];
    }

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 130;
    }else{
        return 10;
    }
   
}
//分区尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return;
    }else if(indexPath.section==1){
        if ([sex isEqualToString:@"1"]) {//男生
            if (indexPath.row==0) {

                if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]) {
                    #pragma mark 商店版
                    MonthlyViewController *moVC=[[MonthlyViewController alloc]init];
                    UINavigationController *moenthnc=[[UINavigationController alloc]initWithRootViewController:moVC];
                    [self presentViewController:moenthnc animated:YES completion:nil];
//                    [self.navigationController pushViewController:moVC animated:YES];
                }else{
#pragma mark 企业版
                    YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
                    NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
                    
                    temp.payMainCode=[goodDict objectForKey:@"b13"];
                    temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//                    temp.payMainCode=@"1005";
//                    temp.payComboType=@"2";//单买
                    temp.navigationItem.title=@"写信包月服务";
                    UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                    [self presentViewController:tempnc animated:YES completion:nil];
//                    [self.navigationController pushViewController:temp animated:YES];
                }
                

            }else{
                if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
                    YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
                    UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                    [self presentViewController:tempnc animated:YES completion:nil];
//                    [self.navigationController pushViewController:temp animated:YES];
                }else {
#pragma mark 企业版
                    YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
                    NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
                    
                    temp.payMainCode=[goodDict objectForKey:@"b13"];
                    temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//                    temp.payMainCode=@"1006";
//                    temp.payComboType=@"1";//套餐
                    temp.navigationItem.title=@"开通VIP会员";
                    UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                    [self presentViewController:tempnc animated:YES completion:nil];
//                    [self.navigationController pushViewController:temp animated:YES];
                }
            }
            
        }else{//女生
            if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
            #pragma mark 商店版
                YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
//                [self.navigationController pushViewController:temp animated:YES];
            }else{
            #pragma mark 企业版
                YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
                
                temp.payMainCode=[goodDict objectForKey:@"b13"];
                temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//                temp.payMainCode=@"1006";
//                temp.payComboType=@"1";//套餐
                temp.navigationItem.title=@"开通VIP会员";
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
//                [self.navigationController pushViewController:temp animated:YES];
            }
        }
    }else if(indexPath.section==2){
//        TempHFController *temp = [[TempHFController alloc] init];
//        temp.urlWeb = [NSString stringWithFormat:@"%@order.html",kServerAddressTestH5,nil];
//        
//        [self.navigationController pushViewController:temp animated:true];
        YS_OrderListViewController *orderlistVC=[[YS_OrderListViewController alloc]init];
        [self.navigationController pushViewController:orderlistVC animated:YES];
    }
}
#pragma mark 实时检测网络
-(void)havingNetworking:(NSNotification *)isNetWorking{
    NSString *sender = isNetWorking.object;
    self.isnetWroking=[sender boolValue];
    
}
@end
