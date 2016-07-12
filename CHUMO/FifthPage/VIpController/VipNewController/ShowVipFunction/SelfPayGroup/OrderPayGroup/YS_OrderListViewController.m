//
//  YS_OrderListViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_OrderListViewController.h"
#import "YS_HistoryOrderModel.h"
#import "JYPayWorking.h"
#import "RefreshController.h"
#import "YS_OrderPayedCollectionViewCell.h"
#import "YS_OrderPayingCollectionViewCell.h"
#import "DHAlertView.h"
#import "YS_HistoryOrderInfoViewController.h"
#import "YS_HistoryOrderOverInfoViewController.h"
#define PayedCell @"PayedCell"
#define PayingCell @"PayingCell"

@interface YS_OrderListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YS_OrderPayingDelegate,DHAlertViewDelegate,JYPayWorkingDelegate>
@property (nonatomic,strong)UICollectionView *orderCollectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *codePrefix;
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation YS_OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"历史订单";
    self.dataArray=[NSMutableArray array];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等..."];
    });
    
    [self setOrderListView];
    [self requestOrderData];
    [Mynotification addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 界面设置
- (void)setOrderListView{
    
    self.layout=[[UICollectionViewFlowLayout alloc]init];
    self.layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.layout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.orderCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:_layout];
    self.orderCollectionView.delegate=self;
    self.orderCollectionView.dataSource=self;
    self.orderCollectionView.backgroundColor= kUIColorFromRGB(0xf0ebeb);
    
    [self.orderCollectionView registerNib:[UINib nibWithNibName:@"YS_OrderPayedCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PayedCell];
    [self.orderCollectionView registerNib:[UINib nibWithNibName:@"YS_OrderPayingCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PayingCell];
    
    [self.view addSubview:_orderCollectionView];
    
}
#pragma mark 请求数据
- (void)requestOrderData{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_125_11_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak YS_OrderListViewController *orderVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas= responseObject;
        NSString *result=[[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr=[NSGetTools DecryptWith:result];//解密
        NSDictionary *infoDic=[NSGetTools parseJSONStringToNSDictionary:jsonStr];
        
        NSNumber *codeNum=infoDic[@"code"];
        
        if ([codeNum integerValue]==200) {
            NSArray *arr=infoDic[@"body"];
            for (NSDictionary *dict in arr) {
                YS_HistoryOrderModel *model=[[YS_HistoryOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [orderVC.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [orderVC.orderCollectionView reloadData];
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
#pragma mark collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YS_HistoryOrderModel *model = self.dataArray[indexPath.row];
    if ([model.b122 integerValue]==3) {
        YS_OrderPayingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:PayingCell forIndexPath:indexPath];
        [cell setCellByModel:model];
        cell.delegate=self;
        cell.OrderIndexPath=indexPath;
        return cell;
    }else{
        YS_OrderPayedCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:PayedCell forIndexPath:indexPath];
        [cell setCellByModel:model];
        
        return cell;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    YS_HistoryOrderModel *model = self.dataArray[indexPath.row];
    if ([model.b122 integerValue]==3) {
        return CGSizeMake(ScreenWidth, 150);
    }else{
        return CGSizeMake(ScreenWidth, 100);
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击查看详情
    YS_HistoryOrderModel *model=self.dataArray[indexPath.row];
    if ([model.b122 integerValue]==3) {
        //待支付
        YS_HistoryOrderInfoViewController *infoVC=[[YS_HistoryOrderInfoViewController alloc]init];
        infoVC.model=model;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else{
        YS_HistoryOrderOverInfoViewController *overVC=[[YS_HistoryOrderOverInfoViewController alloc]init];
        overVC.model=model;
        [self.navigationController pushViewController:overVC animated:YES];
    }
    
}

#pragma  mark 支付代理
-(void)noticeToPay:(NSIndexPath *)currentIndexPath{
    YS_HistoryOrderModel *model=self.dataArray[currentIndexPath.row];
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    NSInteger payType =  [model.b130 integerValue];
    NSString *prefix= [NSString stringWithFormat:@"%@",model.b131];
    payRequsestFlag payflag=(payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
    if ((payflag & payType)) {
        if (payType ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
            [self alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
        }
        NSString *strs=[[NSString stringWithFormat:@"%@",prefix] substringWithRange:NSMakeRange(0, 4)];
        [self setValue:strs forKey:@"codePrefix"];
        [self payAgainAction:payType GoodId:prefix];
    }
}

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
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        NResetController *reset = [[NResetController alloc] init];
        reset.title = @"绑定手机号";
        reset.msgType = @"3";
        [self.navigationController pushViewController:reset animated:true];
    }
}
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"extractVipWhenPay" object:nil];
        [self payAction:nil];
    }else{
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
        if ([_codePrefix isEqualToString: [NSString stringWithFormat:@"%@",[goodDict objectForKey:@"b13"]]]) {//写信
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(6)];
        }else{//VIP
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(5)];
        }
        [self alertViewOfTitle:@"提示" msg:msg];
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
