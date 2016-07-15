//
//  Homepage.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "Homepage.h"
#import "MyPhotoViewController.h"
#import "DHUserAlbumModel.h"
#import "ChatController.h"
#import "HFVipViewController.h"
#import "TempHFController.h"
#import "YS_ApplePayVipViewController.h"
#import <MapKit/MapKit.h>
#import "YS_SelfPayViewController.h"
#import "RefreshController.h"
#import "JYSayHelloDao.h"
#import "JYMoveUserDao.h"
#import "JYNavigationController.h"

@interface Homepage ()<UITableViewDataSource,UITableViewDelegate,AssetsCellDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    
    UITableView *paraTabelView;
    NSString *contentStr;
    NSMutableString *marriageStr;
    NSMutableString *makeFriendStr;
    NSMutableString *myselfInfoStr;//自我介绍
    CGFloat h;
    CGFloat marriageHige;
    CGFloat makeFriend;
    CGFloat myselfInfoHeight;
    NSNumber *VipNum;
    
}
@property (nonatomic,strong)NSArray *basicArray;
@property (nonatomic,strong)NSArray *vipAssetsArray;
@property (nonatomic,strong)NSMutableArray *allData;
@property (nonatomic,strong)NSMutableArray *conditonArray;
/**
 *  相册数组
 */
@property (nonatomic,strong) NSMutableArray *albumArr;
@property (nonatomic,strong) UIButton *heartButton;
@property (nonatomic,strong) UIView *heartView;
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) NSString *heartFlag;
//坐标
@property (nonatomic,strong)CLLocationManager *LocationManager;
@property (nonatomic,strong)CLGeocoder *geocoder;
//城市
@property (nonatomic,strong)NSString *cityname;
//导航条
@property (nonatomic,strong)JYNavigationController *nav;
//透明度
@property (nonatomic,assign)CGFloat alphaNum;
//大尺度数组
@property (nonatomic,strong)NSMutableArray *temptationArray;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation Homepage

- (NSArray *)basicArray {

    return @[@"基本资料",@"身高",@"体重",@"婚姻状况",@"学历",@"星座",@"职业"];
}

