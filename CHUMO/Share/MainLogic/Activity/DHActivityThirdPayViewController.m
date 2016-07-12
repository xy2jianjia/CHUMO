//
//  DHActivityThirdPayViewController.m
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHActivityThirdPayViewController.h"
#import "DHAlertView.h"
#import "JYPayWorking.h"
#import "YS_PayInfoModel.h"
#import "WXSubmitTableViewCell.h"
#import "WXPayCell.h"
#import "YS_PayInfoTableViewCell.h"
#import "NPServiceViewController.h"
#import "UIImageView+Tool.h"

#define TYPECELL @"typeCELL"
#define PAYINFOCELL @"PayInfoCELL"
#define BUTTONCELL @"ButtonCELL"
@interface DHActivityThirdPayViewController ()<DHAlertViewDelegate,JYPayWorkingDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger payInteger;
    NSIndexPath *payInfoIndexPath;
    NSIndexPath *payTypeIndexPath;
}
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,strong)UITableView *payTableView;
//@property (nonatomic,strong)NSMutableArray *goodInfoArr;
@property (nonatomic,strong)NSMutableArray *payTypeArr;
@end

@implementation DHActivityThirdPayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)leftAction{
    [Mynotification postNotificationName:@"getUserInfosWhenUpdate" object:nil];
    [Mynotification postNotificationName:@"extractVipWhenPay" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.title=@"VIP会员";
    self.view.backgroundColor=kUIColorFromRGB(0xf0ebeb);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等..."];
    });
    //参数
//    self.goodInfoArr = [NSMutableArray new];
    self.payTypeArr = [NSMutableArray new];
    
    //默认选中第一个
    payInfoIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];//购买项目
    payTypeIndexPath=[NSIndexPath indexPathForRow:0 inSection:1];//支付方式
    
    //支付类
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    
    
    
    //请求
    [self getDataArr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)layoutTableView{
    self.payTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:(UITableViewStyleGrouped)];
    self.payTableView.backgroundColor=kUIColorFromRGB(0xf0ebeb);
    self.payTableView.delegate=self;
    self.payTableView.dataSource=self;
    self.payTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.payTableView registerClass:[WXPayCell class] forCellReuseIdentifier:TYPECELL];
    [self.payTableView registerClass:[YS_PayInfoTableViewCell class] forCellReuseIdentifier:PAYINFOCELL];
    [self.payTableView registerClass:[WXSubmitTableViewCell class] forCellReuseIdentifier:BUTTONCELL];
    [self.payTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    [self.view addSubview:self.payTableView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 请求数据
//请求支付方式,根据支付方式生成cell
- (void)getPayMethod{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_125_12_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block DHActivityThirdPayViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSString *infoStr = infoDic[@"body"];
            payVC.payTypeArr = [infoStr componentsSeparatedByString:@","].mutableCopy;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_payTypeArr.count>0) {
                    payInteger=[_payTypeArr[0] integerValue];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setInteger:payInteger forKey:@"payInteger"];
                    [userDefaults synchronize];
                }
                
                //tableview
                [payVC layoutTableView];
                [payVC hideHud];
                [payVC.payTableView reloadData];
                
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
//请求购买项目
- (void)getDataArr{
    [self getPayMethod];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.goodInfoArr.count;
    }else if(section==1){
        return self.payTypeArr.count;
    }else{
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        YS_PayModel *model=self.goodInfoArr[indexPath.row];
        
        //支付明细
        YS_PayInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PAYINFOCELL];
        if (!cell) {
            cell = [[YS_PayInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:PAYINFOCELL];
        }
        NSString *giftStr=nil;
        
        if (!MyJudgeNull(model.b48) ) {
            giftStr=[NSString stringWithFormat:@"%@",model.b48];
        }
        if (payInfoIndexPath.row==indexPath.row) {
            
            
            [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]] ButImage:@"choice-click" giveaway:giftStr giveMoney:nil];
        }else{
            
            [cell setPayName:model.b137 PayPrice:[NSString stringWithFormat:@"￥ %ld",[model.b126 integerValue]]  ButImage:@"Choice-normal" giveaway:giftStr giveMoney:nil];
        }
        
        return cell;
        
    }else if(indexPath.section==1){
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
        cell.backgroundColor=kUIColorFromRGB(0xf0ebeb);
        return cell;
    }else {
        
        YS_PayModel *model=self.goodInfoArr[payInfoIndexPath.row];
        WXSubmitTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BUTTONCELL];
        
        if (!cell) {
            cell = [[WXSubmitTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:BUTTONCELL];
        }
        [cell.details setTitle:[NSString stringWithFormat:@"确认支付%.1f元",[model.b126 integerValue]*[model.b128 integerValue]*0.1] forState:(UIControlStateNormal)];
        [cell.details addTarget:self action:@selector(BuyingGoodsAction:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.backgroundColor=kUIColorFromRGB(0xf0ebeb);
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
        
    }
}
//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.payTableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        
        YS_PayInfoTableViewCell *cell = (YS_PayInfoTableViewCell *)[self.payTableView cellForRowAtIndexPath:indexPath];
        cell.ButtonImage.image = [UIImage imageNamed:@"choice-click"];
        if (indexPath.row!=payInfoIndexPath.row) {
            YS_PayInfoTableViewCell *oldcell = (YS_PayInfoTableViewCell *)[self.payTableView cellForRowAtIndexPath:payInfoIndexPath];
            oldcell.ButtonImage.image = [UIImage imageNamed:@"Choice-normal"];
            //记录选中cell
            payInfoIndexPath=indexPath;
        }
        [self.payTableView reloadData];
        
    }else if (indexPath.section == 1) {
        WXPayCell *cell = (WXPayCell *)[self.payTableView cellForRowAtIndexPath:indexPath];
        [cell.payDot setImage:[UIImage imageNamed:@"choice-click"] forState:(UIControlStateNormal)];
        if (indexPath.row!=payTypeIndexPath.row) {
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
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 80;
    }else{
        return 40;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=kUIColorFromRGB(0xf0ebeb);
    
    if (section==1){
        view.frame=CGRectMake(0, 0, ScreenWidth, 45);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 25, ScreenWidth, 24)];
        label.text=@"支付方式";
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=kUIColorFromRGB(0x737171);
        [view addSubview:label];
    }else if (section==0){
        view.frame=CGRectMake(0, 0, ScreenWidth, 45);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 25, ScreenWidth, 24)];
        label.text=@"超值套餐";
        label.textColor=kUIColorFromRGB(0x737171);
        label.font=[UIFont systemFontOfSize:12];
        [view addSubview:label];
    }else{
        view.frame=CGRectMake(0, 0, ScreenWidth, 1);
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 45;
    }else if(section==1){
        return 45;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        
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
        view.backgroundColor=kUIColorFromRGB(0xf0ebeb);
        return view;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        view.backgroundColor=kUIColorFromRGB(0xf0ebeb);
        return view;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
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
    
    YS_PayModel *Goodmodel=self.goodInfoArr[payInfoIndexPath.row];
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
            [wxpayDic setObject:GoodId  forKey:@"dh_goodId"];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"付款成功，兑换流程：个人中心--设置--活动相关" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    });
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

@end
