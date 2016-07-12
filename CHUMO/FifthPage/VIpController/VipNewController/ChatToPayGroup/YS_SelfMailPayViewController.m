//
//  YS_SelfMailPayViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_SelfMailPayViewController.h"
#import "DHAlertView.h"
#import "JYPayWorking.h"
#import "YS_PayInfoModel.h"
#import "WXSubmitTableViewCell.h"
#import "WXPayCell.h"
#import "YS_PayInfoTableViewCell.h"
#import "NPServiceViewController.h"
#import "UIImageView+Tool.h"
#import "PrivilegeTableViewCell.h"
#import "ShowVipController.h"

#define TYPECELL @"typeCELL"
#define PAYINFOCELL @"PayInfoCELL"
#define BUTTONCELL @"ButtonCELL"
#define PRIVILEGECELL @"PRIVILEGECELL"

@interface YS_SelfMailPayViewController ()<DHAlertViewDelegate,JYPayWorkingDelegate,UITableViewDelegate,UITableViewDataSource,PrivilegeTableViewCellDelegate>
{
    NSInteger payInteger;
    NSIndexPath *payInfoIndexPath;
    NSIndexPath *payTypeIndexPath;
}
@property (atomic,assign)NSInteger requestNum;
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,strong)UITableView *payTableView;
@property (nonatomic,strong)NSMutableArray *goodInfoArr;
@property (nonatomic,strong)NSMutableArray *payTypeArr;
@property (nonatomic,strong)NSMutableArray *privilegeArr;
@property (nonatomic,strong)NSMutableArray *goodActionArr;
@property (nonatomic,assign)BOOL ishaveArction;

@end

