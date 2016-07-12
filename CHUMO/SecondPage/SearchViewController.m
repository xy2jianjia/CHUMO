//
//  SearchViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
//#import "SearchModel.h"
#import "SearchSetViewController.h"
#import "ChatController.h"
#import "Homepage.h"
#import "DHConfigHeaderRefreshTool.h"
#import "RefreshController.h"
#import "GifController.h"
#import "JYNavigationController.h"
@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *allDataArray;

@property (nonatomic,strong) NSString *a1;// 年龄范围 20-25
@property (nonatomic,strong) NSString *a85;// 收入范围 10000-12000
@property (nonatomic,strong) NSString *a33;// 身高170-180
@property (nonatomic,strong) NSString *a46;// 婚姻状态
@property (nonatomic,strong) NSString *a40;// 经度(当前自己的位置)
@property (nonatomic,strong) NSString *a38;// 纬度
@property (nonatomic,strong) NSString *a29;// 是否有车
@property (nonatomic,strong) NSString *a32;// 是否有房
@property (nonatomic,strong) NSString *a62;// 职业
@property (nonatomic,strong) NSString *a19;// 最低学历
@property (nonatomic,strong) NSString *a67;// 省
@property (nonatomic,strong) NSString *a9;// 市
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.title = @"搜索";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation-search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(searchMore)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation-search.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(searchMore)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//WithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMore)];
    self.allDataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchSetData:) name:@"searchSetData"object:nil];
    
