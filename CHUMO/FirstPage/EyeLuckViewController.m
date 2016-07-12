//
//  EyeLuckViewController.m
//  StrangerChat
//
//  Created by long on 15/10/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "EyeLuckViewController.h"
//#import "EyeLuckModel.h"

#import "Homepage.h"
#import "DHUserInfoModel.h"
#import "DHConfigHeaderRefreshTool.h"
#import "RefreshController.h"
#import "DHMessageToustView.h"
#import "DHCityRecommendView.h"
#import "DHEyeLuckyCell.h"
#import "DHEyeLuckyRightCell.h"
#import "DHEyeLuckyBottumCell.h"
#import "DHLayout.h"
#import "DHSystemDataModel.h"
#import "EyeLuckViewController+Banner.h"
#import "JYSayHelloDao.h"
#import "JYMoveUserDao.h"
#import "JYNavigationController.h"
#import "AFNHttpRequestOPManager.h"
//#define colletionCell 2  //设置具体几列
//#define KcellHeight  got(93) // cell最小高
//#define KcellSpace got(10) // cell之间的间隔

static const NSString *RECONNECTED_URL = @"yoouushang.com";

@interface EyeLuckViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DHMessageToustViewDelegate>
{
    
    NSMutableArray  *hArr; //记录每个cell的高度
    NSMutableArray *wArr;
    UIImageView *imageView;
    UILabel *addLabel;
    
    
}
//@property (nonatomic,strong) UINavigationController *navVc;
//@property (nonatomic,strong) UICollectionView *collectionView2;
@property (nonatomic,strong) NSMutableArray *allModelArray;
@property (nonatomic,strong) NSTimer *lineTimer;
@property (nonatomic,assign) BOOL isReconnected;// 是否重连
@property (nonatomic,assign) BOOL isnetWroking;

/**
 *  头像布局显示方式，1为大图，2为小图
 */
@property (nonatomic,assign) NSInteger largeType;
/**
 *  心跳按钮
 */
//@property (nonatomic,assign) BOOL isBtnSelected;
//@property (nonatomic,strong) DHUserInfoModel *model;
@property (nonatomic,strong) NSNumber *ishaveNext;
//加载页数
@property (nonatomic,assign) NSInteger pageNum;
@end

@implementation EyeLuckViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self asyncGetBannerList:^(UIView *bannerView, NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect superFrame = self.collectionView.frame;
            superFrame.origin.y = CGRectGetMaxY(bannerView.frame)+0;
            superFrame.size.height = ScreenHeight-CGRectGetMaxY(bannerView.frame);
            self.collectionView.frame = superFrame;
            
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ishaveNext= [NSNumber numberWithBool:YES];
    [self addHeaderWithBool:NO];
    self.isnetWroking=YES;
//    [AFNHttpRequestOPManager sharedClient:self];
    [Mynotification addObserver:self selector:@selector(shouMessageToustView:) name:@"shouMessageToustView" object:nil];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //请求系统参数
    [self getSystemDataInfos];
    [self getDataArr];
    //collectionview控制
    //    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    //    DHLayout *flowLayout = [[DHLayout alloc]init];
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
    //    self.collectionView=[[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:flowLayout];
    //    self.collectionView.dataSource=self;
    //    self.collectionView.delegate=self;
    
    [self.collectionView setBackgroundColor:HexRGB(0Xeeeeee)];
    [self.collectionView registerClass:[DHEyeLuckyCell class] forCellWithReuseIdentifier:@"cell_big"];
    [self.collectionView registerClass:[DHEyeLuckyRightCell class] forCellWithReuseIdentifier:@"cell_right"];
    [self.collectionView registerClass:[DHEyeLuckyBottumCell class] forCellWithReuseIdentifier:@"cell_bottum"];
    //    [self.view addSubview:_collectionView2];
    // 2.集成刷新控件
    
    
    //请求用户最新的信息和特权
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfosWhenUpdate) name:@"getUserInfosWhenUpdate" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(extractVip) name:@"extractVipWhenPay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
    
    [self extractVip];
    [self getUserInfosWhenUpdate];
    
    //清除打招呼
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[dateFormatter stringFromDate:[NSDate date]];
    [JYSayHelloDao removeSayHellListUserFromDbWithDate:date];
    
    //清除触动
   
    [JYMoveUserDao removeSayHellListUserFromDbWithDate:date];
    
    
    
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
// 请求用户特权信息
- (void)extractVip { // 提取系统VIP信息  p1 p2 a78--> type分类     a13 code-->编码
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    NSString *sex=nil;
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 1男2女
        sex = @"1";
    }else {
        sex = @"2";
    }
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_11_1.service?a78=%@&a13=%@&p1=%@&p2=%@&%@",kServerAddressTest2,sex,@"",p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __weak EyeLuckViewController *VIpVC=self;
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
                    NSArray *arrP=vipdict[@"b141"];
                    //设置绑定账号
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults removeObjectForKey:@"XXAccount"];//账号

                    
                    
                    for (NSDictionary *dict in arrP) {
                        if ([dict[@"b139"] integerValue]==1011) {
                            [userDefaults setObject:dict[@"b139"] forKey:@"XXAccount"];
                        }
                        
                    }
                    

                    
                    
                    [userDefaults synchronize];
                    
                }
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
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (void)addHeaderWithBool:(BOOL)isFromTouchHeart
{
    self.isReconnected = isFromTouchHeart;
    [self addHeader];
    [self asyncLoadData];
    
}
// 下拉
- (void)addHeader
{
    [self.allModelArray removeAllObjects];
    // 设置header
    // 下拉刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.ishaveNext=[NSNumber numberWithBool:YES];
        NSDictionary *locationDict = [NSGetTools getCLLocationData];
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        [temp setObject:userinfo.b69 forKey:@"a69"];
        [temp setObject:@"1" forKey:@"a95"];
        [weakSelf asyncLoadDataDownWithUrl:nil parameters:temp isFromHeaderRefresh:NO];
        
        
    }];

}