@implementation YS_SelfMailPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ishaveArction=NO;
    self.navigationController.navigationBar.barTintColor = MainBarBackGroundColor;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.title=@"VIP会员";
    self.view.backgroundColor=kUIColorFromRGB(0xf0ebeb);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等..."];
    });
    //参数
    self.goodInfoArr = [NSMutableArray new];
    self.goodActionArr = [NSMutableArray new];
    self.payTypeArr = [NSMutableArray new];
    self.privilegeArr = [NSMutableArray new];
    self.requestNum=0;
    //默认选中第一个
    payInfoIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];//购买项目
    
    
    //支付类
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    
    //请求
    [self getDataArr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
- (void)backAction{
    [Mynotification postNotificationName:@"getUserInfosWhenUpdate" object:nil];
    [Mynotification postNotificationName:@"extractVipWhenPay" object:nil];
    
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)layoutTableView{
    self.payTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:(UITableViewStyleGrouped)];
    self.payTableView.backgroundColor=kUIColorFromRGB(0xffffff);
    self.payTableView.delegate=self;
    self.payTableView.dataSource=self;
    self.payTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.payTableView registerClass:[WXPayCell class] forCellReuseIdentifier:TYPECELL];
    [self.payTableView registerClass:[YS_PayInfoTableViewCell class] forCellReuseIdentifier:PAYINFOCELL];
    [self.payTableView registerClass:[WXSubmitTableViewCell class] forCellReuseIdentifier:BUTTONCELL];
    [self.payTableView registerClass:[PrivilegeTableViewCell class] forCellReuseIdentifier:PRIVILEGECELL];
    
    [self.payTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    [self.view addSubview:self.payTableView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 请求数据
//请求购买项目
- (void)getDataArr{
    
    //请求购买项目
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appinfoStr = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service?p1=%@&p2=%@&a78=%@&a13=%@&%@",kServerAddressTest2,p1,p2,_payComboType,_payMainCode,appinfoStr];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block YS_SelfMailPayViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            if ([(NSArray *)infoDic[@"body"] count]>0) {
                NSArray *infoArr = infoDic[@"body"][0][@"b111"];
                
                for (NSDictionary *dict in infoArr) {
                    YS_PayInfoModel *model=[[YS_PayInfoModel alloc]init];
                    model.b13=dict[@"b13"];
                    model.b34=dict[@"b34"];
                    model.b51=dict[@"b51"];
                    model.b126=dict[@"b126"];
                    model.b133=dict[@"b133"];
                    model.b137=dict[@"b137"];
                    model.b128=dict[@"b128"];
                    model.b48=dict[@"b48"];
                    model.b193=dict[@"b193"];
                    if (dict[@"b138"]!=nil) {
                        model.b138=dict[@"b138"];
                    }
                    if (MyJudgeNull(model.b193)) {
                        [payVC.goodInfoArr addObject:model];
                    }else{
                        [payVC.goodActionArr addObject:model];
                    }
                    if (payVC.goodInfoArr.count>0 && payVC.goodActionArr.count>0) {
                        payTypeIndexPath=[NSIndexPath indexPathForRow:0 inSection:2];//支付方式
                    }else{
                        payTypeIndexPath=[NSIndexPath indexPathForRow:0 inSection:1];//支付方式
                    }
                    
                    
                }
                
                payVC.requestNum++;
                if (payVC.requestNum>=3) {
                    //tableview
                    payVC.requestNum=0;
                    [payVC layoutTableView];
                    [payVC hideHud];
                    [payVC.payTableView reloadData];
                }
            }
            
            
            
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    /**
     *  请求支付方式
     */
    
    NSString *urltype = [NSString stringWithFormat:@"%@f_125_12_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,p2,p1,appinfoStr];
    urltype = [urltype stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:urltype parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            if (infoDic[@"body"]!=nil) {
                NSString *infoStr = infoDic[@"body"];
                payVC.payTypeArr = [infoStr componentsSeparatedByString:@","].mutableCopy;
                if (_payTypeArr.count>0) {
                    payInteger=[_payTypeArr[0] integerValue];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setInteger:payInteger forKey:@"payInteger"];
                    [userDefaults synchronize];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    payVC.requestNum++;
                    if (payVC.requestNum>=3) {
                        //tableview
                        payVC.requestNum=0;
                        [payVC layoutTableView];
                        [payVC hideHud];
                        [payVC.payTableView reloadData];
                    }
                    
                });
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
    
    /**
     *  请求特权
     */
    NSString *privilegeurl = [NSString stringWithFormat:@"%@f_115_14_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    privilegeurl = [privilegeurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:privilegeurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            if ([(NSArray *)infoDic[@"body"] count]>0) {
                NSMutableArray *vipArr = infoDic[@"body"];//特权信息
                NSMutableArray *privilegeVip=[NSMutableArray array];
                for (NSDictionary *dict in vipArr) {
                    if ([[dict objectForKey:@"b149"] integerValue]==3) {//去除写信包月
                        continue;
                    }else{
                        [privilegeVip addObject:dict];
                    }
                    
                }
                
                for (int i=0; i<privilegeVip.count; i++) {
                    NSMutableArray *pArr=[NSMutableArray new];
                    [pArr addObject:privilegeVip[i]];
                    i++;
                    if (i<privilegeVip.count) {
                        [pArr addObject:privilegeVip[i]];
                    }
                    [payVC.privilegeArr addObject:pArr];
                }
                
                payVC.requestNum++;
                if (payVC.requestNum>=3) {
                    //tableview
                    payVC.requestNum=0;
                    [payVC layoutTableView];
                    [payVC hideHud];
                    [payVC.payTableView reloadData];
                }
                
            }
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.payComboType integerValue] ==2) {//单买
        if (self.goodActionArr.count>0) {
            if (self.goodInfoArr.count>0) {
                return 4;
            }else{
                return 3;
            }
        }else{
            return 3;
        }
        
    }else{//套餐
        return 4;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.payComboType integerValue] ==2) {
        //单买
        //套餐一定会陪,但是有活动用,有普通
        if (self.goodActionArr.count>0) {
            if (self.goodInfoArr.count>0) {
                if (section==0) {
                    return self.goodActionArr.count;
                }else if (section==1) {
                    return self.goodInfoArr.count;
                }else if(section==2){
                    return self.payTypeArr.count;
                }else if(section==3){
                    return 1;
                }else{
                    if ([self.payComboType integerValue] ==2) {
                        return 0;
                    }else{
                        return self.privilegeArr.count;
                    }
                }
            }else{
                if (section==0) {
                    return self.goodActionArr.count;
                }else if(section==1){
                    return self.payTypeArr.count;
                }else if(section==2){
                    return 1;
                }else{
                    if ([self.payComboType integerValue] ==2) {
                        return 0;
                    }else{
                        return self.privilegeArr.count;
                    }
                }
            }
            
        }else{
            if (section==0) {
                return self.goodInfoArr.count;
            }else if(section==1){
                return self.payTypeArr.count;
            }else if(section==2){
                return 1;
            }else{
                if ([self.payComboType integerValue] ==2) {
                    return 0;
                }else{
                    return self.privilegeArr.count;
                }
            }
        }
        
        
    }else{
        if (section==0) {
            return self.goodInfoArr.count;
        }else if(section==1){
            return self.payTypeArr.count;
        }else if(section==2){
            return 1;
        }else{
            if ([self.payComboType integerValue] ==2) {
                return 0;
            }else{
                return self.privilegeArr.count;
            }
        }
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.goodActionArr.count>0) {
        
        if (self.goodInfoArr.count>0) {
            if (indexPath.section==0) {
                return [self getPayInfoTableViewCell:tableView cellForRowAtIndexPath:indexPath cellForArray:self.goodActionArr];
            }else if (indexPath.section==1) {
                
                return [self getPayInfoTableViewCell:tableView cellForRowAtIndexPath:indexPath cellForArray:self.goodInfoArr];
                
            }else if(indexPath.section==2){
                
                return [self getPayMethod:tableView cellForRowAtIndexPath:indexPath];
            }else if(indexPath.section==3){
                
                return [self getSubmitButton:tableView cellForRowAtIndexPath:indexPath];
                
            }else{
                return [self getPrivilegeCell:tableView cellForRowAtIndexPath:indexPath];
            }
        }else{
            if (indexPath.section==0) {
                return [self getPayInfoTableViewCell:tableView cellForRowAtIndexPath:indexPath cellForArray:self.goodActionArr];
            }else if(indexPath.section==1){
                
                return [self getPayMethod:tableView cellForRowAtIndexPath:indexPath];
            }else if(indexPath.section==2){
                
                return [self getSubmitButton:tableView cellForRowAtIndexPath:indexPath];
                
            }else{
                return [self getPrivilegeCell:tableView cellForRowAtIndexPath:indexPath];
            }
        }
        
    }else{
        if (indexPath.section==0) {
            
            return [self getPayInfoTableViewCell:tableView cellForRowAtIndexPath:indexPath cellForArray:self.goodInfoArr];
            
        }else if(indexPath.section==1){
            
            return [self getPayMethod:tableView cellForRowAtIndexPath:indexPath];
        }else if(indexPath.section==2){
            
            
            return [self getSubmitButton:tableView cellForRowAtIndexPath:indexPath];
            
        }else{
            return [self getPrivilegeCell:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
}
- (void)getPrivilegecode:(NSInteger)code AndTitle:(NSString *)title{
    ShowVipController *show = [[ShowVipController alloc] init];
    
    NSString *tempUrl=[NSString stringWithFormat:@"%@S3-%ld.html",kServerAddressTestH5,code];
    show.showUrl = tempUrl;
    show.navigationItem.title=title;
    
    [self.navigationController pushViewController:show animated:true];
}
//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.payTableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.goodActionArr.count>0) {
        if (self.goodInfoArr.count>0) {
            if (indexPath.section==0 || indexPath.section==1) {
                [self setSelectInfoIndexpathForRowAtIndexPath:indexPath];
            }else if(indexPath.section==2){
                [self setSelectTypeIndexpathForRowAtIndexPath:indexPath];
            }
        }else{
            if (indexPath.section==0) {
                [self setSelectInfoIndexpathForRowAtIndexPath:indexPath];
            }else if(indexPath.section==1){
                [self setSelectTypeIndexpathForRowAtIndexPath:indexPath];
            }
        }
    }else{
        if (indexPath.section==0) {
            [self setSelectInfoIndexpathForRowAtIndexPath:indexPath];
        }else if(indexPath.section==1){
            [self setSelectTypeIndexpathForRowAtIndexPath:indexPath];
        }
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.goodActionArr.count>0) {
        if (self.goodInfoArr.count>0) {
            if (indexPath.section==3) {
                return 60;
            }else{
                return 50;
            }
        }else{
            if (indexPath.section==2) {
                return 60;
            }else{
                return 50;
            }
        }
    }else{
        if (indexPath.section==2) {
            return 60;
        }else{
            return 50;
        }
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=kUIColorFromRGB(0xffffff);
    
    
    if (self.goodActionArr.count>0) {
        if (self.goodInfoArr.count>0) {
            if (section==0) {
                view.frame=CGRectMake(0, 0, ScreenWidth, 35);
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
                label.text=@"活动套餐";
                label.textColor=kUIColorFromRGB(0x737171);
                label.font=[UIFont systemFontOfSize:12];
                [view addSubview:label];
            }else if(section==1){
                view.frame=CGRectMake(0, 0, ScreenWidth, 35);
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
                label.text=@"超值套餐";
                label.textColor=kUIColorFromRGB(0x737171);
                label.font=[UIFont systemFontOfSize:12];
                [view addSubview:label];
            }else if(section==2){
                view.frame=CGRectMake(0, 0, ScreenWidth, 35);
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
                label.text=@"支付方式";
                label.font=[UIFont systemFontOfSize:12];
                label.textColor=kUIColorFromRGB(0x737171);
                [view addSubview:label];
            }else{
                view.frame=CGRectMake(0, 0, ScreenWidth, 1);
            }
        }else{
            if (section==0) {
                view.frame=CGRectMake(0, 0, ScreenWidth, 35);
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
                label.text=@"活动套餐";
                label.textColor=kUIColorFromRGB(0x737171);
                label.font=[UIFont systemFontOfSize:12];
                [view addSubview:label];
            }else if(section==1){
                view.frame=CGRectMake(0, 0, ScreenWidth, 35);
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
                label.text=@"支付方式";
                label.font=[UIFont systemFontOfSize:12];
                label.textColor=kUIColorFromRGB(0x737171);
                [view addSubview:label];
            }else{
                view.frame=CGRectMake(0, 0, ScreenWidth, 1);
            }
        }
    }else{
        if (section==0) {
            view.frame=CGRectMake(0, 0, ScreenWidth, 35);
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
            label.text=@"超值套餐";
            label.textColor=kUIColorFromRGB(0x737171);
            label.font=[UIFont systemFontOfSize:12];
            [view addSubview:label];
        }else if(section==1){
            view.frame=CGRectMake(0, 0, ScreenWidth, 35);
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, ScreenWidth, 24)];
            label.text=@"支付方式";
            label.font=[UIFont systemFontOfSize:12];
            label.textColor=kUIColorFromRGB(0x737171);
            [view addSubview:label];
        }else {
            view.frame=CGRectMake(0, 0, ScreenWidth, 1);
        }
    }
    

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.goodActionArr.count>0) {
        if (self.goodInfoArr.count>0) {
            if (section==0) {
                return 35;
            }else if(section==1){
                return 35;
            }else if(section==2){
                return 35;
            }else{
                return 1;
            }
        }else{
            if (section==0) {
                return 35;
            }else if(section==1){
                return 35;
            }else{
                return 1;
            }
        }
    }else{
        if (section==0) {
            return 35;
        }else if(section==1){
            return 35;
        }else {
            return 1;
        }
    }
    
