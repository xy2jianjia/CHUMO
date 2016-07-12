//
//  MeTouchController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MeTouchController.h"
#import "MeTouchCell.h"
#import "Homepage.h"
#import "MeTouchModel.h"
#import "DHNullCell.h"
#import "DHNoDataView.h"
#import "RefreshController.h"
#import "JYNavigationController.h"
@interface MeTouchController ()<UITableViewDelegate,UITableViewDataSource,DHNoDataViewDelegate> {
    
    UITableView *paraTabelView;
}
@property (nonatomic,strong)NSMutableArray *touchArray;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation MeTouchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self showHudInView:self.view hint:@"请稍等,正在努力加载!"];
//    [self layoutParallax];
    [self getTouchData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}

- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}
-(void)emptyView:(DHNoDataView *)emptyView btnTag:(NSInteger)btnTag{
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ViewController *vc = (ViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        vc.selectedIndex = 0;
    });
    
}
- (void)getTouchData {

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_105_11_1.service?a78=%@&a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1",@"1",p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSArray *touchArr = infoDic[@"body"];
            
            for (NSDictionary *touchDic in touchArr) {
                
                MeTouchModel *touch = [[MeTouchModel alloc] init];
                //如果没有用户id则,不显示
                if (touchDic[@"b80"] == nil) {
                    continue;
                }else{
                    touch.userId    = [NSString stringWithFormat:@"%@",touchDic[@"b80"]];
                }
                
                
                touch.photoUrl  = touchDic[@"b57"];  // 头像连接
                touch.nickName  = touchDic[@"b52"];  // 昵称
                touch.lockedStatus = touchDic[@"b41"];//封号
                touch.userType = touchDic[@"b143"];//用户类型
                touch.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                if (touchDic[@"b1"] == nil) {
                    touch.ageStr    = @"保密";   // 年龄
                }else{
                    touch.ageStr    = [NSString stringWithFormat:@"%@岁",touchDic[@"b1"]];   // 年龄
                }
                
                if (touchDic[@"b33"] == nil) {
                    touch.heightStr = @"保密";
                }else {
                    touch.heightStr    = [NSString stringWithFormat:@"%@cm",touchDic[@"b33"]];  // 身高
                }
                //动态机器人
                if ([touch.userType integerValue]==5) {
                    NSDictionary *locationDict = [NSGetTools getCLLocationData];
                    
                    
                    if ([locationDict objectForKey:@"a67"] == nil) {
                        touch.province = @"保密";
                    }else{
                        touch.province  = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",[locationDict objectForKey:@"a67"]]];  // 省份
                    }
                    if ([locationDict objectForKey:@"a9"] == nil) {
                        touch.city = @"保密";
                    }else{
                        touch.city      = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",[locationDict objectForKey:@"a9"]]];   // 城市
                    }
                }else{
                    touch.province  = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b67"]]];  // 省份
                    touch.city      = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b9"]]];   // 城市
                }
                
                
                [self.touchArray addObject:touch];
                
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
//        [paraTabelView reloadData];
        [self hideHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.touchArray.count == 0) {
                [self setupNullViewWithNoData];
            }else{
                [self layoutParallax];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}
- (void)setupNullViewWithNoData{
    DHNoDataView *emptyView = [[DHNoDataView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    emptyView.nodataImageView.image = [UIImage imageNamed:@"metouch_nodata_icon"];
    emptyView.delegate = self;
    [self.view addSubview:emptyView];
    
    
}
/**
 *  Description
 *
 *  @param VariDic 倒叙的城市/省份 字典
 *  @param keystr  key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariDic:(NSDictionary *)VariDic keyStr:(NSString *)keystr {
    
    NSDictionary *cityDic = VariDic;    // 市
    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
    for (NSString *cityKey in cityDic) {
        NSString *cityValue = [cityDic objectForKey:cityKey];
        [cityDict setObject:cityKey forKey:cityValue];
    }
    return [cityDict objectForKey:[NSString stringWithFormat:@"%@",keystr]];
}

- (void)layoutParallax
{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
//    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    [paraTabelView registerClass:[MeTouchCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:paraTabelView];
    paraTabelView.tableFooterView = [[UIView alloc]init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.touchArray.count == 0) {
//        return 1;
//    }else {
//        return self.touchArray.count;
//    }
    return self.touchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.touchArray.count == 0) {
//        
//        DHNullCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHNullCell" owner:self options:nil] lastObject];
//        cell.nullDelegate = self;
//        cell.headerImage.image = [UIImage imageNamed:@"touchme_nodata_icon"];
//        paraTabelView.scrollEnabled =NO; //设置tableview 不能滚动
//        return cell;
//    }else {
        MeTouchModel *touch = self.touchArray[indexPath.row];
        MeTouchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if ([touch.lockedStatus integerValue]==2) {
            [cell changeReportCellWithurlStr:[NSURL URLWithString:touch.photoUrl]];
            cell.userInteractionEnabled=NO;
        }else{
            [cell cellLoadWithurlStr:[NSURL URLWithString:touch.photoUrl]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.title.text = touch.nickName;
        if (touch.vip == 1 && [touch.lockedStatus integerValue]==1) {//是VIP且没被封号
            cell.title.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
            cell.VipImage.image = [UIImage imageNamed:@"icon-name-vip"];
        }else if([touch.lockedStatus integerValue]==1){
            cell.title.textColor = [UIColor darkGrayColor];
            cell.VipImage.image = nil;
        }else if([touch.lockedStatus integerValue]==2){
            cell.title.textColor = kUIColorFromRGB(0xd0d0d0);
            cell.VipImage.image = nil;
        }
        if (touch.ageStr == nil) {
            cell.age.text  = @"保密";
        }else {
            cell.age.text   = touch.ageStr;
        }
    
        if (touch.province == nil) {
            touch.province = @"保密";
        }
        if (touch.city == nil) {
            touch.city = @"保密";
        }
    if ([touch.province isEqualToString:touch.city]) {
        [cell addDataWithheight:[NSString stringWithFormat:@"%@",touch.heightStr] address:[NSString stringWithFormat:@"%@",touch.city]];
    }else{
        [cell addDataWithheight:[NSString stringWithFormat:@"%@",touch.heightStr] address:[NSString stringWithFormat:@"%@ %@",touch.province,touch.city]];
    }
    
    
        
        
        
        if (indexPath.row == 0) {
            cell.topLine.frame  = CGRectMake( 0,    0, [[UIScreen mainScreen] bounds].size.width, 0.5);
            cell.downLine.frame = CGRectMake(80, 79.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }else {
            cell.downLine.frame = CGRectMake(80, 79.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }
        return cell;
//    }
}



#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.touchArray.count == 0) {
        return [DHNullCell nullHeight];
    }else {
        return [MeTouchCell meTouchCellHeight];
    }
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.touchArray.count == 0) {
        
    }else {
        NSString *p1 = [NSGetTools getUserSessionId];//sessionId
        NSNumber *p2 = [NSGetTools getUserID];//ID
        NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
        MeTouchModel *touch = self.touchArray[indexPath.row];
        Homepage *home = [[Homepage alloc] init];
        home.touchP2 = touch.userId;
        
        DHUserInfoModel *model=[[DHUserInfoModel alloc]init];
        model.b52=touch.nickName;
        model.b80=[NSString stringWithFormat:@"%@",touch.userId];
        model.b143=touch.userType;
        home.item=model;
        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:home];
        [self presentViewController:nav animated:YES completion:nil];
        [NSURLObject addWithdict:nil urlStr:[NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,touch.userId,p1,p2,appInfo]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