- (NSArray *)vipAssetsArray {
    
    return @[@"资产信息",@"月收入",@"房产",@"车产"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.nav setNavigationBarBackgroundImage:@"w_wo_grzy_xpmb" andAlph:self.alphaNum];
    dispatch_async(dispatch_get_main_queue(), ^{
        [paraTabelView reloadData];
    });
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [self.nav setAlph:self.alphaNum];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人主页";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    //导航条
    self.nav = (JYNavigationController *)self.navigationController;
    //透明度
    self.alphaNum=0.0;
    [self.nav setAlph:self.alphaNum];
    [self.nav setNavigationBarBackgroundImage:@"w_wo_grzy_xpmb"];
    
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.allData       = [NSMutableArray array];
    self.conditonArray = [NSMutableArray array];
    self.itemArray     = [NSMutableArray array];
    self.temptationArray = [NSMutableArray array];
    
    self.heartFlag =@"1";
    if (self.item==nil) {
        self.item =[[DHUserInfoModel alloc]init];
    }
    [self.itemArray addObject:self.item];
    
    self.albumArr = [NSMutableArray array];
    myselfInfoStr = [[NSMutableString alloc]init];
    marriageStr = [[NSMutableString alloc]init];
    makeFriendStr = [[NSMutableString alloc]init];
//    //定位
//    self.cityname=@"保密";
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    if ([userId isEqualToString:self.touchP2]) {
//        //开始定位
//        self.LocationManager = [[CLLocationManager alloc]init];
//        [self willGetUserLocationInfo];
//        self.LocationManager.delegate = self;
//        self.LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        self.LocationManager.distanceFilter = 10.0;
//        [self.LocationManager startUpdatingLocation];
//    }
    
//    NSDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"] objectForKey:@"b112"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
//    NSLog(@"%@",[dict objectForKey:@"b144"]);
    VipNum= [NSNumber numberWithInteger:[userInfo.b144 integerValue]];
//    [dict objectForKey:@"b144"];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
    [self addObserver:self forKeyPath:@"heartFlag" options:(NSKeyValueObservingOptionNew) context:nil];
    
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    if (![userId isEqualToString:self.touchP2]) {
        [self setButtonView];
        [self uoloadLookMeInfo:self.touchP2];
    }
    
    [Mynotification addObserver:self selector:@selector(refurbishUserInfo) name:@"refurbishUserInfo" object:nil];
    [self p_setupProgressHud];
    [self layoutParallax];
    if ([_item.b143 integerValue]==5) {
//        NSLog(@"动态机器人,开始加载了...................");
        [self afnetOfRobot];
    }else{
//        NSLog(@"普通人,开始加载了...................");
        [self afnet];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
- (void)refurbishUserInfo{
    [paraTabelView reloadData];
}
//保存谁看过我
/**
 *  保存谁看过我： LP-bus-msc/ f_109_11_2.service ？a77：被查看用户ID
 *
 *  @param model
 */
- (void)uoloadLookMeInfo:(NSString *)touchP2{
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,touchP2,sessionId,userId,str];
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
                //              [self showHint:@"看过看过"];
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
- (void)setButtonView{
    self.heartView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.size.width, 49)];
    self.heartView.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.680];
    self.heartButton=[[UIButton alloc] initWithFrame:CGRectMake(18, 4, CGRectGetMidX(self.view.frame)-18*2, 40)];
    
    self.heartButton.layer.masksToBounds=YES;
    self.heartButton.layer.cornerRadius=20;
    self.heartButton.backgroundColor=[UIColor whiteColor];
    [self.heartButton setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
    [self.heartButton setTitle:@"触动" forState:(UIControlStateNormal)];

    
    [self.heartView addSubview:self.heartButton];
    UIButton *butt2=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)+18, 4, CGRectGetMidX(self.view.frame)-18*2, 40)];
    butt2.backgroundColor=[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
    butt2.layer.masksToBounds=YES;
    butt2.layer.cornerRadius=20;
    [butt2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [butt2 setTitle:@"发消息" forState:(UIControlStateNormal)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    if (![userId isEqualToString:self.touchP2]) {
        [butt2 addTarget:self action:@selector(getChatTapAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.heartButton addTarget:self action:@selector(touchHeartTapAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [self.heartView addSubview:butt2];
    
}

- (void)leftAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"heartFlag"]) {
        if ([self.heartFlag integerValue]==0) {
            self.heartButton.backgroundColor=[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
            [self.heartButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self.heartButton setTitle:@"已触动" forState:(UIControlStateNormal)];
        }else{
            self.heartButton.backgroundColor=[UIColor whiteColor];
            [self.heartButton setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
            [self.heartButton setTitle:@"触动" forState:(UIControlStateNormal)];
            
            
        }
        [object removeObserver:self forKeyPath:@"heartFlag"];
    }
}
#pragma mark ---- 获取动态机器人数据
- (void)afnetOfRobot{
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSDictionary *locationDict = [NSGetTools getCLLocationData];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
    NSString *url = [NSString stringWithFormat:@"%@f_108_19_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,self.touchP2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    __weak Homepage *homevc=self;
    
    [manger GET:url parameters:temp success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        //         NSLog(@"zong字典-----:%@",infoDic);
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            //            NSLog(@"字典-----:%@",dict2);
            for (NSString *key in dict2) {
                
                
#pragma mark ----- b114择友条件
                if ([key isEqualToString:@"b114"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    NConditonModel *condit = [[NConditonModel alloc] init];
                    if (Valuedic[@"b1"] == nil) {
                        condit.age = @"";
                    }else {
                        condit.age     = [NSString stringWithFormat:@"年龄范围:%@",Valuedic[@"b1"]];  // 年龄
                    }
                    if (Valuedic[@"b85"] == nil) {
                        condit.wage = @"";
                    }else {
                        condit.wage    = [NSString stringWithFormat:@"收入范围:%@",Valuedic[@"b85"]];  // 收入范围
                    }
                    if (Valuedic[@"b33"] == nil) {
                        condit.heights = @"";
                    }else {
                        condit.heights = [NSString stringWithFormat:@"身高范围:%@",Valuedic[@"b33"]];    // b33  身高
                    }
                    
                    
                    if ([dict2 objectForKey:@"b112"][@"b9"] == nil) {
                        condit.city = @"";
                    }else {
                        condit.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"b112"][@"b9"]]];  // b9   居住地(市)
                    }
                    if ([dict2 objectForKey:@"b112"][@"b67"] == nil || MyJudgeNull(([self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"b112"][@"b67"]]]))) {
                        condit.proVince = @"";
                    }else {
                        condit.proVince = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"b112"][@"b67"]]]; // b67  居住地(省)
                    }
                    
                    
                    if (Valuedic[@"b19"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]))) {
                        condit.education = @"";
                    }else {
                        condit.education  = [NSString stringWithFormat:@"学历:%@",[self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]]; // b19  学历
                    }
                    if (Valuedic[@"b46"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]))) {
                        condit.marriage = @"";
                    }else {
                        condit.marriage = [NSString stringWithFormat:@"婚姻状况:%@",[self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]];
                    }
                    
                    [self.conditonArray addObject:condit];
                    
                    [self setFriend:condit];
                }
                
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    
                    NHome *homeModel = [[NHome alloc] init];
                    homeModel.weight     = Valuedic[@"b88"];    // b88  体重
                    homeModel.height     = Valuedic[@"b33"];    // b33  身高
                    homeModel.wageMax    = Valuedic[@"b86"];    // b86  月收入最大值
                    homeModel.wageMin    = Valuedic[@"b87"];    // b87  月收入最小值
                    homeModel.photoUrl   = Valuedic[@"b57"];    // 头像
                    homeModel.photoStatus= Valuedic[@"b142"];   // 头像审核  1通过 2等待审核 3未通过
                    homeModel.age        = Valuedic[@"b1"];     // 年龄
                    homeModel.vip        = Valuedic[@"b144"];   // vip 1yes 2no
                    VipNum = Valuedic[@"b144"];
                    homeModel.describe   = Valuedic[@"b17"];    // 交友宣言
                    homeModel.d1Status   = Valuedic[@"b118"];   // 交友宣言审核  1通过 2等待审核 3未通过
                    homeModel.systemName = Valuedic[@"b152"];   // 用户系统编号
                    homeModel.id         = Valuedic[@"b34"];    // ID
                    homeModel.nickName   = Valuedic[@"b52"];    // b52  昵称
                    homeModel.status     = Valuedic[@"b75"];   // 昵称审核  1通过 2等待审核 3未通过
                    homeModel.sex        = Valuedic[@"b69"];    // b69  性别 1 男 2女
                    homeModel.userId     = Valuedic[@"b80"];    // b80  用户id 不能为空
                    homeModel.purpose     = Valuedic[@"b145"];    // b145 意向
                    homeModel.userType     = Valuedic[@"b143"];    // b143 1注册用户2机器人
                    homeModel.wx = Valuedic[@"b157"];//微信
                    homeModel.wxStatus=Valuedic[@"b159"];//微信状态
                    homeModel.qq = Valuedic[@"b156"];//qq
                    homeModel.qqStatus = Valuedic[@"b158"];//QQ显示状态  1:显示 2：隐藏
                    
                    NSString *bornDay    = Valuedic[@"b4"];     // b4   出生日期
                    NSArray *yearArray   = [bornDay componentsSeparatedByString:@"-"];
                    homeModel.birthday   = [NSString stringWithFormat:@"%@年%@月%@日",yearArray[0],yearArray[1],yearArray[2]];
                    NSString *logTime    = Valuedic[@"b44"];    // b44  登陆时间
                    if (logTime) {
                        NSArray *loginArray  = [logTime componentsSeparatedByString:@":"];
                        homeModel.loginTime  = [NSString stringWithFormat:@"%@:%@",loginArray[0],loginArray[1]];
                    }else{
                        homeModel.loginTime = @"1999-01-01 00:00";
                    }
                    
                    
                    //                    NSNumber *sexNum = [NSGetTools getUserSexInfo];
                    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
                    if ([userInfo.b69 integerValue] == 1) { // 1男2女
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType1] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }else {
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType2] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }
                    homeModel.charmPart = [self addWithVariable:[NSGetSystemTools getcharmPart] keyStr:Valuedic[@"b8"]];  // b8   魅力部位
                    if (Valuedic[@"b39"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getliveTogether] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]))) { // b39  和父母同住
                        homeModel.together = @"";
                    }else {
                        homeModel.together = [NSString stringWithFormat:@"%@和父母同住",[self addWithVariable:[NSGetSystemTools getliveTogether]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b39"]]]];
                    }
                    if (Valuedic[@"b47"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]))) { // b47  婚姻性行为
                        homeModel.marrySex = @"";
                    }else {
                        homeModel.marrySex = [NSString stringWithFormat:@"%@婚前性行为",[self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]];
                        
                    }
                    homeModel.marriage   = [self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]; // b46  婚姻状况
                    homeModel.education  = [self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]; // b19  学历
                    homeModel.star       = [self addWithVariable:[NSGetSystemTools getstar]           keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b74"]]]; // b74  星座 1-12
                    if (Valuedic[@"b30"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]))) {
                        homeModel.hasChild = @"";
                    }else {
                        homeModel.hasChild = [NSString stringWithFormat:@"%@孩子",[self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]];
                    } // b30  是否想要小孩
                    if (Valuedic[@"b31"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools gethasLoveOther] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]))) {
                        homeModel.LoveOther = @"";
                    }else {
                        homeModel.LoveOther = [NSString stringWithFormat:@"%@异地恋",[self addWithVariable:[NSGetSystemTools gethasLoveOther]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]];
                        
                    }
                    homeModel.hasRoom    = [self addWithVariable:[NSGetSystemTools gethasRoom]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b32"]]]; // b32  是否有房
                    homeModel.hasCar     = [self addWithVariable:[NSGetSystemTools gethasCar]         keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b29"]]]; // b29  是否有车
                    homeModel.profession = [self addWithVariable:[NSGetSystemTools getprofession]     keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b62"]]]; // b62  职业
                    homeModel.blood      = [self addWithVariable:[NSGetSystemTools getblood]          keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b5"]]];  //  b5   血型
                    homeModel.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                    homeModel.province = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                    [homevc.allData addObject:homeModel];
                    
                    [homevc setUserInfo:homeModel];
                    [homevc setMarage:homeModel];
                    
#pragma mark 大尺度信息
                    
                    [homevc.temptationArray removeAllObjects];
                    NSString *datingPurposeStr = [self addWithVariable:[NSGetSystemTools getdatingPurpose]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b194"]]]; // b194 交友目的
                    if (!MyJudgeNull(datingPurposeStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:datingPurposeStr,@"交友目的", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    
                    NSString *indulgedStr = [self addWithVariable:[NSGetSystemTools getIndulged]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b195"]]]; // b195 恋爱观
                    if (!MyJudgeNull(indulgedStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indulgedStr,@"恋爱观", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    NSString *meetPlaceStr = [self addWithVariable:[NSGetSystemTools getmeetPlace]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b196"]]]; // b196 约会干嘛
                    if (!MyJudgeNull(meetPlaceStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:meetPlaceStr,@"首次见面希望", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    NSString *lovePlaceStr = [self addWithVariable:[NSGetSystemTools getlovePlace]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b197"]]]; // b197 爱爱地点
                    if (!MyJudgeNull(lovePlaceStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:lovePlaceStr,@"喜欢爱爱的地点", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                }else if ([key isEqualToString:@"b113"]){
                    NSArray *arr = [dict2 objectForKey:@"b113"];
                    for (NSDictionary *dict in arr) {
                        DHUserAlbumModel *item = [[DHUserAlbumModel alloc]init];
                        [item setValuesForKeysWithDictionary:dict];
                        [self.albumArr addObject:item];
                    }
                }else if([key isEqualToString:@"b116"]){
                    [homevc setValue:[dict2 objectForKey:@"b116"] forKey:@"heartFlag"];
                }
                #pragma mark 大尺度信息
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [paraTabelView reloadData];
                [self hideHud];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"系统参数请求失败--%@-",error);
        
    }];
}
#pragma mark ---- 获取普通用户和机器人数据
- (void)afnet {

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,self.touchP2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    __weak Homepage *homevc=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//         NSLog(@"zong字典-----:%@",infoDic);
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
//            NSLog(@"字典-----:%@",dict2);
            for (NSString *key in dict2) {
                
                
#pragma mark ----- b114择友条件
                if ([key isEqualToString:@"b114"]) {
                     NSDictionary *Valuedic = [dict2 objectForKey:key];
                    NConditonModel *condit = [[NConditonModel alloc] init];
                    if (Valuedic[@"b1"] == nil) {
                        condit.age = @"";
                    }else {
                        condit.age     = [NSString stringWithFormat:@"年龄范围:%@",Valuedic[@"b1"]];  // 年龄
                    }
                    if (Valuedic[@"b85"] == nil) {
                        condit.wage = @"";
                    }else {
                        condit.wage    = [NSString stringWithFormat:@"收入范围:%@",Valuedic[@"b85"]];  // 收入范围
                    }
                    if (Valuedic[@"b33"] == nil) {
                        condit.heights = @"";
                    }else {
                        condit.heights = [NSString stringWithFormat:@"身高范围:%@",Valuedic[@"b33"]];    // b33  身高
                    }
                    
                    if ([[dict2 objectForKey:@"b112"][@"b143"] integerValue] == 2) {
                        //机器人
                        condit.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"b112"][@"b9"]]];  // b9   居住地(市)
                        
                        condit.proVince = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"b112"] [@"b67"]]]; // b67  居住地(省)
                        
                    }else{
                        //用户
                        if (Valuedic[@"b9"] == nil) {
                            condit.city = @"";
                        }else {
                            condit.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                        }
                        if (Valuedic[@"b67"] == nil || MyJudgeNull(([self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]))) {
                            condit.proVince = @"";
                        }else {
                            condit.proVince = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                        }
                    }
                    
                    
                    if (Valuedic[@"b19"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]))) {
                        condit.education = @"";
                    }else {
                        condit.education  = [NSString stringWithFormat:@"学历:%@",[self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]]; // b19  学历
                    }
                    if (Valuedic[@"b46"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]))) {
                        condit.marriage = @"";
                    }else {
                        condit.marriage = [NSString stringWithFormat:@"婚姻状况:%@",[self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]];
                    }
                    
                    [self.conditonArray addObject:condit];
                    
                    [self setFriend:condit];
                }
                
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    
                    NHome *homeModel = [[NHome alloc] init];
                    homeModel.weight     = Valuedic[@"b88"];    // b88  体重
                    homeModel.height     = Valuedic[@"b33"];    // b33  身高
                    homeModel.wageMax    = Valuedic[@"b86"];    // b86  月收入最大值
                    homeModel.wageMin    = Valuedic[@"b87"];    // b87  月收入最小值
                    homeModel.photoUrl   = Valuedic[@"b57"];    // 头像
                    homeModel.photoStatus= Valuedic[@"b142"];   // 头像审核  1通过 2等待审核 3未通过
                    homeModel.age        = Valuedic[@"b1"];     // 年龄
                    homeModel.vip        = Valuedic[@"b144"];   // vip 1yes 2no
                    VipNum = Valuedic[@"b144"];
                    homeModel.describe   = Valuedic[@"b17"];    // 交友宣言
                    homeModel.d1Status   = Valuedic[@"b118"];   // 交友宣言审核  1通过 2等待审核 3未通过
                    homeModel.systemName = Valuedic[@"b152"];   // 用户系统编号
                    homeModel.id         = Valuedic[@"b34"];    // ID
                    homeModel.nickName   = Valuedic[@"b52"];    // b52  昵称
                    homeModel.status     = Valuedic[@"b75"];   // 昵称审核  1通过 2等待审核 3未通过
                    homeModel.sex        = Valuedic[@"b69"];    // b69  性别 1 男 2女
                    homeModel.userId     = Valuedic[@"b80"];    // b80  用户id 不能为空
                    homeModel.purpose     = Valuedic[@"b145"];    // b145 意向
                    homeModel.userType     = Valuedic[@"b143"];    // b143 1注册用户2机器人
                    homeModel.wx = Valuedic[@"b157"];//微信
                    homeModel.wxStatus=Valuedic[@"b159"];//微信状态
                    homeModel.qq = Valuedic[@"b156"];//qq
                    homeModel.qqStatus = Valuedic[@"b158"];//QQ显示状态  1:显示 2：隐藏
                    
                    NSString *bornDay    = Valuedic[@"b4"];     // b4   出生日期
                    NSArray *yearArray   = [bornDay componentsSeparatedByString:@"-"];
                    homeModel.birthday   = [NSString stringWithFormat:@"%@年%@月%@日",yearArray[0],yearArray[1],yearArray[2]];
                    NSString *logTime    = Valuedic[@"b44"];    // b44  登陆时间
                    if (logTime) {
                        NSArray *loginArray  = [logTime componentsSeparatedByString:@":"];
                        homeModel.loginTime  = [NSString stringWithFormat:@"%@:%@",loginArray[0],loginArray[1]];
                    }else{
                        homeModel.loginTime = @"1999-01-01 00:00";
                    }
                    
                    
//                    NSNumber *sexNum = [NSGetTools getUserSexInfo];
                    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
                    if ([userInfo.b69 integerValue] == 1) { // 1男2女
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType1] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }else {
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType2] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }
                    homeModel.charmPart = [self addWithVariable:[NSGetSystemTools getcharmPart] keyStr:Valuedic[@"b8"]];  // b8   魅力部位
                    if (Valuedic[@"b39"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getliveTogether] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]))) { // b39  和父母同住
                        homeModel.together = @"";
                    }else {
                        homeModel.together = [NSString stringWithFormat:@"%@和父母同住",[self addWithVariable:[NSGetSystemTools getliveTogether]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b39"]]]];
                    }
                    if (Valuedic[@"b47"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]))) { // b47  婚姻性行为
                        homeModel.marrySex = @"";
                    }else {
                        homeModel.marrySex = [NSString stringWithFormat:@"%@婚前性行为",[self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]];
                        
                    }
                    homeModel.marriage   = [self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]; // b46  婚姻状况
                    homeModel.education  = [self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]; // b19  学历
                    homeModel.star       = [self addWithVariable:[NSGetSystemTools getstar]           keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b74"]]]; // b74  星座 1-12
                    if (Valuedic[@"b30"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]))) {
                        homeModel.hasChild = @"";
                    }else {
                        homeModel.hasChild = [NSString stringWithFormat:@"%@孩子",[self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]];
                    } // b30  是否想要小孩
                    if (Valuedic[@"b31"] == nil || MyJudgeNull(([self addWithVariable:[NSGetSystemTools gethasLoveOther] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]))) {
                        homeModel.LoveOther = @"";
                    }else {
                        homeModel.LoveOther = [NSString stringWithFormat:@"%@异地恋",[self addWithVariable:[NSGetSystemTools gethasLoveOther]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]];
                        
                    }
                    homeModel.hasRoom    = [self addWithVariable:[NSGetSystemTools gethasRoom]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b32"]]]; // b32  是否有房
                    homeModel.hasCar     = [self addWithVariable:[NSGetSystemTools gethasCar]         keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b29"]]]; // b29  是否有车
                    homeModel.profession = [self addWithVariable:[NSGetSystemTools getprofession]     keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b62"]]]; // b62  职业
                    homeModel.blood      = [self addWithVariable:[NSGetSystemTools getblood]          keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b5"]]];  //  b5   血型
                    homeModel.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                    homeModel.province = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                    [homevc.allData addObject:homeModel];
                    
                    [homevc setUserInfo:homeModel];
                    [homevc setMarage:homeModel];
                    
#pragma mark 大尺度信息
                    
                    [homevc.temptationArray removeAllObjects];
                    NSString *datingPurposeStr = [self addWithVariable:[NSGetSystemTools getdatingPurpose]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b194"]]]; // b194 交友目的
                    if (!MyJudgeNull(datingPurposeStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:datingPurposeStr,@"交友目的", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    NSString *indulgedStr = [self addWithVariable:[NSGetSystemTools getIndulged]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b195"]]]; // b195 恋爱观
                    if (!MyJudgeNull(indulgedStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indulgedStr,@"恋爱观", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    NSString *meetPlaceStr = [self addWithVariable:[NSGetSystemTools getmeetPlace]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b196"]]]; // b196 约会干嘛
                    if (!MyJudgeNull(meetPlaceStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:meetPlaceStr,@"首次见面希望", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    NSString *lovePlaceStr = [self addWithVariable:[NSGetSystemTools getlovePlace]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b197"]]]; // b197 爱爱地点
                    if (!MyJudgeNull(lovePlaceStr)) {
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:lovePlaceStr,@"喜欢爱爱的地点", nil];
                        [homevc.temptationArray addObject:dict ];
                    }
                    
                    
                }else if ([key isEqualToString:@"b113"]){
                    NSArray *arr = [dict2 objectForKey:@"b113"];
                    for (NSDictionary *dict in arr) {
                        DHUserAlbumModel *item = [[DHUserAlbumModel alloc]init];
                        [item setValuesForKeysWithDictionary:dict];
                        [self.albumArr addObject:item];
                    }
                }else if([key isEqualToString:@"b116"]){
                    [homevc setValue:[dict2 objectForKey:@"b116"] forKey:@"heartFlag"];
                }
                

                
                
             }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [paraTabelView reloadData];
                [self hideHud];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
//折友标准
- (void)setFriend:(NConditonModel *)condit{
    if (!MyJudgeNull((condit.age))) {
        [makeFriendStr appendFormat:@"%@ ",condit.age];
    }
    if (!MyJudgeNull((condit.heights))) {
        [makeFriendStr appendFormat:@"%@ ",condit.heights];
    }
    if (!MyJudgeNull((condit.marriage))) {
        [makeFriendStr appendFormat:@"%@ ",condit.marriage];
    }
    if (!MyJudgeNull((condit.education))) {
        [makeFriendStr appendFormat:@"%@ ",condit.education];
    }
    if (!MyJudgeNull((condit.wage))) {
        [makeFriendStr appendFormat:@"%@ ",condit.wage];
    }
    if (!MyJudgeNull((condit.proVince))) {
        [makeFriendStr appendFormat:@"%@ ",condit.proVince];
    }
    if (!MyJudgeNull((condit.city))) {
        [makeFriendStr appendFormat:@"%@ ",condit.city];
    }
    NSLog(@"--------------------%@",makeFriendStr);
}
//婚恋观
- (void)setMarage:(NHome *)homeModel{
    if (homeModel.LoveOther.length == 0 && homeModel.marrySex.length == 0 && homeModel.together.length == 0 && homeModel.hasChild .length== 0) {
        marriageStr = [NSMutableString stringWithFormat:@"保密"];
    }else {
        
        if (nil==homeModel.LoveOther|| NULL==homeModel.LoveOther || [homeModel.LoveOther isKindOfClass:[NSNull class]] ||[[homeModel.LoveOther stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            
        }else{
            [marriageStr appendFormat:@"%@  ",homeModel.LoveOther];
        }
        if (nil==homeModel.marrySex|| NULL==homeModel.marrySex || [homeModel.marrySex isKindOfClass:[NSNull class]] ||[[homeModel.marrySex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            
        }else{
            [marriageStr appendFormat:@"%@  ",homeModel.marrySex];
        }
        if (nil==homeModel.together|| NULL==homeModel.together || [homeModel.together isKindOfClass:[NSNull class]] ||[[homeModel.together stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            
        }else{
            [marriageStr appendFormat:@"%@  ",homeModel.together];
        }
        if (nil==homeModel.hasChild|| NULL==homeModel.hasChild || [homeModel.hasChild isKindOfClass:[NSNull class]] ||[[homeModel.hasChild stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            
        }else{
            [marriageStr appendFormat:@"%@  ",homeModel.hasChild];
        }
        
        
    }
}
//ziwojies
- (void)setUserInfo:(NHome *)homeModel{
    if (homeModel.age!=nil&& [homeModel.age integerValue]>0) {
        [myselfInfoStr appendFormat:@"今年%@岁,",homeModel.age];
    }
    if (homeModel.height!=nil) {
        [myselfInfoStr appendFormat:@"身高%dcm,",[homeModel.height integerValue]];
    }
    if (homeModel.weight!=nil) {
        [myselfInfoStr appendFormat:@"体重%0.1fkg,",[homeModel.weight floatValue]];
    }
    if (homeModel.star!=nil) {
        [myselfInfoStr appendFormat:@"%@,",homeModel.star];
    }
    if (homeModel.marriage!=nil) {
        [myselfInfoStr appendFormat:@"%@,",homeModel.marriage];
    }
    if (homeModel.education!=nil) {
        [myselfInfoStr appendFormat:@"%@学历,",homeModel.education];
    }
    if (homeModel.profession!=nil) {
        [myselfInfoStr appendFormat:@"从事%@工作。",homeModel.profession];
    }
    if(myselfInfoStr.length>0){
        [myselfInfoStr insertString:@"我" atIndex:0];
    }else{
        [myselfInfoStr setString:@"保密"];
    }
}
/**
 *  Description
 *
 *  @param variable 不可变字典
 *  @param keystr   根据key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariable:(NSDictionary *)variable keyStr:(NSString *)keystr {

    NSDictionary *flashdic = variable;
    return [flashdic objectForKey:keystr];
    
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
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor=kUIColorFromRGB(0xf0edf2);
    
    
    [paraTabelView registerClass:[ParaTableViewCell class] forCellReuseIdentifier:KCell_A];
    [paraTabelView registerClass:[N_photoViewCell class] forCellReuseIdentifier:KCell_B];
    [paraTabelView registerClass:[HMakeFriendCell class] forCellReuseIdentifier:KCell_C];
    [paraTabelView registerClass:[HTBasicdataCell class] forCellReuseIdentifier:KCell_D];
    [paraTabelView registerClass:[HAssetsCell class] forCellReuseIdentifier:KCell_E];
    [paraTabelView registerClass:[HPersonalityCell class] forCellReuseIdentifier:KCell_F];
    [paraTabelView registerClass:[HMarriageCell class] forCellReuseIdentifier:KCell_G];
    [paraTabelView registerClass:[HChooseCell class] forCellReuseIdentifier:KCell_H];
    [paraTabelView registerClass:[NVIpAssetsCell class] forCellReuseIdentifier:KCell_J];
    [paraTabelView registerClass:[TemptationTableViewCell class] forCellReuseIdentifier:KCell_L];
    [paraTabelView registerNib:[UINib nibWithNibName:@"HomeTitleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KCell_K];
    [self.view addSubview:paraTabelView];
    [self.view addSubview:self.heartView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 9;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
//    NSString *isvip = [[dict objectForKey:@"b112"] objectForKey:@"b144"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    BOOL vip = [userInfo.b144 integerValue] == 1?YES:NO;
    
    if (section == 3) {
        
        return 2;
    }else if (section == 4){
        
        if (vip||[userId isEqualToString:self.touchP2]) {  // 自己
            return 4;
        }else {
            return 1;
        }
    }else if(section == 2){
        if (self.temptationArray.count>0) {
            return 2;
        }else{
            return 1;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NHome *homeModel = self.allData.lastObject;
//    if (self.allData.count > 0) {
//        homeModel = self.allData[indexPath.row];
//    }
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
//    if ([userInfo.b69 integerValue] == 1) {
    NSNumber *sexNum = homeModel.sex;
    if (indexPath.section == 0) {
        // nickname:  urlStr:
        ParaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
        cell.selected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //传数据
        [cell cellLoadDataWithBackground:@"bg-1" heart:nil wxpic:@"btn-chat-n" ageImage:@"icon-gender-gril" age:[NSString stringWithFormat:@"%@",homeModel.age] dressImage:@"icon-gps-n-0" address:homeModel.city timeImage:@"icon-time" time:homeModel.loginTime model:homeModel];
        CGFloat width=0;
        
        if (nil==homeModel.city|| NULL==homeModel.city || [homeModel.city isKindOfClass:[NSNull class]] ||[[homeModel.city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            width=[self WidthString:@"保密"];
        }else{
            width=[self WidthString:homeModel.city];
        }
        
        //地址图标位置
//        cell.addressImage.frame=CGRectMake(CGRectGetMidX(cell.contentView.frame)-width/2-5-12, 77, 14, 14);
        //点击跳转VIP
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        BOOL vip = [userInfo.b144 integerValue] == 1?YES:NO;
        if ([userId isEqualToString:self.touchP2]) {
            vip=YES;
        }
        if (!vip) {
            //点击查看
            UITapGestureRecognizer *getcontactTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToVipAction:)];
            [cell.contactLabel addGestureRecognizer:getcontactTap];
            
            UITapGestureRecognizer *getClockTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToVipAction:)];
            [cell.clockLabel addGestureRecognizer:getClockTap];
        }
        
        return cell;
        
    }else if (indexPath.section == 1) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
        NSArray *albumTempArr = [dict objectForKey:@"b113"];
        N_photoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_B forIndexPath:indexPath];
        cell.contentView.backgroundColor=kUIColorFromRGB(0xf03df2);
        NPhotoController *photo = [[NPhotoController alloc] init];
        photo.userId=self.touchP2;
        if (albumTempArr.count == 0) {
            photo.isblur=YES;
        }else{
            photo.isblur=NO;
        }

        photo.albumArr = _albumArr;
        NHome *item = nil;
        if (self.allData.count > 0) {
            item = [self.allData objectAtIndex:0];
        }
        
        photo.userId = [NSString stringWithFormat:@"%@",item.userId];
        photo.nickName = item.nickName;
        photo.view.frame = cell.allView.frame;
        [self addChildViewController:photo];
        
        for (UIView *view in cell.allView.subviews) {
            [view removeFromSuperview];
        }
        
        
        if (albumTempArr.count == 0) {
            [cell.allView addSubview:photo.view];
            UIView *coverView = [[UIView alloc]init];
            coverView.frame = cell.bounds;
            coverView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
            [cell.allView addSubview:coverView];
            
            UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pushBtn.frame = CGRectMake(CGRectGetMinX(cell.bounds), 5, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds)-10);
            if (self.fromMyPage) {
                [pushBtn setTitle:@"传一张自己的照片，提高TA对你的关注度~" forState:(UIControlStateNormal)];
            }else{
                [pushBtn setTitle:@"传一张自己的照片再来看TA的照片吧~" forState:(UIControlStateNormal)];
            }
            pushBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [pushBtn addTarget:self action:@selector(pushToUploadAlbums) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.allView addSubview:pushBtn];
            
            
            
        }else{
            [cell.allView addSubview:photo.view];
            if ([_albumArr count]==0) {
                UIView *coverView = [[UIView alloc]init];
                coverView.frame = cell.bounds;
                coverView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
                [cell.allView addSubview:coverView];
                UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                pushBtn.frame = CGRectMake(CGRectGetMinX(coverView.bounds), 5, CGRectGetWidth(coverView.bounds), CGRectGetHeight(coverView.bounds)-10);
                if (self.fromMyPage) {
                    [pushBtn setTitle:@"传一张自己的照片，提高TA对你的关注度~" forState:(UIControlStateNormal)];
                    [pushBtn addTarget:self action:@selector(pushToUploadAlbums) forControlEvents:(UIControlEventTouchUpInside)];
                }else{
                    
                    [pushBtn setTitle:@"TA还未上传照片啊~~" forState:(UIControlStateNormal)];
                }
                pushBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                
                [coverView addSubview:pushBtn];
            }
        }
        return cell;
        
        
    }else if (indexPath.section == 2) {

        
        if (self.temptationArray.count>0) {
            if (indexPath.row==0) {
                HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
                [cell addDataWithtitle:@"交友宣言"];
                
                if ([homeModel.d1Status intValue] == 1) {  // 宣言审核
                    contentStr = homeModel.describe;
                }else if ([homeModel.d1Status intValue] == 2) {
                    contentStr = @"交友宣言审核中";
                }else if ([homeModel.d1Status intValue] == 3){
                    contentStr = @"交友宣言审核失败";
                }
                if (contentStr == nil) {
                    cell.content.text = @"保密";
                }else {
                    cell.content.text = contentStr;
                }
                cell.content.font = [UIFont systemFontOfSize:13];
                h =[self hightForContent:contentStr fontSize:13.0f];
                CGRect temp = cell.content.frame;
                temp.size.height = h;
                cell.content.frame = temp;
                cell.downLine.frame = CGRectMake(0, 30+h-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                
                return cell;
            }else{
                TemptationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KCell_L forIndexPath:indexPath];
                [cell setValueOfInfoByArray:self.temptationArray  Title:@"私密信息"];
                return cell;
            }
   
        }else{
            HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
            [cell addDataWithtitle:@"交友宣言"];
            
            if ([homeModel.d1Status intValue] == 1) {  // 宣言审核
                contentStr = homeModel.describe;
            }else if ([homeModel.d1Status intValue] == 2) {
                contentStr = @"交友宣言审核中";
            }else if ([homeModel.d1Status intValue] == 3){
                contentStr = @"交友宣言审核失败";
            }
            if (contentStr == nil) {
                cell.content.text = @"保密";
            }else {
                cell.content.text = contentStr;
            }
            cell.content.font = [UIFont systemFontOfSize:13];
            h =[self hightForContent:contentStr fontSize:13.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = h;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+h-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            
            return cell;
        }
       
        
        
    }else if (indexPath.section == 3) {
        
        
        if (indexPath.row==0) {
            HomeTitleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KCell_K forIndexPath:indexPath];

            if (MyJudgeNull(homeModel.city)) {
                
                [cell updateCellAndTitle:nil mainTitle:nil detailTitle:@"保密" AndImage:@"w_wo_grzy_landmark"];
            }else{
                if ([homeModel.province isEqualToString:homeModel.city]) {
                    [cell updateCellAndTitle:nil mainTitle:nil detailTitle:[NSString stringWithFormat:@"%@",homeModel.city,nil] AndImage:@"w_wo_grzy_landmark"];
                }else{
                    [cell updateCellAndTitle:nil mainTitle:nil detailTitle:[NSString stringWithFormat:@"%@-%@",homeModel.province,homeModel.city,nil] AndImage:@"w_wo_grzy_landmark"];
                }
                
            }
            
//            [cell updateConstraintsAndImageLeadCon:20.0 imageWidth:60.0 TitleCon:10.0];
            return cell;
        }else{
            HMakeFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:KCell_C];
            [cell addDataWithtitle:@"自我介绍"];
 
            cell.content.text = myselfInfoStr;
            myselfInfoHeight =[self sshightForContent:myselfInfoStr fontSize:13.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = myselfInfoHeight;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+myselfInfoHeight-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            return cell;
        }
        
    
    }else if (indexPath.section == 4) {
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        BOOL vip = [userInfo.b144 integerValue] == 1?YES:NO;
            if (vip||[userId isEqualToString:self.touchP2]) {
                    NVIpAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_J forIndexPath:indexPath];
                    [cell addDataWithsomeData:self.vipAssetsArray[indexPath.row]];
                    if (self.allData) {
                        if (indexPath.row == 0) {
                            cell.choice.text = @"";
                            [cell setsomeDataCellMinx:10 andType:0];
                            cell.shortLine.frame = CGRectMake(0,    0,       [[UIScreen mainScreen] bounds].size.width, 0.5);
                        }else if (indexPath.row == 1) {
                            if (homeModel.wageMax != nil && homeModel.wageMin) {
                                cell.choice.text = [NSString stringWithFormat:@"%@-%@",homeModel.wageMin,homeModel.wageMax];
                            }else {
                                cell.choice.text = @"保密";
                            }
                            [cell setsomeDataCellMinx:85 andType:1];
                            cell.shortLine.frame = CGRectMake(70 + 10, 34.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                        }else if (indexPath.row == 2) {
                            if (homeModel.hasRoom != nil) {
                                cell.choice.text = homeModel.hasRoom;
                            }else {
                                cell.choice.text = @"保密";
                            }
                            [cell setsomeDataCellMinx:85 andType:1];
                            cell.shortLine.frame = CGRectMake(70 + 10, 34.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                        }else if (indexPath.row == 3) {
                            if (homeModel.hasCar != nil) {
                                cell.choice.text = homeModel.hasCar;
                            }else {
                                cell.choice.text = @"保密";
                            }
                            [cell setsomeDataCellMinx:85 andType:1];
                            cell.shortLine.frame = CGRectMake(70 + 10, 34.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                        }
                    }
                    return cell;
                }else {

                    HAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_E forIndexPath:indexPath];
                    [cell addDataWithassets:@"资产信息" monthImage:@"" month:@"月收入" propertyImage:@"" property:@"房产" carImage:@"" car:@"车产" vipImage:@"btn-vip-exclusive-h"];
                    [cell setAssetsDelegate:self];
                    return cell;
                    
                }
            
    }else if (indexPath.section == 5) {
        
        HPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_F forIndexPath:indexPath];
        NSArray *kidneyArray  = [homeModel.kidney componentsSeparatedByString:@"-"];
        
        [cell addDataWithtitleLabel:@"个性特征"];
        if (kidneyArray.count>0) {
            if ([sexNum integerValue] == 1) { // 男
                
                if (kidneyArray.count == 1) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                    
                }else if (kidneyArray.count == 2) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[1] content:cell.sContent];
                    
                }else if (kidneyArray.count >= 3) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[1] content:cell.sContent];
                    [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[2] content:cell.tContent];
                }
                
            }else {  // 女
                
                if (kidneyArray.count == 1) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                    
                }else if (kidneyArray.count == 2) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[1] content:cell.sContent];
                    
                }else if (kidneyArray.count >= 3) {
                    
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[1] content:cell.sContent];
                    [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[2] content:cell.tContent];
                }
            }
        }else{
            cell.content.backgroundColor = kUIColorFromRGB(0xeeeeee);
            cell.content.layer.borderWidth = 0.6f;
            cell.content.text  = [NSString stringWithFormat:@"# %@",@"保密"];
            [self addWithContent:cell.content.text textLabel:cell.content];
        }
        
        return cell;
        
    }else if (indexPath.section == 6) {
        
        HPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_F forIndexPath:indexPath];
        [cell addDataWithtitleLabel:@"兴趣爱好"];
        NSArray *favoArray  = [homeModel.favorite componentsSeparatedByString:@"-"];
        if (favoArray.count>0) {
            if ([sexNum integerValue] == 1) { // 男
                
                if (favoArray.count == 1) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                    
                }else if (favoArray.count == 2) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[1] content:cell.sContent];
                    
                }else if (favoArray.count >= 3) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[1] content:cell.sContent];
                    [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[2] content:cell.tContent];
                }
                
            }else {  // 女
                
                if (favoArray.count == 1) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                    
                }else if (favoArray.count == 2) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[1] content:cell.sContent];
                    
                }else if (favoArray.count >= 3) {
                    
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[1] content:cell.sContent];
                    [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[2] content:cell.tContent];
                }
            }
        }else{
            cell.content.backgroundColor = kUIColorFromRGB(0xeeeeee);
            cell.content.layer.borderWidth = 0.6f;
            cell.content.text  = [NSString stringWithFormat:@"# %@",@"保密"];
            [self addWithContent:cell.content.text textLabel:cell.content];
        }
        
        return cell;
        
    }else if (indexPath.section == 7){
        

        HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addDataWithtitle:@"婚恋观"];
        
        cell.content.text = marriageStr;
        marriageHige =[self shightForContent:marriageStr fontSize:13.0f];
        CGRect temp = cell.content.frame;
        temp.size.height = marriageHige;
        cell.content.frame = temp;
        cell.downLine.frame = CGRectMake(0, 30+marriageHige-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        return cell;
        
    }else {
        
        HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addDataWithtitle:@"择友标准"];
        if (self.conditonArray.count > 0) {
            NConditonModel *condit = self.conditonArray.lastObject;
          
            cell.content.text = makeFriendStr;
            makeFriend =[self sshightForContent:makeFriendStr fontSize:13.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = makeFriend;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+makeFriend-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }else {
            makeFriendStr = [NSMutableString stringWithFormat:@"保密"];
            cell.content.text = makeFriendStr;
            makeFriend =[self sshightForContent:makeFriendStr fontSize:13.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = makeFriend;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+makeFriend-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        
        }
        
        
        return cell;
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)setCellBt:(HAssetsCell *)cellBt vcBtag:(NSInteger)vcBtag {
    if (vcBtag == 101) {
//        TempHFController *temp = [[TempHFController alloc] init];
//        temp.urlWeb = [NSString stringWithFormat:@"%@p2.html",kServerAddressTestH5,nil];
//        
//        [self.navigationController pushViewController:temp animated:true];
        if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
            YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
            UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
            [self presentViewController:tempnc animated:YES completion:nil];
//            [self.navigationController pushViewController:temp animated:YES];
        }else{
#pragma mark 企业版
            YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
            NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
            
            temp.payMainCode=[goodDict objectForKey:@"b13"];
            temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
            
            temp.navigationItem.title=@"开通VIP会员";
            
            UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
            [self presentViewController:tempnc animated:YES completion:nil];
            
//            [self.nav setNavigationBarBackgroundImage:@"navbg.png" andAlph:0.0];
//            [self.navigationController pushViewController:temp animated:YES];
        }
    }
}
- (void)pushToUploadAlbums{
    [self.nav setAlph:1.0];
    MyPhotoViewController *vc = [[MyPhotoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchHeartTapAction:(UIButton *)sender{
//    [self createRoom:sender];

    if ([self.heartFlag integerValue]==0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self delectShakeInfo:_item];
            self.heartFlag=@"1";
        });
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self uploadShakeInfo:_item];
            self.heartFlag=@"0";
        });
    }
    
    
}
- (NSString *)getpurposeById:(NSString *)purposeid{
    NSDictionary *dic  = [NSGetSystemTools getpurpose];
    NSString *str = [dic objectForKey:purposeid];
    return str;
}
/**
 *  上传我触动谁LP-bus-msc/f_105_10_2.service？a77：被关注用户
 *  @param model
 */
- (void)uploadShakeInfo:(DHUserInfoModel *)model{
    [self createRoomForTouch];
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_105_10_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,self.touchP2,sessionId,userId,str];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __weak Homepage *homevc=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [homevc showHint:@"我触动你了！"];
                homevc.heartButton.backgroundColor=[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
                [homevc.heartButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                [homevc.heartButton setTitle:@"已触动" forState:(UIControlStateNormal)];
                
                
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  删除我触动谁LP-bus-msc/f_105_12_3.service？a77：被关注用户
 *  @param model
 */
- (void)delectShakeInfo:(DHUserInfoModel *)model {
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_105_12_3.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,self.touchP2,sessionId,userId,str];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    __weak Homepage *homevc=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [homevc showHint:@"取消触动！"];
                
                homevc.heartButton.backgroundColor=[UIColor whiteColor];
                [homevc.heartButton setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
                [homevc.heartButton setTitle:@"触动" forState:(UIControlStateNormal)];
                
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark 创建房间
- (void)createRoomForTouch{
    
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
    //    NSString *header = [NSString stringWithFormat:@"%@",model.b57];
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
                
                //是否打过招呼
                if (![JYMoveUserDao checkSayHellWithTargetId:targetId userId:userId]) {
                    
                    //插入打招呼表
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *dateTime=[[NSDate alloc]init];
                    _item.sayHellTime=[dateFormatter stringFromDate:dateTime];
                    _item.targetType=@"1";
                    [JYMoveUserDao insertSayHellListUserToDBWithItem:_item];
                    
                    
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
                    item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
                    item.robotMessageType = @"-1";
                    item.isRead = @"2";
                    item.fileUrl = @"";
                    item.length = 0;
                    item.fileName = @"";
                    item.addr = @"";
                    item.lat = 0;
                    item.lng = 0;
                    item.socketType = 1001;
                    item.friendType = 1;
                    if ([_item.b143 integerValue] ==1) {
                        [SocketManager asyncSendMessageWithMessageModel:item];
                    }
                    if (![DHMessageDao checkMessageWithMessageId:messageId targetId:item.targetId]) {
                        [DHMessageDao insertMessageDataDBWithModel:item userId:userId];
                    }
                    // 回调反馈发给哪个机器人
                    if ([_item.b143 integerValue] == 2) {
                        NSArray *msgArr = [DHMessageDao getRobotChatListWithUserId:_item.b80];
                        DHMessageModel *lastMessage = [msgArr lastObject];
                        NSString *type = nil;
                        if (!lastMessage) {
                            type = @"1";
                        }else{
                            type = lastMessage.robotMessageType;
                        }
                        //        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"lastRobotMessageType",model.b80,@"targetRobotId", nil];
                        [Mynotification postNotificationName:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:item];
                    }
                    
                }
            }
        }
    }];
    
    
//    // 加入我的关注,并发送消息
//    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
//    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
}
//- (void)createRoom:(UITapGestureRecognizer *)sender {
//    [Mynotification addObserver:self selector:@selector(createRoomForTouchDetail:) name:@"createRoomForTouchDetail" object:nil];
//    //    DHUserInfoModel *userinfo = [DBManager getUserWithCurrentUserId:self.item.fromUserAccount];
//    [[SocketManager shareInstance] creatRoomWithString:[NSString stringWithFormat:@"%@",_item.b52] account:[NSString stringWithFormat:@"%@",_item.b80]];// 开房间
////    self.model = model;
//}
//- (void)createRoomForTouchDetail:(NSNotification *)notifi{
//    NSDictionary *dict = notifi.object;
//    NSString *roomCode = [[dict objectForKey:@"body"] objectForKey:@"roomCode"];
//    NSString *roomName = [[dict objectForKey:@"body"] objectForKey:@"roomName"];
//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"charRoomInfo"];
//    
//    // 加入我的关注,并发送消息
//    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
//    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
//    //    NSString *header = [NSString stringWithFormat:@"%@",model.b57];
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    NSString *token = [NSGetTools getToken];
//    NSDateFormatter *format = [[NSDateFormatter alloc]init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *date = [format stringFromDate:[NSDate date]];
//    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
//    [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
//    NSString *messageId = [format1 stringFromDate:[NSDate date]];
//    DHMessageModel *item = [[DHMessageModel alloc]init];
//    item.messageId = messageId;
//    item.messageType = @"1";
//    item.message = @"我觉得跟你很有眼缘哦，点击名字和我聊天吧！";
//    item.fromUserDevice = @"2";
//    item.fromUserAccount = userId;
//    item.token = token;
//    item.timeStamp = date;
//    item.toUserAccount = targetId;
//    item.userId = userId;
//    item.roomCode = roomCode;
//    item.roomName = targetName;
//    item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
//    item.robotMessageType = @"-1";
//    item.isRead = @"2";
//    if (![DHMessageDao checkMessageWithMessageId:messageId targetId:item.targetId]) {
//        [DHMessageDao insertMessageDataDBWithModel:item userId:userId];
//    }
//    // 回调反馈发给哪个机器人
//    if ([_item.b143 integerValue] == 2) {
//        NSArray *msgArr = [DHMessageDao getRobotChatListWithUserId:_item.b80];
//        DHMessageModel *lastMessage = [msgArr lastObject];
//        NSString *type = nil;
//        if (!lastMessage) {
//            type = @"1";
//        }else{
//            type = lastMessage.robotMessageType;
//        }
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"lastRobotMessageType",_item.b80,@"targetRobotId", nil];
//        [Mynotification postNotificationName:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:item];
//    }
//}
- (void)getChatTapAction{
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
    //    NSString *header = [NSString stringWithFormat:@"%@",model.b57];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //是否打过招呼
    if (![JYMoveUserDao checkSayHellWithTargetId:targetId userId:userId]) {
        
        //插入打招呼表
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateTime=[[NSDate alloc]init];
        _item.sayHellTime=[dateFormatter stringFromDate:dateTime];
        _item.targetType=@"1";
        [JYMoveUserDao insertSayHellListUserToDBWithItem:_item];
        
        NSString *token = [NSGetTools getToken];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [format stringFromDate:[NSDate date]];
        NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
        NSString *messageId = [format1 stringFromDate:[NSDate date]];
        ChatController *chatVC = [ChatController new];
        DHMessageModel *item = [[DHMessageModel alloc]init];
        item.messageId = messageId;
        item.messageType = @"1";
        NSDictionary *temp = [NSGetSystemTools getDefaultMessage];
        NSArray *arr = [temp allKeys];
        NSInteger index = (arc4random() % (arr.count - 1 - 0 + 1))+0;
        if (index <= 0 ) {
            index = 0;
        }else if (index >= arr.count - 1){
            index = arr.count - 1;
        }
        NSString *defaultMessage = [temp objectForKey:[arr objectAtIndex:index]];
        item.message = defaultMessage;
        item.fromUserDevice = @"2";
        item.fromUserAccount = userId;
        item.token = token;
        item.timeStamp = date;
        item.toUserAccount = targetId;
        item.userId = userId;
        item.roomName = targetName;
        item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
        item.robotMessageType = @"-1";
        // 回调反馈发给哪个机器人
        //    if ([_item.b143 integerValue] == 2) {
        //        NSArray *msgArr = [DBManager getRobotChatListWithUserId:_item.b80];
        //        Message *lastMessage = [msgArr lastObject];
        //        NSString *type = nil;
        //        if (!lastMessage) {
        //            type = @"1";
        //        }else{
        //            type = lastMessage.robotMessageType;
        //        }
        //        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"lastRobotMessageType",_item.b80,@"targetRobotId", nil];
        //        [Mynotification postNotificationName:REPLY_MESSAGE_TO_ROBOT_NOTIFICATION object:dict];
        //    }
        chatVC.item = item;
        chatVC.userInfo = self.item;
//        UINavigationController *chatnc=[[UINavigationController alloc]initWithRootViewController:chatVC];
//        [self presentViewController:chatnc animated:YES completion:nil];
//        [self.nav setAlph:1.0];
        [self.nav setNavigationBarBackgroundImage:@"navbg" andAlph:1.0];
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        NSString *token = [NSGetTools getToken];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [format stringFromDate:[NSDate date]];
        NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
        NSString *messageId = [format1 stringFromDate:[NSDate date]];
        ChatController *chatVC = [ChatController new];
        DHMessageModel *item = [[DHMessageModel alloc]init];
        item.messageId = messageId;
        item.messageType = @"1";
        NSDictionary *temp = [NSGetSystemTools getDefaultMessage];
        NSArray *arr = [temp allKeys];
        NSInteger index = (arc4random() % (arr.count - 1 - 0 + 1))+0;
        if (index <= 0 ) {
            index = 0;
        }else if (index >= arr.count - 1){
            index = arr.count - 1;
        }
        NSString *defaultMessage = [temp objectForKey:[arr objectAtIndex:index]];
        item.message = defaultMessage;
        item.fromUserDevice = @"2";
        item.fromUserAccount = userId;
        item.token = token;
        item.timeStamp = date;
        item.toUserAccount = targetId;
        item.userId = userId;
        item.roomName = targetName;
        item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
        item.robotMessageType = @"-1";
        // 回调反馈发给哪个机器人
        //    if ([_item.b143 integerValue] == 2) {
        //        NSArray *msgArr = [DBManager getRobotChatListWithUserId:_item.b80];
        //        Message *lastMessage = [msgArr lastObject];
        //        NSString *type = nil;
        //        if (!lastMessage) {
        //            type = @"1";
        //        }else{
        //            type = lastMessage.robotMessageType;
        //        }
        //        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"lastRobotMessageType",_item.b80,@"targetRobotId", nil];
        //        [Mynotification postNotificationName:REPLY_MESSAGE_TO_ROBOT_NOTIFICATION object:dict];
        //    }
        chatVC.item = item;
        chatVC.userInfo = self.item;
//        [self.nav setAlph:1.0];
        [self.nav setNavigationBarBackgroundImage:@"navbg" andAlph:1.0];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    
    
}

/**
 *  Description
 *
 *  @param kinDic  倒叙的字典便于取值
 *  @param keyStr  key字符串
 *  @param content 内容
 */
- (void)addWithKidDic:(NSDictionary *)kinDic keyStr:(NSString *)keyStr content:(UILabel *)content{
    
    NSString *oneStr = [self addWithVariable:kinDic   keyStr:keyStr];
    if (oneStr!=nil) {
        content.backgroundColor = kUIColorFromRGB(0xeeeeee);
        content.layer.borderWidth = 0.6f;
        content.text  = [NSString stringWithFormat:@"# %@",oneStr];
        [self addWithContent:content.text textLabel:content];
    }
    
}

/**
 *  Description
 *
 *  @param textContent label内容
 *  @param textLabel   选取的属性
 */
- (void)addWithContent:(NSString *)textContent textLabel:(UILabel *)textLabel{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textContent];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:14.0]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kUIColorFromRGB(0xfd8a24)
     
                          range:NSMakeRange(0, 1)];
    
    textLabel.attributedText = AttributedStr;
}

#pragma mark ---- 自适应高度
- (CGFloat)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

- (CGFloat)shightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
- (CGFloat)sshightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
//自适应宽度
-(CGFloat)WidthString:(NSString *)aString{
    
    CGRect rect=[aString boundingRectWithSize:CGSizeMake(1000 ,20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.width;
}
#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [ParaTableViewCell cellHeight];
    }else if (indexPath.section == 1) {
        return [N_photoViewCell photocellHeight];
    }else if (indexPath.section == 2) {
        
        if (self.temptationArray.count>0) {
            if (indexPath.row==0) {
                return [HMakeFriendCell makeFriendcellHeight] + h + 30;  // 自适应高度cell
            }else{
                return 35*self.temptationArray.count+gotHeight(12)+25;
            }
            
           
        }else{
            
            return [HMakeFriendCell makeFriendcellHeight] + h + 30;  // 自适应高度cell
        }
        
        
    }else if (indexPath.section == 3) {
        
        if (indexPath.row==0) {
            return [HomeTitleTableViewCell CellHeight];
        }else{
            return [HMakeFriendCell makeFriendcellHeight] + myselfInfoHeight + 30;
        }
        
        
    }else if (indexPath.section == 4) {
        return [NVIpAssetsCell basicdatacellHeight];
    }else if (indexPath.section == 5) {
        return [HPersonalityCell personacellHeight];
    }else if (indexPath.section == 6) {
        return [HPersonalityCell personacellHeight];
    }else if (indexPath.section == 7){

        return [HMakeFriendCell makeFriendcellHeight] + marriageHige + 30;

    }else {
        
        return [HMakeFriendCell makeFriendcellHeight] + makeFriend + 30;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 8) {
        return 50;
    }else {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=kUIColorFromRGB(0xf0edf2);
    
    if (section == 8) {
        view.frame=CGRectMake(0, 0, ScreenWidth, 50);
        return view;
    }else {
        view.frame=CGRectMake(0, 0, ScreenWidth, 0);
        return view;
    }
    
}
#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return gotHeight(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, gotHeight(0))];
        view.backgroundColor=kUIColorFromRGB(0xf0edf2);
        return view;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, gotHeight(10))];
        view.backgroundColor=kUIColorFromRGB(0xf0edf2);
        return view;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        ParaTableViewCell *cell = [paraTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cell updateHeightWithRect:CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, self.view.frame.size.width+ (-scrollView.contentOffset.y) * 2, 253 - scrollView.contentOffset.y)];
        self.alphaNum=0.0;
    }else if(scrollView.contentOffset.y<240 && scrollView.contentOffset.y>=0){
        
        self.alphaNum=(scrollView.contentOffset.y)/240;
        [self.nav setAlph:self.alphaNum];
    }else{
        self.alphaNum=1.0;
        [self.nav setAlph:self.alphaNum];
        
    }
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
#pragma mark 手势----到vip申请界面

- (void)goToVipAction:(UITapGestureRecognizer *)sender{

//    TempHFController *temp = [[TempHFController alloc] init];
//    temp.urlWeb = [NSString stringWithFormat:@"%@p2.html",kServerAddressTestH5,nil];
//    
//    [self.navigationController pushViewController:temp animated:true];
    if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
        
        YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
//        [self.nav setAlph:1.0];
//        [self.navigationController pushViewController:temp animated:YES];
    }else{
#pragma mark 企业版

        YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
        
        temp.payMainCode=[goodDict objectForKey:@"b13"];
        temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//        temp.payMainCode=@"1006";
//        temp.payComboType=@"1";//套餐
        temp.navigationItem.title=@"开通VIP会员";
        UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
        [self presentViewController:tempnc animated:YES completion:nil];
        //        [temp.nav setNavigationBarBackgroundImage:@"navbg.png" andAlph:0.0];
        //        [self.navigationController pushViewController:temp animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark 定位
#pragma mark ------- 提醒用户获取地理位置 -------
- (void)willGetUserLocationInfo
{
    // fix ios8 location issue
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8) {
#ifdef __IPHONE_8_0
            if ([self.LocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.LocationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
            }
            if ([self.LocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.LocationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
            }
#endif
        }
    }
    
    
}
//如果当前定位关闭,则调用
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    
    NSLog(@"Error: %@",[error localizedDescription]);
    
    [manager stopUpdatingLocation];
}
//如果可以使用定位,则调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    // 取得当前位置的坐标
    NSLog(@"latitude:%f,longitude:%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    CGFloat latitude = currentLocation.coordinate.latitude;
    CGFloat longitude = currentLocation.coordinate.longitude;
    // 利用反地理编码获取位置之后设置标题
    __weak Homepage *homeV=self;
    
    CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        // 地址对象
        CLPlacemark *placemark = [placemarks firstObject];
        
        // 存到本地
        if ([placemark.administrativeArea containsString:@"省"]) {
            
            homeV.cityname = [placemark.administrativeArea componentsSeparatedByString:@"市"][0];
            NSIndexPath *ind=[NSIndexPath indexPathForRow:0 inSection:3];
            [paraTabelView reloadRowsAtIndexPaths:@[ind] withRowAnimation:(UITableViewRowAnimationNone)];
        }
        
        
    }];
    
    //关闭代理
    [self.LocationManager stopUpdatingLocation];
    
}
#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(void)dealloc{
    [Mynotification removeObserver:self];

}
- (void)p_setupProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudInView:self.view hint:@"请稍等,正在努力加载!"];
        
    });
    
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