//    NSNumber *num = [NSNumber numberWithInt:1];
//    [self searchSet:num];// 加载数据
    [self headerRereshing];
    [self footerRereshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
- (void)searchMore{
    SearchSetViewController *vc = [[SearchSetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addTableReques {

}

#pragma mark 开始进入刷新状态
// 下拉
- (void)headerRereshing
{
    [self.allDataArray removeAllObjects];
    // 设置header
    self.tableView.mj_header = [DHConfigHeaderRefreshTool configHeaderWithTarget:self action:@selector(searchSet)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)searchSet{
    [self searchSet:nil];
}
// 上拉
- (void)footerRereshing{
//    [self footerRereshing];
    __unsafe_unretained typeof(self) collectionV = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSNumber *b96 = [NSGetTools getSearchB96];// 获取是否有下一页
        if ([b96 intValue] == 1) {
            static int a95 = 1;
            a95 = a95 + 1;
            [self searchSet:nil];
            
        }else{
            [NSGetTools showAlert:@"暂无更多数据"];
        }
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [collectionV.tableView.mj_footer endRefreshing];
        });
    }];
}

// 搜索条件通知
- (void)SearchSetData:(NSNotification *)notification
{
//    [self.allDataArray removeAllObjects];
////    NSNumber *num = [NSNumber numberWithInt:1];
//    [self searchSet:nil];// 加载数据
    [self headerRereshing];
//    [self.tableView.mj_header beginRefreshing];

}
// 搜索条件
- (void)searchSet:(DHDomainModel *)apiInfo {
    
    NSMutableString *idsStr=[NSMutableString string];
    NSInteger index = 0;
    for (DHUserInfoModel *model in self.allDataArray) {
        [idsStr appendString:[NSString stringWithFormat:@"%@",model.b80]];
        if (self.allDataArray.count - 1 > index) {
            [idsStr appendString:@","];
        }
        index ++;
    }
    NSDictionary *locationDict = [NSGetTools getCLLocationData];
    NSString *a9_local = [locationDict objectForKey:@"a9"];
    NSDictionary *dict = [NSGetTools getSearchSetDict];
    if ([[dict allKeys] count] > 0) {
        NSString *a1 = [[dict[@"年龄"] allKeys] objectAtIndex:0];
        NSString *a33 =[[dict[@"身高"] allKeys] objectAtIndex:0];;
        NSString *addressStr = dict[@"地区"];
        NSString *a9 = nil;
        NSString *a67 = nil;
        if (addressStr != nil) {
            NSArray *array = [addressStr componentsSeparatedByString:@" "];
            NSString *cityStr = array[1];// 市
            NSString *stateStr = array[0];// 省
            NSDictionary *cityDict = [NSDictionary dictionary];
            NSDictionary *stateDict = [NSDictionary dictionary];
            //获取plist中的数据
            cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
            stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
            NSDictionary *cityCodeDict = cityDict[cityStr];
            NSDictionary *stateCodeDict = stateDict[stateStr];
            
            a9 = cityCodeDict[@"city_code"];
            a67 = stateCodeDict[@"provence_code"];
            
        }
        NSString *a46Str = dict[@"婚姻"];
        NSNumber *a46 = nil;
        if ([a46Str length] != 0) {
            NSDictionary *a46Dcit = [NSGetSystemTools getmarriageStatusInSearch];
            a46 = [NSGetTools getSystemNumWithDict:a46Dcit value:a46Str];
        }
        NSString *a19Str = dict[@"学历"];
        NSNumber *a19 = nil;
        if ([a19Str length] != 0) {
            NSDictionary *a19Dcit = [NSGetSystemTools geteducationLevel];
            a19 = [NSGetTools getSystemNumWithDict:a19Dcit value:a19Str];
        }
        NSString *a29Str = dict[@"车产"];
        NSNumber *a29 = nil;
        if ([a29Str length] > 0) {
            NSDictionary *a29Dcit = [NSGetSystemTools gethasCar];
            a29 = [NSGetTools getSystemNumWithDict:a29Dcit value:a29Str];
        }
        NSString *a32Str = dict[@"房产"];
        NSNumber *a32 = nil;
        if ([a32Str length] > 0) {
            NSDictionary *a32Dcit = [NSGetSystemTools gethasRoom];
            a32 = [NSGetTools getSystemNumWithDict:a32Dcit value:a32Str];
        }
        NSString *moneyStr = dict[@"收入"];
        NSString *a86=nil;//大
        NSString *a87=nil;//小
        if (moneyStr!=nil) {
            NSArray *moneyArr=[moneyStr componentsSeparatedByString:@"至"];
            a86 = moneyArr[1];
            a87 = moneyArr[0];
        }
        NSMutableDictionary *searchDict2 = [NSMutableDictionary dictionary];
        if (a86 !=nil || a86 !=NULL) {
            [searchDict2 setObject:a86 forKey:@"a86"];
        }
        if (a87 !=nil || a87 !=NULL) {
            [searchDict2 setObject:a87 forKey:@"a87"];
        }
        if (a1 != nil || a1 != NULL) {
            [searchDict2 setObject:a1 forKey:@"a1"];
        }
        if (a33 != nil || a33 != NULL){
            [searchDict2 setObject:a33 forKey:@"a33"];
        }
        if (a9 != nil || a9 != NULL){
            [searchDict2 setObject:a9 forKey:@"a9"];
        }
        if (a67 != nil || a67 != NULL){
            [searchDict2 setObject:a67 forKey:@"a67"];
        }
        if (a46 != nil || a46 != NULL){
            [searchDict2 setObject:a46 forKey:@"a46"];
        }
        if (a19 != nil || a19 != NULL){
            [searchDict2 setObject:a19 forKey:@"a19"];
        }
        if (a29 != nil || a29 != NULL){
            [searchDict2 setObject:a29 forKey:@"a29"];
        }
        if (a32 != nil || a32 != NULL){
            [searchDict2 setObject:a32 forKey:@"a32"];
        }
        NSString *a177 = nil;
        if ([a9_local integerValue] == [a9 integerValue]) {
            a177 = @"1";
        }else{
            a177 = @"2";
        }
        [searchDict2 setObject:a177 forKey:@"a177"];
        if ([idsStr length] != 0) {
            [searchDict2 setObject:idsStr forKey:@"a117"];
        }
        [searchDict2 setObject:@"1" forKey:@"a95"];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        [searchDict2 setObject:userinfo.b69 forKey:@"a69"];
        [self addSearchDatasWithDict:searchDict2 a95:[NSNumber numberWithInt:1] url:apiInfo.api];// 重新搜索数据
    }else{
//        NSNumber *a69 = [NSGetTools getUserSexInfo];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        NSDictionary *temp = nil;
        if ([idsStr length] != 0) {
            temp = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.b69,@"a69",@"2",@"a177",idsStr,@"a117",@"1",@"a95", nil];
        }else{
            temp = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.b69,@"a69",@"2",@"a177",@"1",@"a95", nil];
        }
        
        [self addSearchDatasWithDict:temp a95:[NSNumber numberWithInt:1] url:apiInfo.api];
    }
}

// 搜索数据
/**
 *  a95:分页参数,a9:居住地（市）,a67:居住地（省）,a1:年龄范围,a85:收入,a19:最低学历,a33:身高,a46:婚姻状态,a69:性别
 *  a40:经度,a38:纬度,a29:是否有车,a32:是否有房,a62:职业
 *
 *  @param dict3
 *  @param a95Num
 */