- (void)addFooter
{
    
    __unsafe_unretained typeof(self) collectionV = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSDictionary *locationDict = [NSGetTools getCLLocationData];
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        [temp setObject:userinfo.b69 forKey:@"a69"];
        [temp setObject:@"1" forKey:@"a95"];
        [collectionV asyncLoadDataWithUrl:nil parameters:temp isFromHeaderRefresh:NO];
        
    }];
}

- (void)asyncLoadData{
    NSDictionary *locationDict = [NSGetTools getCLLocationData];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (!userinfo) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self asyncLoadData];
        });
    }else{
        [temp setObject:userinfo.b69 forKey:@"a69"];
        [temp setObject:@"1" forKey:@"a95"];
        [self asyncLoadDataWithUrl:nil parameters:temp isFromHeaderRefresh:YES];
    }
    
}
/**
 *  下拉
 *
 *  @param temp                参数
 *  @param isFromHeaderRefresh
 */
- (void)asyncLoadDataDownWithUrl:(NSString *)url parameters:(NSDictionary *)parameters isFromHeaderRefresh:(BOOL)isFromHeaderRefresh{
    NSString *userId= [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[NSGetTools getUserSessionId]];
    NSMutableString *idsStr=[NSMutableString string];
    if (isFromHeaderRefresh) {
        self.allModelArray = [NSMutableArray array];
        hArr = [[NSMutableArray alloc] init];
        wArr = [[NSMutableArray alloc] init];
    }
    
    if (url) {
        url = [NSString stringWithFormat:@"%@f_111_15_1.service?a117=%@&p1=%@&p2=%@",url,idsStr,sessionId,userId];
    }else{
        
        if ([idsStr length] == 0) {
            url = [NSString stringWithFormat:@"%@f_111_15_1.service?p2=%@&p1=%@",kServerAddressTest2,userId,sessionId];
        }else{
            url = [NSString stringWithFormat:@"%@f_111_15_1.service?a117=%@&p2=%@&p1=%@",kServerAddressTest2,idsStr,userId,sessionId];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block EyeLuckViewController *eyeVC=self;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateB96WithNum:b96];// 更新b96
            if ([b96 integerValue]==0) {
                [self setValue:[NSNumber numberWithBool:NO] forKey:@"ishaveNext"];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //移除所有
                [self.allModelArray removeAllObjects];
                for (NSDictionary *dict2 in modelArr) {
                    DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                    if ([dict2 isKindOfClass:[NSDictionary class]]) {
                        [item setValuesForKeysWithDictionary:dict2];
                        if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                            [DHUserInfoDao insertUserToDBWithItem:item];
                            
                        }else{
                            [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
                        }
                        if ([item.b143 integerValue] != 3) {
                            [self.allModelArray addObject:item];
                        }
                    }
                }
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                [self addFooter];
                
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
        [self.collectionView.mj_header endRefreshing];
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"apiName"];
        __block DHDomainModel *apiModel = nil;
        if (flag) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_2"];
                NSDictionary * parameters = [NSGetTools getCLLocationData];
                [self asyncLoadDataDownWithUrl:apiModel.api parameters:parameters isFromHeaderRefresh:NO];
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
                NSDictionary * parameters = [NSGetTools getCLLocationData];
                [self asyncLoadDataDownWithUrl:apiModel.api parameters:parameters isFromHeaderRefresh:NO];
            });
        }
        
    }];
}
/**
 *  上啦
 *
 *  @param url                 路径
 *  @param parameters          参数
 *  @param isFromHeaderRefresh 是否刷新
 */
