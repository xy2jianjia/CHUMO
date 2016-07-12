//
//  SeenMeController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SeenMeController.h"
#import "MyPhotoViewController.h"

#import "DHSeenModel.h"
#import "DHNullCell.h"
#import "Homepage.h"
#import "MeTouchCell.h"
#import "DHNoDataView.h"
#import "RefreshController.h"
#import "JYNavigationController.h"
@interface SeenMeController ()<UITableViewDelegate,UITableViewDataSource,DHNoDataViewDelegate> {
    
    UITableView *paraTabelView;
}

@property (nonatomic,strong)NSMutableArray *seenMeArray;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation SeenMeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self layoutParallax];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.seenMeArray = [NSMutableArray array];
    [self showHudInView:self.view hint:@"请稍等,正在努力加载!"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [self n_Request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutParallax
{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
//    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
//    [paraTabelView registerClass:[SeenCell class] forCellReuseIdentifier:@"cell"];
    [paraTabelView registerClass:[MeTouchCell class] forCellReuseIdentifier:@"cell"];
//    [paraTabelView registerClass:[DHNullCell class] forCellReuseIdentifier:@"cell_1"];
    [self.view addSubview:paraTabelView];
    paraTabelView.tableFooterView = [[UIView alloc]init];
//    if (self.seenMeArray.count == 0) {
//        paraTabelView.scrollEnabled =NO; //设置tableview 不能滚动
//    }else {
//        paraTabelView.scrollEnabled =YES;
//    }
}
-(void)emptyView:(DHNoDataView *)emptyView btnTag:(NSInteger)btnTag{
    MyPhotoViewController *photo= [[MyPhotoViewController alloc] init];
    [self.navigationController pushViewController:photo animated:true];
}
#pragma mark ---- request
- (void)n_Request {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_109_10_1.service?a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1",p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __weak SeenMeController *seenMeVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            
            NSArray *touchArray = infoDic[@"body"];
            NSPredicate *predicate= [NSPredicate predicateWithFormat:@"userId=$Name"];
            
            for (NSDictionary *touchDic in touchArray) {
                
                DHSeenModel *seen = [[DHSeenModel alloc] init];
                //如果没有用户id则,不显示
                if (touchDic[@"b80"]==nil) {
                    continue;
                }else{
                    seen.userId = [NSString stringWithFormat:@"%@",touchDic[@"b80"]];
                }
                //避免重复用户
//                seen.userId    = touchDic[@"b80"];  // ID传值用
                NSDictionary *pridicateDict=[NSDictionary dictionaryWithObjectsAndKeys:seen.userId,@"Name", nil];
                NSPredicate *pre=[predicate predicateWithSubstitutionVariables:pridicateDict];
                BOOL isHad=NO;
                for (DHSeenModel *model in self.seenMeArray) {
                    if ([pre evaluateWithObject:model]) {
                        isHad=YES;
                    }
                }
                if (isHad) {
                    continue;
                }
                
                seen.photoUrl  = touchDic[@"b57"];  // 头像连接
                seen.nickName  = touchDic[@"b52"];  // 昵称
                seen.lockedStatus = touchDic[@"b41"]; // 封号
                seen.userType = touchDic[@"b143"];
                seen.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                if (touchDic[@"b1"] == nil) {
                    seen.ageStr = @"保密";
                }else {
                    seen.ageStr = [NSString stringWithFormat:@"%@岁",touchDic[@"b1"]];   // 年龄
                }
                
                if (touchDic[@"b33"] == nil) {
                    seen.heightStr = @"保密";
                }else {
                    seen.heightStr    = [NSString stringWithFormat:@"%@cm",touchDic[@"b33"]];  // 身高
                }
                if (touchDic[@"b67"] == nil) {
                    seen.province = @"保密";
                }else {
                    seen.province  = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b67"]]];  // 省份
                }
                if (touchDic[@"b9"] == nil) {
                    seen.city = @"保密";
                }else {
                    seen.city = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b9"]]];   // 城市
                }
                
                [seenMeVC.seenMeArray addObject:seen];
            }
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [seenMeVC presentViewController:refre animated:YES completion:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (seenMeVC.seenMeArray.count == 0) {
                [seenMeVC setupNullViewWithNoData];
            }else{
                [seenMeVC layoutParallax];
            }
        });
//        [paraTabelView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}
- (void)setupNullViewWithNoData{
    
    //    DHNoDataView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"DHNoDataView" owner:self options:nil] lastObject];
    DHNoDataView *emptyView = [[DHNoDataView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    emptyView.nodataImageView.image = [UIImage imageNamed:@"seeme_nodata_icon"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.seenMeArray.count == 0) {
//        return 1;
//    }else {
//        return self.seenMeArray.count;
//    }
    return self.seenMeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.seenMeArray.count == 0) {
////        DHNullCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_1"];
//        DHNullCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHNullCell" owner:self options:nil] lastObject];
//        cell.nullDelegate = self;
//        cell.headerImage.image = [UIImage imageNamed:@"touch@1x"];
//        paraTabelView.scrollEnabled =NO; //设置tableview 不能滚动
//        return cell;
//    }else {
        DHSeenModel *seen = self.seenMeArray[indexPath.row];
//        SeenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        MeTouchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if ([seen.lockedStatus integerValue]==2) {
            [cell changeReportCellWithurlStr:[NSURL URLWithString:seen.photoUrl]];
            cell.userInteractionEnabled=NO;
        }else{
            [cell cellLoadWithurlStr:[NSURL URLWithString:seen.photoUrl]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.title.text = seen.nickName;
        
        if (seen.vip == 1 && [seen.lockedStatus integerValue]==1) {//是VIP且没被封号
            cell.title.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
            cell.VipImage.image = [UIImage imageNamed:@"icon-name-vip"];
        }else if([seen.lockedStatus integerValue]==1){
            cell.title.textColor = [UIColor darkGrayColor];
            cell.VipImage.image = nil;
        }else if([seen.lockedStatus integerValue]==2){
            cell.title.textColor = kUIColorFromRGB(0xd0d0d0);
            cell.VipImage.image = nil;
        }
        cell.age.text = seen.ageStr;
        if ([seen.province isEqualToString:seen.city]) {
            [cell addDataWithheight:seen.heightStr address:[NSString stringWithFormat:@"%@",seen.city]];
            
        }else{
            [cell addDataWithheight:seen.heightStr address:[NSString stringWithFormat:@"%@ %@",seen.province,seen.city]];
        }
    
//        [cell cellLoadWithurlStr:[NSURL URLWithString:seen.photoUrl]];
        return cell;
//    }
}

#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seenMeArray.count == 0) {
        return [DHNullCell nullHeight];
    }else {
        return 80;
    }
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.seenMeArray.count == 0) {
        
    }else {
        NSString *p1 = [NSGetTools getUserSessionId];//sessionId
        NSNumber *p2 = [NSGetTools getUserID];//ID
        NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
        DHSeenModel *seen = self.seenMeArray[indexPath.row];
        Homepage *home = [[Homepage alloc] init];
        home.touchP2 = seen.userId;
        DHUserInfoModel *model=[[DHUserInfoModel alloc]init];
        model.b52=seen.nickName;
        model.b80=[NSString stringWithFormat:@"%@",seen.userId];
        model.b143=seen.userType;
        home.item=model;
        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:home];
        [self presentViewController:nav animated:YES completion:nil];
        [NSURLObject addWithdict:nil urlStr:[NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,seen.userId,p1,p2,appInfo]];
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