//    if (section==0) {
//        return 35;
//    }else if(section==1){
//        return 35;
//    }else if(section==2){
//        return 1;
//    }else {
//        if ([self.payComboType integerValue] ==2) {
//            return 1;
//        }else{
//            return 45;
//        }
//    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==3) {
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        UIView *footV=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(view.bounds)-100, CGRectGetHeight(view.bounds)-25, 200, 20)];
        
        UILabel *textL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footV.bounds)-60, 20)];
        textL.text=@"支付代表你已经阅读并同意触陌";
        textL.font=[UIFont systemFontOfSize:10];
        textL.textColor=[UIColor colorWithWhite:0.600 alpha:1.000];
        [footV addSubview:textL];
        UIButton *goBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame), 0, 60, 20)];
        [goBut setTitle:@"服务条款" forState:(UIControlStateNormal)];
        goBut.titleLabel.font=[UIFont systemFontOfSize:10];
        [goBut setTitleColor:[UIColor colorWithRed:0.329 green:0.467 blue:0.910 alpha:1.000] forState:(UIControlStateNormal)];
        [goBut addTarget:self action:@selector(gotoServiceAction) forControlEvents:(UIControlEventTouchUpInside)];
        [footV addSubview:goBut];
        footV.backgroundColor=[UIColor clearColor];
        [view addSubview:footV];
        view.backgroundColor=kUIColorFromRGB(0xffffff);
        return view;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        view.backgroundColor=kUIColorFromRGB(0xffffff);
        return view;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3) {
        return 25;
    }else{
        return 1;
    }
    
}
- (void)gotoServiceAction{
    NPServiceViewController *temp = [[NPServiceViewController alloc] init];
    temp.urlWeb = [NSString stringWithFormat:@"%@p0.html",kServerAddressTestH5,nil]; ;
    [self.navigationController pushViewController:temp animated:true];
}
#pragma mark -- 支付按钮
- (void)BuyingGoodsAction:(UIButton*)sender{
    
    NSLog(@"一个点击事件");
    
    YS_PayInfoModel *Goodmodel=nil;
    if (self.goodActionArr.count>0) {
        if (self.goodInfoArr.count>0) {
            if (payInfoIndexPath.section==0) {
                Goodmodel = self.goodActionArr[payInfoIndexPath.row];
            }else{
                Goodmodel = self.goodInfoArr[payInfoIndexPath.row];
            }
        }else{
            Goodmodel = self.goodActionArr[payInfoIndexPath.row];
        }
    }else{
        Goodmodel = self.goodInfoArr[payInfoIndexPath.row];
    }
    
    NSString *GoodCode=Goodmodel.b13.description;
    payRequsestFlag payflag=(payRequsestFlagZFB|payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
    if ((payflag & payInteger)) {
        if (payInteger ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
            [self alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
            [self.HUD hide:YES];
            return;
        }
        
        [self payAgainAction:payInteger GoodId:GoodCode];
    }
    
}
#pragma mark 支付
#pragma mark --- 下单
//订单支付
- (void) payAgainAction:(NSInteger)payRequsestFlag GoodId:(NSString *)GoodId {
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)payRequsestFlag];
    
    [self.payWorking PaydataRuquesByGoodId:GoodId payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:GoodId forKey:@"dh_goodId"];
            [wxpayDic setObject:payNum forKey:@"dh_payType"];
            if (payRequsestFlag==payRequsestFlagZFB) {
                [MobClick event:@"zfbPay"]; // 支付宝统计事件
                [self.payWorking sendZFBPay_demo:wxpayDic];
            }else if (payRequsestFlag==payRequsestFlagWX) {
                [MobClick event:@"wxPay"]; // 微信统计事件
                [self.payWorking sendPay_demo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagZF){
                [MobClick event:@"alPay"]; // 现在-支付宝统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagNG){
                [MobClick event:@"ngPay"]; // 内购统计事件
                [self.payWorking getProductInfo:GoodId info:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagYL){
                [MobClick event:@"ylPay"]; // 现在-银联统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBZF){
                [MobClick event:@"HFBalPay"]; // 汇付宝-支付宝统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBYL){
                [MobClick event:@"HFBylPay"]; // 汇付宝-银联统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBWX){
                [MobClick event:@"HFBwxPay"]; // 汇付宝-微信统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }
        }
    }];
}
#pragma mark 弹窗