- (void)asyncLoadDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters isFromHeaderRefresh:(BOOL)isFromHeaderRefresh{
    if ([self.ishaveNext boolValue]) {
        NSString *userId= [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        NSString *sessionId= [NSString stringWithFormat:@"%@",[NSGetTools getUserSessionId]];
        NSMutableString *idsStr=[NSMutableString string];
        if (isFromHeaderRefresh) {
            self.allModelArray = [NSMutableArray array];
            hArr = [[NSMutableArray alloc] init];
            wArr = [[NSMutableArray alloc] init];
        }
        for (DHUserInfoModel *model in self.allModelArray) {
            [idsStr appendString:[NSString stringWithFormat:@"%@",model.b80]];
            [idsStr appendString:@","];
        }
        
        
        NSLog(@"哈哈哈哈哈%@ ----%ld",idsStr,[self.allModelArray count]);
        if (url) {
            url = [NSString stringWithFormat:@"%@f_111_15_1.service?a117=%@&p1=%@&p2=%@",url,idsStr,sessionId,userId];
        }else{
            
            if ([idsStr length] == 0) {
                url = [NSString stringWithFormat:@"%@f_111_15_1.service?p2=%@&p1=%@",kServerAddressTest2,userId,sessionId];
            }else{
                url = [NSString stringWithFormat:@"%@f_111_15_1.service?a117=%@&p2=%@&p1=%@",kServerAddressTest2,idsStr,userId,sessionId];
            }
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // 设置请求格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        __block EyeLuckViewController *eyeVC=self;
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData *datas = responseObject;
            NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
            NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
            if ([infoDic[@"code"] integerValue] == 200) {
                NSArray *modelArr = infoDic[@"body"];
                NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
                [NSGetTools updateB96WithNum:b96];// 更新b96
                if ([b96 integerValue]==0) {
                    [self setValue:[NSNumber numberWithBool:NO] forKey:@"ishaveNext"];
                    
                }
                for (NSDictionary *dict2 in modelArr) {
                    DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                    if ([dict2 isKindOfClass:[NSDictionary class]]) {
                        [item setValuesForKeysWithDictionary:dict2];
                        if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                            [DHUserInfoDao insertUserToDBWithItem:item];
                            
                        }else{
                            [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
                        }
                        if ([item.b143 integerValue] != 3) {
                            [self.allModelArray addObject:item];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self.collectionView.mj_header endRefreshing];
                    [self addFooter];
                    
                });
            }else if([infoDic[@"code"] integerValue] == 500){
                
                if (self.isnetWroking) {
                    RefreshController *refre = [[RefreshController alloc] init];
                    [self presentViewController:refre animated:YES completion:nil];
                }else{
                    [self showHint:@"没有网络,还怎么浪~~"];
                }
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
            [self.collectionView.mj_footer endRefreshing];
            
            BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"apiName"];
            __block DHDomainModel *apiModel = nil;
            if (flag) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_2"];
                    NSDictionary * parameters = [NSGetTools getCLLocationData];
                    [self asyncLoadDataWithUrl:apiModel.api parameters:parameters isFromHeaderRefresh:NO];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apiName"];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (self.isnetWroking) {
                        RefreshController *refre = [[RefreshController alloc] init];
                        [self presentViewController:refre animated:YES completion:nil];
                    }else{
                        [self showHint:@"没有网络,还怎么浪~~"];
                    }
                    
//                    RefreshController *refre = [[RefreshController alloc] init];
//                    [self presentViewController:refre animated:YES completion:nil];
                });
            }else{
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_1"];
                    [[NSUserDefaults  standardUserDefaults] setBool:YES forKey:@"apiName"];
                    NSDictionary * parameters = [NSGetTools getCLLocationData];
                    [self asyncLoadDataWithUrl:apiModel.api parameters:parameters isFromHeaderRefresh:NO];
                });
            }
            
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer endRefreshing];
        });
        
    }
    
}
#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"*******************%ld",self.allModelArray.count);
    return self.allModelArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.allModelArray.count > 0) {
        // 模型
        DHUserInfoModel *model = self.allModelArray[indexPath.row];
        
        NSDictionary *localtionDict = [NSGetTools getCLLocationData];
        NSString *cityCode = [localtionDict objectForKey:@"a9"];
        
        CGFloat currentWidth = 0;
        CGFloat currentHeight = 0;
        if (wArr.count > indexPath.row) {
            currentWidth = [wArr[indexPath.row] floatValue];
            currentHeight = [hArr[indexPath.row] floatValue];
        }
        NSInteger xNum = indexPath.row/9;
        
        UICollectionViewCell *cell=nil;
        
        //重新定义cell位置、宽高
        if (indexPath.row%9 == 0) {
            _largeType = 1;
           
            DHEyeLuckyCell * cell_big = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_big" forIndexPath:indexPath];
            
            cell_big.nameLabel.text = model.b52;
            cell_big.ageLabel.text = [NSString stringWithFormat:@"%@岁",[model.b1 integerValue] == 0?@"18":model.b1];
            cell_big.rangeLabel.text = [NSString stringWithFormat:@"%.2fkm",[model.b94 floatValue]/1000];
            if ([model.b116 integerValue] == 1) {
                
                [cell_big.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_wcd_vip1.png"] forState:UIControlStateNormal];
            }else{
                [cell_big.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_cd_vip1.png"] forState:UIControlStateNormal];
            }
            [cell_big.starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_big.starButton.tag = indexPath.item;
            [cell_big.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            cell_big.backgroundColor = [UIColor whiteColor];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%ld",indexPath.item]];
            if ([model.b144 integerValue] == 1) {
                cell_big.vipImageV.hidden = NO;
            }else{
                cell_big.vipImageV.hidden = YES;
            }
            if ([cityCode integerValue] == [model.b9 integerValue]) {
                cell_big.rangeLabel.hidden = NO;
                cell_big.rangeimageV.hidden = NO;
            }else{
                cell_big.rangeLabel.hidden = YES;
                cell_big.rangeimageV.hidden = YES;
            }
            
            return cell_big;
        }
        if (indexPath.row%9 == 1 || indexPath.row%9 == 2){
            DHEyeLuckyRightCell *cell_right = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_right" forIndexPath:indexPath];
            cell_right.hidden = NO;
            //            if (indexPath.row%9 == 1){
            //                cell_right.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2))+KcellSpace,currentWidth,currentHeight+2*KcellSpace);
            //            }else{
            //                 cell_right.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2))+currentHeight+4*KcellSpace,currentWidth,currentHeight+2*KcellSpace);
            //            }
            [cell_right.starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_right.starButton.tag = indexPath.item;
            if ([model.b116 integerValue] == 1) {
                [cell_right.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_wcd1.png"] forState:UIControlStateNormal];
            }else{
                [cell_right.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_cd1.png"] forState:UIControlStateNormal];
            }
            cell_right.ageLabel.text = [NSString stringWithFormat:@"%@岁",[model.b1 integerValue] == 0?@"18":model.b1];
            cell_right.nameLabel.text = model.b52;
            cell_right.backgroundColor = [UIColor whiteColor];
            [cell_right.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            
            return cell_right;
        }
        // 心(1,2,3,4,5,6,7,8)
        if (indexPath.row%9 != 0) {
            DHEyeLuckyBottumCell * cell_bottum = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_bottum" forIndexPath:indexPath];
            
            [cell_bottum.starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell_bottum.starButton.tag = indexPath.item;
            
            if ([model.b116 integerValue] == 1) {
                [cell_bottum.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_wcd1.png"] forState:UIControlStateNormal];
            }else{
                [cell_bottum.starButton setImage:[UIImage imageNamed:@"w_shouye_wzbg_cd1.png"] forState:UIControlStateNormal];
            }
            [cell_bottum.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            cell_bottum.backgroundColor = [UIColor whiteColor];
            cell_bottum.nameLabel.text = model.b52;
            
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%ld",indexPath.item]];
            
            return cell_bottum;
        }
    }
    return nil;
}



#pragma mark --UICollectionViewDelegateFlowLayout

//////定义每个Item 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat cellWith = 0.0;
//    CGFloat cellHeight = 0.0;
//
//    if (indexPath.row%9 == 0) {
//        cellWith = KcellHeight*2+KcellHeight/8.0;
//        cellHeight = cellWith  ;
//    }else if (indexPath.row%9 == 1 || indexPath.row%9 == 2){
//        cellWith = KcellHeight;
//        cellHeight = KcellHeight ;
//    }else{
//        cellWith = KcellHeight;
//        cellHeight = KcellHeight;
//    }
//    [wArr addObject:[NSString stringWithFormat:@"%f",cellWith]];
//    [hArr addObject:[NSString stringWithFormat:@"%f",cellHeight]];
//    return  CGSizeMake(cellWith, cellHeight);  //设置cell宽高
//}
//
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5,5, 5, 5);
//}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allModelArray.count > 0) {
        DHUserInfoModel *model = self.allModelArray[indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            Homepage *otherVC = [[Homepage alloc]init];
            otherVC.touchP2 = model.b80;
            otherVC.item = model;
            JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:otherVC];
            [self presentViewController:nav animated:YES completion:nil];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHint:@"请稍后."];
        });
    }
}
#pragma mark 触动用户
// 红心被点击的时候
- (void)createRoom:(UIButton *)sender model:(DHUserInfoModel *)model{
    [self createRoomForTouch:model];
}
- (void)createRoomForTouch:(DHUserInfoModel *)model{
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",model.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",model.b52];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",@"1",@"a78", nil];
    [HttpOperation asyncGetMessagesOfMySelfWithPara:para completed:^(NSArray *messageArray) {
        if (messageArray.count > 0) {
            NSInteger random_index = [DHTool randomIndexWithMaxNumber:messageArray.count - 1  min:0];
            RobotMessageModel *randomMsg = nil;
            if (random_index <= messageArray.count - 1) {
                randomMsg = [messageArray objectAtIndex:random_index];
            }
            if (randomMsg && [randomMsg.b14 length] > 0 && ![randomMsg.b14 isEqualToString:@"(null)"]) {
                
                //是否触动
                if (![JYMoveUserDao checkSayHellWithTargetId:targetId userId:userId]) {
                    
                    //插入触动
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *dateTime=[[NSDate alloc]init];
                    model.sayHellTime=[dateFormatter stringFromDate:dateTime];
                    model.targetType=@"1";
                    [JYMoveUserDao insertSayHellListUserToDBWithItem:model];
                    
                    
                    NSString *token = [NSGetTools getToken];
                    NSDateFormatter *format = [[NSDateFormatter alloc]init];
                    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *date = [format stringFromDate:[NSDate date]];
                    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
                    [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
                    //    NSString *messageId = [format1 stringFromDate:[NSDate date]];
                    
                    DHMessageModel *item = [[DHMessageModel alloc]init];
                    NSString *messageId = [self configUUid];
                    item.messageId = messageId;
                    item.messageType = @"1";
                    
//                    NSDictionary *temp = [NSGetSystemTools getDefaultMessage];
//                    NSArray *arr = [temp allKeys];
//                    NSInteger index = (arc4random() % (arr.count - 1 - 0 + 1))+0;
//                    if (index <= 0 ) {
//                        index = 0;
//                    }else if (index >= arr.count - 1){
//                        index = arr.count - 1;
//                    }
//                    NSString *defaultMessage = [temp objectForKey:[arr objectAtIndex:index]];
                    item.message = randomMsg.b14;
                    
                    item.fromUserDevice = @"2";
                    item.fromUserAccount = userId;
                    item.token = token;
                    item.timeStamp = date;
                    item.toUserAccount = targetId;
                    item.userId = userId;
                    item.roomName = targetName;
                    item.targetId = [NSString stringWithFormat:@"%@",model.b80];
                    item.robotMessageType = @"-1";
                    item.isRead = @"2";
                    
                    item.fileUrl = @"";
                    item.length = 0;
                    item.fileName = @"";
                    item.addr = @"";
                    item.lat = 0;
                    item.lng = 0;
                    item.socketType = 1001;
                    //是否是机器人
                    if ([model.b143 integerValue] ==1) {
                        [SocketManager asyncSendMessageWithMessageModel:item];
                    }
                    
                    if (![DHMessageDao checkMessageWithMessageId:messageId targetId:item.targetId]) {
                        [DHMessageDao insertMessageDataDBWithModel:item userId:userId];
                    }
                    // 回调反馈发给哪个机器人
                    if ([model.b143 integerValue] == 2) {
                        NSArray *msgArr = [DHMessageDao getRobotChatListWithUserId:model.b80];
                        DHMessageModel *lastMessage = [msgArr lastObject];
                        NSString *type = nil;
                        if (!lastMessage) {
                            type = @"1";
                        }else{
                            type = lastMessage.robotMessageType;
                        }
                        [Mynotification postNotificationName:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:item];
                    }
                }
                
                
            }
        }
    }];
    
    
    
    
}

- (void)starButtonAction:(UIButton *)sender{
    DHUserInfoModel *model = self.allModelArray[sender.tag];
    BOOL isBtnSelected = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%ld",sender.tag]];
    
    NSString *imageName = nil;
    // 会员，与普通用户图片不一样
    if ([model.b116 integerValue] == 1) {
        if (sender.tag%9 == 0) {
            imageName = @"w_shouye_wzbg_cd_vip1.png";
        }else{
            imageName = @"w_shouye_wzbg_cd1.png";
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self uploadShakeInfo:model];
        });
        [self createRoom:sender model:model];
        model.b116 = @"0";
        [DHUserInfoDao updateUserToDBWithItem:model userId:model.b80];
    }else{
        if (sender.tag%9 == 0) {
            imageName = @"w_shouye_wzbg_wcd_vip1.png";
        }else{
            imageName = @"w_shouye_wzbg_wcd1.png";
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self delelteShakeInfo:model];
        });
        model.b116 = @"1";
        [DHUserInfoDao updateUserToDBWithItem:model userId:model.b80];
    }
   
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _largeType = 0;
    
}
/**
 *  上传我触动谁LP-bus-msc/f_105_10_2.service？a77：被关注用户
 *  @param model
 */