- (void)addSearchDatasWithDict:(NSDictionary *)dict3 a95:(NSNumber *)a95Num url:(NSString *)url
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    if (url) {
        url = [NSString stringWithFormat:@"%@f_108_12_1.service?p1=%@&p2=%@&%@",url,p1,p2,appinfoStr];
    }else{
       url = [NSString stringWithFormat:@"%@f_108_12_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    [manger GET:url parameters:dict3 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *arr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateSearchB96WithNum:b96];// 更新b96
            for (NSDictionary *dict in arr) {
//                if (dict3) {
//                    DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
//                    [item setValuesForKeysWithDictionary:dict];
//                    NSDictionary *di = [NSGetTools getCLLocationData];
//                    if ([item.b9 integerValue] == [[di objectForKey:@"a9"] integerValue]) {
//                        if ([item.b75 integerValue]==1) {
//                            if (nil!=item.b57) {
//                                if ([item.b143 integerValue] != 3) {
//                                    [self.allDataArray addObject:item];
//                                }
//                            }
//                        }
//                    }else{
//                        // 是真实用户才添加。
//                        if ([item.b143 integerValue] == 1) {
//                            if ([item.b75 integerValue]==1) {
//                                if (nil!=item.b57) {
//                                    if ([item.b143 integerValue] != 3) {
//                                        [self.allDataArray addObject:item];
//                                    }
////                                    [self.allDataArray addObject:item];
//                                }
//                            }
//                        }
//                    }
//                }else{
//                    DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
//                    [item setValuesForKeysWithDictionary:dict];
//                    [self.allDataArray addObject:item];
//                }
                DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                [item setValuesForKeysWithDictionary:dict];
                [self.allDataArray addObject:item];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (self.allDataArray.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GifController *gif = [[GifController alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gif];
                        gif.title = @"搜索";
                        nav.navigationBar.translucent = NO;
                        nav.navigationBar.barTintColor = MainBarBackGroundColor;
                        [self presentViewController:nav animated:true completion:nil];
                    });
                }
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
        
        //NSLog(@"---%@--%ld",self.allDataArray,self.allDataArray.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"apiName"];
        __block DHDomainModel *apiModel = nil;
        if (flag) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_2"];
                [self searchSet:apiModel];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apiName"];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showHint:@"请求超时"];
                if (self.isnetWroking) {
                    RefreshController *refre = [[RefreshController alloc] init];
                    [self presentViewController:refre animated:YES completion:nil];
                }else{
                    [self showHint:@"没有网络,还怎么浪~~"];
                }
//                RefreshController *refre = [[RefreshController alloc] init];
//                [self presentViewController:refre animated:YES completion:nil];
            });
        }else{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_1"];
                [[NSUserDefaults  standardUserDefaults] setBool:YES forKey:@"apiName"];
                [self searchSet:apiModel];
            });
        }
        
    }];
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier2";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,got(20)+gotHeight(50),0,0)];
    }
    
    if (self.allDataArray.count > 0) {
//        SearchModel *model = self.allDataArray[indexPath.row];
        DHUserInfoModel *item = self.allDataArray[indexPath.row];
        cell.searchModel = item;
        cell.iconImageView.tag = indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserDetail:)];
        cell.iconImageView.userInteractionEnabled = YES;
        cell.iconImageView.tag = indexPath.row;
        [cell.iconImageView addGestureRecognizer:tap];
    }
    
    
    return cell;

}

- (void)showUserDetail:(UITapGestureRecognizer *)sender{
    DHUserInfoModel *userinfo = [self.allDataArray objectAtIndex:sender.view.tag];
    Homepage *home = [[Homepage alloc] init];
    home.item = userinfo;
    home.touchP2 = userinfo.b80;
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:home];
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SearchModel *model = self.allDataArray[indexPath.row];
    DHUserInfoModel *model = self.allDataArray[indexPath.row];
    NSString *targetId = [NSString stringWithFormat:@"%@",model.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",model.b52];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *token = [NSGetTools getToken];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [format stringFromDate:[NSDate date]];
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
    NSString *messageId = [format1 stringFromDate:[NSDate date]];
    DHMessageModel *item = [[DHMessageModel alloc]init];
    item.messageId = messageId;
    item.messageType = @"1";
    item.message = @"我在这里搜索到你，和我聊天吧！";
    item.fromUserDevice = @"2";
    item.fromUserAccount = userId;
    item.token = token;
    item.timeStamp = date;
    item.toUserAccount = targetId;
    item.userId = userId;
//    item.roomCode = @"";
    item.roomName = targetName;
    item.targetId = [NSString stringWithFormat:@"%@",model.b80];
//    if (![DBManager checkMessageWithMessageId:messageId fromUserAccount:item.fromUserAccount]) {
//        [DBManager insertMessageDataDBWithModel:item userId:userId];
//    }
//    [[SocketManager shareInstance] creatRoomWithString:nil account:[NSString stringWithFormat:@"%@",model.b80]];// 开房间
    ChatController *vc = [[ChatController alloc]init];
    vc.item = item;
    vc.userInfo = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gotHeight(90);
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
