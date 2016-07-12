//
//  DHActivityPayViewController.m
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHActivityPayViewController.h"
#import "YS_PayVipCollectionViewCell.h"
#import "YS_VipInfoCollectionViewCell.h"
#import "YS_VipCollectionReusableView.h"
#import "YS_PayModel.h"
#import "YS_PrivilegeModel.h"
#import "JYPayWorking.h"
#import "DHAlertView.h"
#import "ShowVipController.h"
#import "NPServiceViewController.h"
#import "YS_PayVipAlertCollectionViewCell.h"

#define VipCollerctionCell @"VipAlertTableCell"
#define VipInfoCollerctionCell @"VipInfoTableCell"
#define REC_ImgHead @"REC_ImgHead"
@interface DHActivityPayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,JYPayWorkingDelegate,DHAlertViewDelegate>
@property (nonatomic,strong)UICollectionView *VipCollerctionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
//@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *privilegeArr;
@property (nonatomic,strong)JYPayWorking *payWorking;
@end

@implementation DHActivityPayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"VIP会员";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.privilegeArr=[NSMutableArray array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等.."];
    });
    [self setView];
    [self getDataArr];
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    
}
- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setView{
    self.layout =[[UICollectionViewFlowLayout alloc]init];
    self.layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    self.VipCollerctionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) collectionViewLayout:_layout];
    self.VipCollerctionView.delegate=self;
    self.VipCollerctionView.dataSource=self;
    self.VipCollerctionView.scrollEnabled=YES;
    self.VipCollerctionView.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    [self.view addSubview:_VipCollerctionView];
    [self.VipCollerctionView registerNib:[UINib nibWithNibName:@"YS_PayVipAlertCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:VipCollerctionCell];
    [self.VipCollerctionView registerNib:[UINib nibWithNibName:@"YS_VipInfoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:VipInfoCollerctionCell];
    
    [self.VipCollerctionView registerNib:[UINib nibWithNibName:@"YS_VipCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REC_ImgHead];
}
- (void)getDataVipInfo{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_14_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block DHActivityPayViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            
            NSArray *vipArr = infoDic[@"body"];//特权信息
            for (NSDictionary *dict in vipArr) {
                if ([[dict objectForKey:@"b149"] integerValue]==3) {//去除写信包月
                    continue;
                }
                YS_PrivilegeModel *model=[[YS_PrivilegeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [payVC.privilegeArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [payVC hideHud];
                [payVC.VipCollerctionView reloadData];
                
            });
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)getDataArr{
    [self getDataVipInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }else if(section==1){
        return self.privilegeArr.count;
    }else{
        return 0;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=nil;
    
    if (indexPath.section==0) {
        YS_PayModel *model=self.dataArr[indexPath.row];
        YS_PayVipAlertCollectionViewCell *VipCell=[collectionView dequeueReusableCellWithReuseIdentifier:VipCollerctionCell forIndexPath:indexPath];
        [VipCell cellSetValu:model];
        
        cell=VipCell;
    }else{
        YS_PrivilegeModel *model=self.privilegeArr[indexPath.row];
        YS_VipInfoCollectionViewCell *VipInfocell=[collectionView dequeueReusableCellWithReuseIdentifier:VipInfoCollerctionCell forIndexPath:indexPath];
        [VipInfocell CellSetValue:model];
        cell=VipInfocell;
        
    }
    return cell;
    
}
/**
 *  设置大小距离
 *
 *  @return
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return CGSizeMake(ScreenWidth, 50);
    }else{
        return CGSizeMake((ScreenWidth-3)/2, 40);
    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else{
        return 1;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YS_PayModel *model=self.dataArr[indexPath.row];
        NSString *payNum = [NSString stringWithFormat:@"%ld",(long)8];//内购
        [self.payWorking PaydataRuquesByGoodId:model.b13 payType:payNum success:^(NSDictionary *dic) {
            NSNumber *codeNum = dic[@"code"];
            if ([codeNum integerValue] == 200) {
                NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
                [wxpayDic setObject:model.b13  forKey:@"dh_goodId"];
                [wxpayDic setObject:payNum forKey:@"dh_payType"];
                [MobClick event:@"ngPay"]; // 内购统计事件
                [self.payWorking getProductInfo:model.b13 info:wxpayDic];
            }
            
        }];
    }else if(indexPath.section==1){
        YS_PrivilegeModel *model=self.privilegeArr[indexPath.row];
        ShowVipController *show = [[ShowVipController alloc] init];
        //        #warning mark 路径要改动
        //        http://192.168.0.122:8080/lp-ios-h5-msc/
        //        http://192.168.0.122:8080/lp-ios-h5-msc/S3-1002.html
        NSString *tempUrl=[NSString stringWithFormat:@"%@S3-%@.html",kServerAddressTestH5,model.b34];
        show.showUrl = tempUrl;
        show.navigationItem.title=model.b51;
        
        [self.navigationController pushViewController:show animated:true];
    }
    
}
//设置表头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
#pragma mark -- 定制头部视图的内容
    if (kind == UICollectionElementKindSectionHeader) {
        YS_VipCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REC_ImgHead forIndexPath:indexPath];
        NSLog(@"这个了%ld",indexPath.section);
        
        
        switch (indexPath.section) {
            case 0:
            {
                headerView.serviceView.hidden=YES;
                headerView.titleLable.text=@"超值套餐";
                break;
            }
            case 1:
            {
                headerView.serviceView.hidden=YES;
                headerView.titleLable.text=@"VIP荣耀特权";
                break;
            }
            case 2:{
                headerView.titleLable.text=@"";
                headerView.serviceView.hidden=NO;
                [headerView.serviceButton addTarget:self action:@selector(gotoServiceAction) forControlEvents:(UIControlEventTouchUpInside)];
                break;
                
            }
            default:
                break;
        }
        reusableView= headerView;
        
    }
    return reusableView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), 40);
}
- (void)gotoServiceAction{
    
    NPServiceViewController *temp = [[NPServiceViewController alloc] init];
    temp.urlWeb = [NSString stringWithFormat:@"%@p0.html",kServerAddressTestH5,nil]; ;
    [self.navigationController pushViewController:temp animated:true];
}
#pragma mark 弹框
//通知
- (void)payAction:(NSNotification *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"付款成功，兑换流程：个人中心--设置--活动相关" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    });
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
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
#pragma mark ====== alertView代理 ======
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            NSLog(@"不做操作");
        }else if (buttonIndex == 1) {
            NResetController *reset = [[NResetController alloc] init];
            reset.title = @"绑定手机号";
            reset.msgType = @"3";
            [self.navigationController pushViewController:reset animated:true];
        }
    }else {
        if (buttonIndex == 0) {
            NSLog(@"不做操作");
        }else if (buttonIndex == 1) {
            NResetController *reset = [[NResetController alloc] init];
            reset.title = @"绑定手机号";
            reset.msgType = @"3";
            [self.navigationController pushViewController:reset animated:true];
        }
    }
    
}
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"extractVipWhenPay" object:nil];
        [self payAction:nil];
    }else{
        [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(5)];
        [self alert:@"提示" msg:msg];
    }
}

@end