//通知
- (void)payAction:(NSNotification *)sender {
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    
    if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
        // 长度为11位，第二位不为0，为已经绑定手机
        NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
        if ([userName length] == 11 && [secNumber integerValue] != 0) {
            [self alertViewOfTitle:@"温馨提示" msg:@"支付成功"];
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
-(void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger)index{
    if (index == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NResetController *reset = [[NResetController alloc] init];
        reset.title = @"绑定手机号";
        reset.msgType = @"3";
        [self.navigationController pushViewController:reset animated:true];
    }
}
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"extractVipWhenPay" object:nil];
        [self payAction:nil];
    }else{
        [self alertViewOfTitle:@"提示" msg:msg];
    }
}
- (void)p_setupProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD = [[MBProgressHUD alloc]initWithView: self.view];
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
        
        [self.view addSubview:_HUD];
        [_HUD show:YES];
    });
    
}
#pragma mark 获取cell
/**
 *  获取活动支付项目
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (YS_PayInfoTableViewCell *)getActionPayInfoTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YS_PayInfoModel *model=self.goodInfoArr[indexPath.row];
    
    //支付明细
    YS_PayInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PAYINFOCELL];
    if (!cell) {
        cell = [[YS_PayInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:PAYINFOCELL];
    }
    NSString *giftStr=nil;
    if (model.b138 !=nil) {
        giftStr=[NSString stringWithFormat:@"赠送%@个月",model.b138];
    }
    if (payInfoIndexPath.row==indexPath.row && payInfoIndexPath.section==indexPath.section) {
        [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]] ButImage:@"choice-click" giveaway:giftStr giveMoney:model.b193];
    }else{
        
        [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]]  ButImage:@"Choice-normal" giveaway:giftStr giveMoney:model.b193];
    }
    
    return cell;
}
/**
 *  获取普通支付项目
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (YS_PayInfoTableViewCell *)getPayInfoTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellForArray:(NSArray*)DateArray{
    YS_PayInfoModel *model=DateArray[indexPath.row];
    
    //支付明细
    YS_PayInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PAYINFOCELL];
    if (!cell) {
        cell = [[YS_PayInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:PAYINFOCELL];
    }
    NSString *giftStr=nil;
    if (model.b138 !=nil) {
        giftStr=[NSString stringWithFormat:@"赠送%@个月",model.b138];
    }
    if (payInfoIndexPath.row==indexPath.row &&payInfoIndexPath.section==indexPath.section) {
        [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]] ButImage:@"choice-click" giveaway:giftStr giveMoney:model.b193];
    }else{
        
        [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]]  ButImage:@"Choice-normal" giveaway:giftStr giveMoney:model.b193];
    }
    
    return cell;
}
/**
 *  支付方式
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (WXPayCell *)getPayMethod:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //支付方式
    WXPayCell *cell = [tableView dequeueReusableCellWithIdentifier:TYPECELL];
    if (!cell) {
        cell = [[WXPayCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:TYPECELL];
    }
    switch ([self.payTypeArr[indexPath.row] integerValue]) {
        case payRequsestFlagNG:
        {
            [cell setPayImage:@"icon-applePay" payLabel:@"Apple账号支付" payFlag:(payRequsestFlagNG)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagZF:
        {
            [cell setPayImage:@"icon-zhifubao" payLabel:@"支付宝支付" payFlag:(payRequsestFlagZF)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagWX:
        {
            [cell setPayImage:@"wxImage" payLabel:@"微信支付" payFlag:(payRequsestFlagWX)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagYL:
        {
            [cell setPayImage:@"icon-yinlian" payLabel:@"银联" payFlag:(payRequsestFlagYL)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagHFBYL:
        {
            [cell setPayImage:@"icon-yinlian" payLabel:@"汇付宝银联" payFlag:(payRequsestFlagHFBYL)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagHFBWX:
        {
            [cell setPayImage:@"wxImage" payLabel:@"汇付宝微信支付" payFlag:(payRequsestFlagHFBWX)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagHFBZF:
        {
            [cell setPayImage:@"icon-zhifubao" payLabel:@"汇付宝支付宝支付" payFlag:(payRequsestFlagHFBZF)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
            
        }
            break;
        case payRequsestFlagZFB:
        {
            [cell setPayImage:@"icon-zhifubao" payLabel:@"支付宝支付" payFlag:(payRequsestFlagZFB)];
            [cell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
        }
            break;
        default:
            break;
    }
    if (cell.payFlag==payInteger) {
        [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
    }
    
    return cell;
}
/**
 *  支付按钮
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (WXSubmitTableViewCell *)getSubmitButton:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YS_PayInfoModel *model=nil;
    if (self.goodActionArr.count>0) {
        if (payInfoIndexPath.section==0) {
            model=self.goodActionArr[payInfoIndexPath.row];
        }else{
            model= self.goodInfoArr[payInfoIndexPath.row];
        }

    }else{
        model= self.goodInfoArr[payInfoIndexPath.row];
    }
    
    WXSubmitTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BUTTONCELL];
    
    if (!cell) {
        cell = [[WXSubmitTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:BUTTONCELL];
    }
    [cell.details setTitle:[NSString stringWithFormat:@"确认支付%.1f元",[model.b126 integerValue]*[model.b128 integerValue]*0.1] forState:(UIControlStateNormal)];
    [cell.details addTarget:self action:@selector(BuyingGoodsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.backgroundColor=kUIColorFromRGB(0xffffff);
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    return cell;
}

/**
 *  特权
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (PrivilegeTableViewCell *)getPrivilegeCell:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *model=self.privilegeArr[indexPath.row];
    PrivilegeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PRIVILEGECELL];
    cell.delegate=self;
    if (!cell) {
        cell = [[PrivilegeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:PRIVILEGECELL];
    }
    [cell setPrivilegeInfoByModel:model];
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    return cell;
}
/**
 *  记录,选中购买项目
 *
 *  @param indexPath
 */