- (void)uploadShakeInfo:(DHUserInfoModel *)model{
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = nil;
    NSString *a34 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"b34-%@",model.b80]];
    if ([a34 integerValue] == 0) {
        url = [NSString stringWithFormat:@"%@f_105_10_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,model.b80,sessionId,userId,str];
    }else{
        url = [NSString stringWithFormat:@"%@f_105_10_2.service?a34=%@&a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,a34,model.b80,sessionId,userId,str];
    }
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
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *b34 = [[infoDic objectForKey:@"body"] objectForKey:@"b34"];
                [[NSUserDefaults standardUserDefaults] setObject:b34 forKey:[NSString stringWithFormat:@"b34-%@",model.b80]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showHint:@"已触动！"];
                });
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
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
}
- (void)delelteShakeInfo:(DHUserInfoModel *)model{
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_105_12_3.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,model.b80,sessionId,userId,str];
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
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"取消触动！"];
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
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
}

////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 系统VIP信息
- (void)getDataArr{
    //NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service",kServerAddressTest2];
//    __weak typeof (&*self) weakSelf =self;
//    [HttpOperation asyncGetVipListWithType:0 goodsCode:0 catagery:1 queue:dispatch_get_main_queue() completed:^(NSArray *vipArr, NSInteger code) {
//        NSLog(@"%@",vipArr);
//    }];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:@1 forKey:@"a188"];
    NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service?p1=%@&p2=%@",kServerAddressTest2,p1,p2];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *bodyArr = infoDic[@"body"];
            [NSGetTools updateSystemGoodsInfo:bodyArr];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
    
}
#pragma mark 系统参数请求
// 系统参数请求  http://115.236.55.163:8086/LP-bus-msc/f_101_10_1.service
- (void)getSystemDataInfos
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_101_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block EyeLuckViewController *SystemVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *sysArray = infoDic[@"body"];
            
            for (NSDictionary *dict in sysArray) {
                
                NSArray *b98Arr = dict[@"b98"];
                //                DHSystemDataModel *model = nil;
                //                for (NSDictionary *temp in b98Arr) {
                //                    DHSystemDataModel *model = [[DHSystemDataModel alloc]init];
                //                    [model setValuesForKeysWithDictionary:temp];
                //                    model.b20Catagery = [dict objectForKey:@"b20"];
                //                    if (![DBManager checkSystemDataWithUsertId:p2 b20Key:model.b20]) {
                //                        [DBManager insertSystemDataToDBWithItem:model userId:p2];
                //                    }
                //                }
                
                
                // 默认消息
                if ([dict[@"b20"] isEqualToString:@"default_message"]) {
                    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b72"]];
                        [messageDict setValue:dict2[@"b22"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateDefaultMessageWithDict:messageDict];
                }else if ([dict[@"b20"] isEqualToString:@"charmPart"]){// 魅力部位
                    NSMutableDictionary *charmPartDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [charmPartDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatecharmPartWithDict:charmPartDict];
                }else if ([dict[@"b20"] isEqualToString:@"marriageStatus"]){// 婚状态
                    NSMutableDictionary *marriageStatusDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marriageStatusDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarriageStatusWithDict:marriageStatusDict];
                    
                    
                }else if ([dict[@"b20"] isEqualToString:@"marriageStatus_personal"]){// 搜索的婚状态
                    NSMutableDictionary *marriageStatusDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marriageStatusDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools searchUpdatemarriageStatusWithDict:marriageStatusDict];
                    
                    
                }else if ([dict[@"b20"] isEqualToString:@"marrySex"]){// 婚前行为
                    NSMutableDictionary *marrySexDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marrySexDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarrySexWithDict:marrySexDict];
                }else if ([dict[@"b20"] isEqualToString:@"profession"]){//职业
                    NSMutableDictionary *professionDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [professionDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateprofessionDict:professionDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-2"]){// 喜欢的类型(女)
                    NSMutableDictionary *loveType2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType2Dict:loveType2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasLoveOther"]){// 异地恋
                    NSMutableDictionary *hasLoveOtherDict = [NSMutableDictionary dictionary];
                    
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasLoveOtherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasLoveOtherWithDict:hasLoveOtherDict];
                }else if ([dict[@"b20"] isEqualToString:@"star"]){// 星座
                    NSMutableDictionary *starDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [starDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatestarWithDict:starDict];
                }else if ([dict[@"b20"] isEqualToString:@"liveTogether"]){// 住一起
                    NSMutableDictionary *liveTogetherDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [liveTogetherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateliveTogetherWithDict:liveTogetherDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-1"]){// 喜欢的类型(男)
                    NSMutableDictionary *loveType1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType1WithDict:loveType1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"purpose"]){// 交友目的
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatepurposeWithDict:purposeDict];
                }else if ([dict[@"b20"] isEqualToString:@"blood"]){// 血型
                    NSMutableDictionary *bloodDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [bloodDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatebloodWithDict:bloodDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasCar"]){// 车子
                    NSMutableDictionary *hasCarDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasCarDict setValue:dict2[@"b21"] forKey:keyStr];
                        
                    }
                    //                    NSLog(@"%@",hasCarDict);
                    // 保存
                    [NSGetSystemTools updatehasCarWithDict:hasCarDict];
                }else if ([dict[@"b20"] isEqualToString:@"educationLevel"]){
                    NSMutableDictionary *educationLevelDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [educationLevelDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateeducationLevelWithDict:educationLevelDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasChild"]){
                    NSMutableDictionary *hasChildDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasChildDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasChildWithDict:hasChildDict];
                }else if ([dict[@"b20"] isEqualToString:@"system_pm"]){
                    NSMutableDictionary *system_pmDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [system_pmDict setValue:dict2[@"b21"] forKey:keyStr];
                        if ([[dict2 objectForKey:@"b20"] isEqualToString:@"system_advance"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"Promotion"];
                        }
                    }
                    // 保存
                    [NSGetSystemTools updatesystem_pmWithDict:system_pmDict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-2"]){
                    NSMutableDictionary *favorite2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite2WithDict:favorite2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-1"]){
                    NSMutableDictionary *favorite1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite1WithDict:favorite1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-1"]){
                    NSMutableDictionary *kidney1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney1WithDict:kidney1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-2"]){
                    NSMutableDictionary *kidney2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney2WithDict:kidney2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasRoom"]){
                    NSMutableDictionary *hasRoomDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasRoomDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasRoomWithDict:hasRoomDict];
                }else if ([dict[@"b20"] isEqualToString:@"timestem"]){
                    NSMutableDictionary *timestemDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        
                        [timestemDict setValue:dict2[@"b22"] forKey:dict2[@"b20"]];
                    }
                    // 保存
                    [NSGetSystemTools updatetimestemWithDict:timestemDict];
                }else if ([dict[@"b20"] isEqualToString:@"lp_pay_way"]){
                    NSMutableDictionary *timestemDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [timestemDict setValue:dict2[@"b22"] forKey:dict2[@"b20"]];
                    }
                    // 保存
                    //                    [NSGetSystemTools updatetimestemWithDict:timestemDict];
                    [[NSUserDefaults standardUserDefaults] setObject:timestemDict forKey:@"lp_pay_way"];
                }else if ([dict[@"b20"] isEqualToString:@"report-1"]){
                    NSMutableDictionary *reportDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [reportDict setValue:dict2[@"b21"] forKey:dict2[@"b22"]];
                    }
                    // 保存
                    [NSGetSystemTools updatereport1WithDict:reportDict];
                    
                }else if ([dict[@"b20"] isEqualToString:@"country_tips_set"]){
                    NSMutableDictionary *reportDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [reportDict setValue:dict2[@"b21"] forKey:dict2[@"b22"]];
                    }
                    // 保存
                    [[NSUserDefaults standardUserDefaults] setObject:b98Arr forKey:@"recommed_system_data"];
                    //                    [NSGetSystemTools updatereport1WithDict:reportDict];
                }else if([dict[@"b20"] isEqualToString:@"system_pay_message"]){
#warning mark 获取引导支付账号
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults removeObjectForKey:@"messages_user_id"];
                    [userDefaults synchronize];
                    
                    for (NSDictionary *dict2 in b98Arr) {
                        NSUserDefaults *userDefaultstwo = [NSUserDefaults standardUserDefaults];
                        [userDefaultstwo setObject:dict2[@"b22"] forKey:dict2[@"b20"]];
                        [userDefaultstwo synchronize];
                    }
                    
                    //请求官方支付账号
                    NSString *officialID = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
                    
                    if (![DHUserInfoDao checkUserWithUsertId:officialID]) {
                        [SystemVC getTargetUserInfoWithUserId:officialID];
                    }else{
                        //已经有支付小助手
                        NSNumber *sexNum = [NSGetTools getUserSexInfo];
                        if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 1男2女
                            [Mynotification postNotificationName:@"pushPayNotificationWhenUserLogin" object:@(6)];
                        }
                        
                        [Mynotification postNotificationName:@"pushPayNotificationWhenUserLogin" object:@(5)];
                    }
                    
                }else if([dict[@"b20"] isEqualToString:@"dating_purpose"]){//20160630--新的交友目的
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatedatingPurposeWithDict:purposeDict];
                }else if([dict[@"b20"] isEqualToString:@"indulged"]){//20160630--恋爱观
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateIndulgedWithDict:purposeDict];
                }else if([dict[@"b20"] isEqualToString:@"meet_place"]){//20160630--首次见面希望
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateMeetPlaceWithDict:purposeDict];
                }else if([dict[@"b20"] isEqualToString:@"love_place"]){//20160630--爱爱地点
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatelovePlaceWithDict:purposeDict];
                }
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
}
#pragma mark 请求本用户信息
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
- (void)shouMessageToustView:(NSNotification *)notifi{
    DHMessageModel *message = notifi.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [DHMessageToustView asyncConfigToustViewWithMessage:message inview:self.view delegate:self showFrame:^(CGRect showFrame) {
            CGRect superFrame = self.collectionView.frame;
            if (superFrame.origin.y>CGRectGetMaxY(showFrame)) {
                
            }else{
                superFrame.origin.y = CGRectGetMaxY(showFrame)+0;
                self.collectionView.frame = superFrame;
            }
            
        } hideFrame:^(CGRect hideFrame) {
            CGRect superFrame = self.collectionView.frame;
            if (superFrame.origin.y>CGRectGetMaxY(hideFrame)) {
                if (superFrame.origin.y==44) {
                    superFrame.origin.y = 0;
                    
                    self.collectionView.frame = superFrame;
                }
            }else{
                superFrame.origin.y = CGRectGetMaxY(hideFrame)+0;
                
                self.collectionView.frame = superFrame;
            }
            
        }];
        
    });
}
- (void)onClicked{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 2;
    });
}
#pragma mark 得到用户信息
- (void)getTargetUserInfoWithUserId:(NSString *)userId{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    //    LP-bus-msc/ f_108_13_1
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,sessionId,userId,appinfoStr];
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
            NSArray *temp =[dict2 objectForKey:@"b113"];
            if (temp.count>0) {
                [item setValuesForKeysWithDictionary:[[dict2 objectForKey:@"b113"] objectAtIndex:0]];
            }
            if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                [DHUserInfoDao insertUserToDBWithItem:item];
                NSString *officialID = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
                if ([officialID integerValue] == [item.b80 integerValue]) {
                    [Mynotification postNotificationName:@"pushPayNotificationWhenUserLogin" object:@(6)];
                    [Mynotification postNotificationName:@"pushPayNotificationWhenUserLogin" object:@(5)];
                }
                
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}
#pragma mark 用户保持
// 用户保持
- (void)userOnLineMethod
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *url = [NSString stringWithFormat:@"%@f_120_12_1.service?p1=%@&p2=%@",kServerAddressTest4,p1,p2];
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
        if ([infoDic[@"code"] integerValue] == 200) {
            NSLog(@"在线");
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [self presentViewController:refre animated:YES completion:nil];
        }else{
            NSString *msgStr = infoDic[@"msg"];
            [NSGetTools showAlert:msgStr];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        [NSGetTools showAlert:@"网络不佳或已掉线"];
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
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