- (void)setSelectInfoIndexpathForRowAtIndexPath:(NSIndexPath *)indexPath{
    YS_PayInfoTableViewCell *cell = (YS_PayInfoTableViewCell *)[self.payTableView cellForRowAtIndexPath:indexPath];
    cell.ButtonImage.image = [UIImage imageNamed:@"choice-click"];
    if (indexPath.row!=payInfoIndexPath.row || payInfoIndexPath.section!=indexPath.section) {
        YS_PayInfoTableViewCell *oldcell = (YS_PayInfoTableViewCell *)[self.payTableView cellForRowAtIndexPath:payInfoIndexPath];
        oldcell.ButtonImage.image = [UIImage imageNamed:@"Choice-normal"];
        //记录选中cell
        payInfoIndexPath=indexPath;
    }
    [self.payTableView reloadData];
}
/**
 *  记录,选中的支付方式
 *
 *  @param indexPath
 */
- (void)setSelectTypeIndexpathForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXPayCell *cell = (WXPayCell *)[self.payTableView cellForRowAtIndexPath:indexPath];
    [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
    if (indexPath.row!=payTypeIndexPath.row ) {
        WXPayCell *oldcell = (WXPayCell *)[self.payTableView cellForRowAtIndexPath:payTypeIndexPath];
        [oldcell.payDot setImage:[UIImage imageNamed:@"Choice-normal"] forState:(UIControlStateNormal)];
        //记录选中cell
        payTypeIndexPath=indexPath;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    payInteger=cell.payFlag;
    [userDefaults setInteger:payInteger forKey:@"payInteger"];
    [userDefaults synchronize];
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
