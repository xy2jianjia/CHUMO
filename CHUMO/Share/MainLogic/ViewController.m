//
//  ViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ViewController.h"
#import "SearchSetViewController.h"
#import "ChatController.h"
#import "HomeController.h"
#import "DHMsgPlaySound.h"
#import "UserGuidedTwo.h"
#import "DHAlertView.h"
#import "DiscoverViewController.h"

#import "ViewController+Location.h"
#import "DHLayout.h"
#import "ViewController+Recommend.h"
#import "ViewController+Upgrade.h"
#import "JYNavigationController.h"
#import "ViewController+Activity.h"
#import "AFNHttpRequestOPManager.h"
@interface ViewController () <UITabBarControllerDelegate,UIAlertViewDelegate,DHAlertViewDelegate,RobotManagerDelegate,NIMChatManagerDelegate>
@property (nonatomic,strong) NSTimer *timer;
/**
 *  接收到的消息数组，包括机器人消息和用户消息
 */
@property (nonatomic,strong) NSMutableArray *recMesgArr;
//@property (nonatomic,assign) NSInteger timerIndex;
/**
 *  由哪个机器人发送消息
 */
//@property (nonatomic,strong) NSString *postMassgeRobotId;
/**
 *  当前用户信息
 */

@end

@implementation ViewController
/**
 *  接收到机器人消息，用代理回调
 *
 *  @param object
 */
- (void)didReceiveRobotMessageCallBacked:(id)object{
    
    DHMessageModel *message = object;
//    self.message = message;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"收到消息" message:[NSString stringWithFormat:@"来自%@的消息：%@",message.targetId,message.message] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    });
    NSString *targetId = [object targetId];
    BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:targetId];
    if (isblack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self showHint:@"已经被拉黑，不接收此人的消息"];
        });
        
    }else{
        [self localNotification:object];
        [Mynotification postNotificationName:NEW_DIDRECEIVR_ROBOT_MESSAGE object:message];
    }
    
    
}
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    NSLog(@"%@",messages);
    
}
- (void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress{
    NSLog(@"%f",progress);
}
-(void)willSendMessage:(NIMMessage *)message{
    NSLog(@"%@",message);
}
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error{
    NSLog(@"%@",error.userInfo);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [AFNHttpRequestOPManager sharedClient:self];
    self.sendMessageTimes = 0;
    self.recommendTimes = 0;
    self.reconnectedTimes = 0;
    [self getSystemDataInfos];
    self.recMesgArr = [NSMutableArray array];
    self.recommendArr = [NSMutableArray array];
    
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    NSString *token = [JNKeychain loadValueForKey:userId];
//    // 若是存在，不再请求，直接登录网易
//    if (![token isEqualToString:@"(null)"] && [token length] > 0) {
//        [[[NIMSDK sharedSDK] loginManager] login:userId token:token completion:^(NSError *error) {
//            [[NIMSDK sharedSDK].chatManager addDelegate:self];
////            //构造消息
////            NIMMessage *message = [[NIMMessage alloc] init];
////            message.text    = @"你猜 、你猜我猜不猜 、你猜我猜你猜不猜、你猜我猜你猜我猜你猜不猜、你猜我猜你猜我猜你猜我猜你猜不猜每次加个你猜不猜。";
////            
////            //构造会话
////            NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
////            
////            //发送消息
////            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
//            
//        }];
//    }else{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // 网易云
//            [HttpOperation asyncLiveIM_GetLoginTokenWithQueue:nil completed:^(NSDictionary *neteaseImInfo, NSInteger code) {
//                NSString *token =  [neteaseImInfo objectForKey:@"token"];
//                [[[NIMSDK sharedSDK] loginManager] login:userId token:token completion:^(NSError *error) {
//                    [[NIMSDK sharedSDK].chatManager addDelegate:self];
//                    //构造消息
//                    NIMMessage *message = [[NIMMessage alloc] init];
//                    message.text    = @"你猜 、你猜我猜不猜 、你猜我猜你猜不猜、你猜我猜你猜我猜你猜不猜、你猜我猜你猜我猜你猜我猜你猜不猜每次加个你猜不猜。";
//                    
//                    //构造会话
//                    NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
//                    
//                    //发送消息
//                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
//                }];
//            }];
//        });
//    }
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"recommed_system_data"];
//    for (NSDictionary *temp in arr) {
//        // 发消息次数
//        if ([[temp objectForKey:@"b20"] isEqualToString:@"button_one_times"]) {
//            self.sendMessageTotalTimes = [[temp objectForKey:@"b22"] integerValue];
//        }else if([[temp objectForKey:@"b20"] isEqualToString:@"button_two_times"]){
//            // 推荐总次数
//            self.recommendTotalTimes = [[temp objectForKey:@"b22"] integerValue];
//        }
//    }
#warning mark 更新
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self asyncUpgrade];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        // 定位
        [self configLocationManager];
    });
    // 加载所有子视图控制器
    [self loadAllSubViewControllers];
    // 请求自己头像数据
    [self addMyHeaderDatas];
    [self login];
    [self registerChatNotification];
    [Mynotification addObserver:self selector:@selector(loadBadgeValue) name:@"loadBadgeValue" object:nil];
//    [Mynotification addObserver:self selector:@selector(recieveOffLineMessage:) name:@"recieveOffLineMessage" object:nil];
    [Mynotification addObserver:self selector:@selector(asyncLoadCurrentUserInfo:) name:@"asyncLoadCurrentUserInfo" object:nil];
    [Mynotification addObserver:self selector:@selector(pushPayNotificationWhenPayForFailure:) name:@"pushPayNotificationWhenPayForFailure" object:nil];
    
    [Mynotification addObserver:self selector:@selector(pushPayNotificationWhenUserLogin:) name:@"pushPayNotificationWhenUserLogin" object:nil];
    [Mynotification addObserver:self selector:@selector(new_didReceiveOnlineMessage:) name:NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION object:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self configUserHeaderImage];
//    });
    // 是否来自于注册
    BOOL isFromRegitser = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFromRegitser"];
    if (isFromRegitser) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 系统账号第一条消息
            [self configSayHelloMessage];
        });
    }
    
#pragma mark 废弃 20160627
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 启动活动页
//        [self configActivity];
//    });
    
    
}
- (void)new_didReceiveOnlineMessage:(NSNotification *)notifi{
    DHMessageModel *msg = notifi.object;
    // 存储到数据库
    if (![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",msg.userId]];
    }
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:msg.targetId];
    BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:userInfo.b80];
    if (isblack) {
//        [self showHint:@"已经被拉黑，不接收此人的消息"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadBadgeValue];
        });
    }
}
//- (void)configUserHeaderImage{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *Userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//        DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:Userid];
//        if (item.b57 == nil || [item.b57 length] == 0 || [item.b57 isEqualToString:@"(null)"] || [item.b57 isEqualToString:@"(NULL)"] || [item.b57 isEqualToString:@"null"]) {
//            DHAlertView *alert1 = [[DHAlertView alloc]init];
//            [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"您还未有头像，有头像约会成功会更高哦，快跟着我去上传吧~"];
//            alert1.delegate = self;
//            [self.view addSubview:alert1];
//        }
//    });
//}
//-(void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger)index{
//    if (index == 0) {
//        return;
//    }else{
//        NSString *Userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//        DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:Userid];
//        UserGuidedTwo *vc = [[UserGuidedTwo alloc] init];
//        vc.title = @"上传头像";
//        vc.sex = item.b69;
////        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
////        nav.navigationBar.translucent = NO;
////        nav.navigationBar.barTintColor = kUIColorFromRGB(0xf35562);
//        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:vc];
////        [self presentViewController:nav animated:YES completion:nil];
//        [self presentViewController:nav animated:YES completion:nil];
// 
//    }
//}
/**
 *  加载未读消息
 */
- (void)loadBadgeValue{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSArray *arr = [DHMessageDao getChatListWithUserId:userId roomCode:nil];
    if (arr.count == 0) {
        
    }else{
        NSInteger badgeValue = [DHMessageDao getBadgeValueWithTargetId:nil currentUserId:userId];
        if (badgeValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[self.viewControllers objectAtIndex:2] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",badgeValue]];
            });
        }
    }
    
}
- (void)connectEaseModWithUserId:(NSString *)userId password:(NSString *)pass{
    
    NSDictionary *dict = [NSGetSystemTools getsystem_pm];
    NSArray *allkeys = [dict allKeys];
    NSString *attr = nil;
    for (NSString *key in allkeys) {
        if (([key isEqualToString:@"T_"] || [key isEqualToString:@"t_"]) || ([key isEqualToString:@"P_"] || [key isEqualToString:@"p_"])) {
            attr = key;
            break;
        }
    }
    NSString *easeUserName = [NSString stringWithFormat:@"%@%@",attr,userId];
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:easeUserName password:@"123456" withCompletion:^(NSString *username, NSString *password, EMError *error) {
//        if (!error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [self showHint:[NSString stringWithFormat:@"%@-%@",@"注册环信",userId]];
//            });
//        }
//        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easeUserName password:@"123456" completion:^(NSDictionary *loginInfo, EMError *error) {
//            if (!error && loginInfo) {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [self showHint:[NSString stringWithFormat:@"%@-%@",@"登录环信",userId]];
//                });
//                [[NSUserDefaults standardUserDefaults] setObject:loginInfo forKey:@"easeModLoginInfo"];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [self showHint:[NSString stringWithFormat:@"登录环信%@",[error description]]];
//                });
//            }
//            
//        } onQueue:nil];
//    } onQueue:nil];
    
}


/**
 *  添加本地通知
 *
 *  @param message 消息
 */
- (void)localNotification:(DHMessageModel *)message{
    
    [Mynotification postNotificationName:@"shouMessageToustView" object:message];
    
//    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//    // 设置推送时间
//    localNotifi.fireDate = date;
//    // 设置时区
//    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
//    // 设置重复间隔
//    localNotifi.repeatInterval = kCFCalendarUnitSecond;
////    kCFCalendarUnitDay;
//    // 推送声音
//    localNotifi.soundName = UILocalNotificationDefaultSoundName;
//    // 推送内容
//    localNotifi.alertBody = message.message;
//    //显示在icon上的红色圈中的数子
////    localNotifi.applicationIconBadgeNumber = 1;
//    //设置userinfo 方便在之后需要撤销的时候使用
//    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
//    localNotifi.userInfo = info;
//    //添加推送到UIApplication
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    [app scheduleLocalNotification:localNotifi];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
//    UIViewController *result = nil;
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    
//    return result;
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController *result = [ViewController getVisibleViewControllerFrom:rootViewController];
    return result;
}
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
    
}
-(UINavigationController*) viewControllerWithTitle:(NSString*) title image:(UIImage*)image tag:(NSInteger )tag viewController:(UIViewController *)viewController{
//    viewController = [[UIViewController alloc] init];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    viewController.title = title;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    return nav;
}
- (void)loadAllSubViewControllers{
    
    // 1. 创建子视图控制器
    DHLayout *flowLayout = [[DHLayout alloc]init];
//    flowLayout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    EyeLuckViewController *luckVC = [[EyeLuckViewController alloc]initWithCollectionViewLayout:flowLayout];
    DiscoverViewController *searchVC = [DiscoverViewController new];
    HomeController *messageVC = [[HomeController alloc]initWithStyle:(UITableViewStyleGrouped)];
    NearPeopleViewController *nearVC = [NearPeopleViewController new];
    MineViewController *mineVC = [MineViewController new];
//    self.viewControllers = [NSArray arrayWithObjects: [self viewControllerWithTitle:@"缘分" image:[UIImage imageNamed:@"icon-chudong-normal.png"] tag:1000 viewController:luckVC], [self viewControllerWithTitle:@"搜索" image:[UIImage imageNamed:@"icon-search-normal.png"] tag:1001 viewController:searchVC],[self viewControllerWithTitle:nil image:nil tag:1003 viewController:messageVC],[self viewControllerWithTitle:@"附近" image:[UIImage imageNamed:@"icon-nearby-normal.png"] tag:1004 viewController:nearVC], [self viewControllerWithTitle:@"我" image:[UIImage imageNamed:@"icon-i-normal.png"] tag:1005 viewController:mineVC], nil];
    // 2. 设置tabBarItem
    luckVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"触动" image:[UIImage imageNamed:@"icon-chudong-normal.png"] selectedImage:[UIImage imageNamed:@"icon-chudong-selected.png"]];
//    luckVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"缘分" image:[UIImage imageNamed:@"icon-chudong-normal.png"] tag:1000];
    luckVC.tabBarItem.tag = 1000;

    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"w_fujin_found.png"] selectedImage:[UIImage imageNamed:@"w_fujin_founding.png"]];
    searchVC.tabBarItem.tag = 1001;
    messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"w_fujin_mail.png"] selectedImage:[UIImage imageNamed:@"w_fujin_maizh.png"]];
//    messageVC.tabBarItem.imageInsets=UIEdgeInsetsMake(-9, 0, 9, 0);
    messageVC.tabBarItem.tag = 1002;
    nearVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近" image:[UIImage imageNamed:@"w_nearby.png"] selectedImage:[UIImage imageNamed:@"w_nearbying.png"]];
    nearVC.tabBarItem.tag = 1003;
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"w_me.png"] selectedImage:[UIImage imageNamed:@"w_me.png"]];
    mineVC.tabBarItem.tag = 1004;
    
    // 3. 添加导航控制器
    UINavigationController *luckNC = [[UINavigationController alloc] initWithRootViewController:luckVC];
    UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    UINavigationController *messageNC = [[UINavigationController alloc] initWithRootViewController:messageVC];
    UINavigationController *nearNC = [[UINavigationController alloc] initWithRootViewController:nearVC];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mineVC];
//    JYNavigationController *mineNC = [[JYNavigationController alloc] initWithRootViewController:mineVC];
    
    luckNC.navigationBar.barTintColor = MainBarBackGroundColor;
    [luckNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    searchNC.navigationBar.barTintColor = MainBarBackGroundColor;
    [searchNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    messageNC.navigationBar.barTintColor = MainBarBackGroundColor;
    [messageNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nearNC.navigationBar.barTintColor = MainBarBackGroundColor;
    [nearNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    mineNC.navigationBar.barTintColor = MainBarBackGroundColor;
    [mineNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
        mineNC.navigationBar.translucent = false;
        nearNC.navigationBar.translucent = false;
        luckNC.navigationBar.translucent = false;
        searchNC.navigationBar.translucent = false;
        messageNC.navigationBar.translucent = false;
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    if (iPhone4 || iPhone5) {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg_640.png"]];
    }else if(iPhonePlus){
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg1242.png"]];
    }else{
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    }
    
    
    
    // 设置选中的颜色
    self.tabBar.selectedImageTintColor = MainBarBackGroundColor;
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // 3. 设置视图控制器
    self.viewControllers = @[luckNC, nearNC, messageNC,searchNC ,mineNC];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startChat" object:self userInfo:nil];
    [self loadBadgeValue];
}

#pragma mark----tabBar点击代理----
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1000) {
//        NSLog(@"%@",item);
        item.selectedImage = [UIImage imageNamed:@"icon-chudong-selected.png"];
    }else if (item.tag == 1001){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-search2-n.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goViewController:)];
    }else if (item.tag == 1002){
        UINavigationController *nc = [self.viewControllers objectAtIndex:2];
        HomeController *vc = [nc.viewControllers objectAtIndex:0];
        vc.chatDataArr = [NSMutableArray arrayWithArray:self.recMesgArr];
    }else if (item.tag == 1003){
        self.title = @"附近";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.title = @"我";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

// 搜索
- (void)goViewController:(UIBarButtonItem *)sender{
    DiscoverViewController *sSetVC = [DiscoverViewController new];
    [self.navigationController pushViewController:sSetVC animated:YES];
    
}

// 联系人
- (void)contactController:(UIBarButtonItem *)sender
{
    
}

// 角标
- (void)addbadges
{
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(165, 5, 15, 15)];
    badgeView.layer.cornerRadius = 15/2;
    badgeView.clipsToBounds = YES;
    badgeView.backgroundColor = [UIColor redColor];
    
    [self.tabBar addSubview:badgeView];
}


// 加载头像数据
- (void)addMyHeaderDatas
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];
    NSNumber *headerNum = [NSNumber numberWithInt:1000];
    NSString *url = [NSString stringWithFormat:@"%@f_107_11_1.service?p1=%@&p2=%@&a78=%@&%@",kServerAddressTest3,p1,p2,headerNum,appInfo];
    
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"-----url-%@--",url);
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
//        NSLog(@"--头像--%@",infoDic);
        
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            if (modelArr.count > 0) {
                NSDictionary *headDict = modelArr[0];
                NSString *urlStr = headDict[@"b57"];
                [NSGetTools upDateIconB57:urlStr];// 更新保存头像信息
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----头像---error--%@",error);
    }];
}

- (void)login{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *username = [dict objectForKey:@"userName"];
    NSString *password = [dict objectForKey:@"password"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@",kServerAddressTest,username,password];
//    &p2=%@&p1=%@&%@ ,userId,sessionId,appinfoStr
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self asyncLoadRobotsToDBWithUserId:dict2[@"b80"] sessionId:dict2[@"b101"]];
                [self connectEaseModWithUserId:[NSString stringWithFormat:@"%@",dict2[@"b80"]] password:password];
            });
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [RobotManager startupRobotManagerWithDelegate:self];
            });
            [SocketManager ClientConnectServer];
            [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"]];
        }else if ([codeNum intValue] == 207){
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
            [Mynotification postNotificationName:@"loginStateChange" object:nil];
            // 清除userdefault 里所有数据
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
            //        BOOL istodaysended = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-%@",date,userId]];
            for (NSString *key in [defaultsDictionary allKeys]) {
                // 不删除发消息
                
                if (![[NSString stringWithFormat:@"%@-%@",date,userId] isEqualToString:key] &&![[NSString stringWithFormat:@"%@-firstRobot",date] isEqualToString:key] && ![[NSString stringWithFormat:@"%@-secondRobot",date] isEqualToString:key]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//                if (!error && info) {
//                    NSLog(@"退出成功");
//                }
//            } onQueue:nil];
// 连接socket
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)asyncLoadCurrentUserInfo:(NSNotification *)notifi{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    [self getUserInfosWithp1:sessionId p2:userId];
}

// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:p1,@"p1",p2,@"p2",nil];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    LP-bus-msc/ f_108_13_1
//    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
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
//            [Mynotification postNotificationName:@"popVcAfterGetUserInfonotification" object:dict2];
//            popVcAfterGetUserInfonotification
            // 是会员就不再骚扰
//            if ([item.b144 integerValue] == 2) {
            
//            }
            NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            NSInteger recommendTime = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend-%@-%@",date,userId]];
            NSInteger recommend_sendMsgTimes = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend_sendMsg-%@-%@",date,userId]];
            if (recommendTime <= self.recommendTotalTimes && recommend_sendMsgTimes <= self.sendMessageTotalTimes) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self asyncLoadRecommendIsEmpty:YES];
                });
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}
//- (void)didReceiveMessageCallBacked:(id)object{
//    NSLog(@"%@",[object message]);
//    NSString *targetId = [object targetId];
//    BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:targetId];
//    if (isblack) {
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [self showHint:@"已经被拉黑，不接收此人的消息"];
//        });
//        
//    }else{
//        [self localNotification:object];
//        [Mynotification postNotificationName:RecieveOnLineMessage object:object];
//    }
//}

/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
//- (void)didReceiveMessage:(EMMessage *)message{
//    [self loadChatData:message];
//}
///*!
// @method
// @brief 接收到离线非透传消息的回调
// @discussion
// @param offlineMessages 接收到的离线列表
// @result
// */
//- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
//    //    NSLog(@"%@",offlineMessages);
//    for (EMMessage *message in offlineMessages) {
//        [self loadChatData:message];
//    }
//}
//- (void)loadChatData:(EMMessage *)message{
//    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
//    //    if (![message.from isEqualToString:self.userInfo.b80]) {
//    switch (msgBody.messageBodyType) {
//        case eMessageBodyType_Text:
//        {
//            // 收到的文字消息
//            NSString *txt = ((EMTextMessageBody *)msgBody).text;
//            DHMessageModel *msg = [[DHMessageModel alloc] init];
//            msg.toUserAccount = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//            msg.message = txt;
//            msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
//            long long timestamp = message.timestamp;
//            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
//            NSString *fmtDate = [fmt stringFromDate:date];
//            msg.timeStamp = fmtDate;
//            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//            msg.fromUserAccount = [message.from substringFromIndex:2];
//            
//            msg.messageType = [message.ext objectForKey:@"type"];
//            msg.targetUserType = [message.ext objectForKey:@"userType"];
//            msg.messageId = message.messageId;// 消息ID
//            msg.token = [NSGetTools getToken];
//            msg.targetId = [message.from substringFromIndex:2];
//            msg.userId = userId;
//            msg.robotMessageType = @"-1";
//            msg.isRead = @"1";
//            
//            [self localNotification:msg];
//            
//            // 存储到数据库
//            if (![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
//                [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",userId]];
//            }
//            DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:[message.from substringFromIndex:2]];
//            BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:msg.targetId];
//            if (isblack) {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [self showHint:@"已经被拉黑，不接收此人的消息"];
//                });
//            }else{
//                if (!userInfo) {
//                    [self getTargetUserInfoWithUserId:[message.from substringFromIndex:2]];
//                }
//                NSInteger badgeValue = [DHMessageDao getBadgeValueWithTargetId:nil currentUserId:userId];
//                [UIApplication sharedApplication].applicationIconBadgeNumber = badgeValue;
//                if (badgeValue) {
//                    [Mynotification postNotificationName:@"loadBadgeValue" object:nil];
//                }
//                [Mynotification postNotificationName:@"shouMessageToustView" object:msg];
//                DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
//                [sound play];
//            }
//            
//        }
//            break;
//        default:
//            break;
//    }
//}
- (void)getTargetUserInfoWithUserId:(NSString *)userId{
    [HttpOperation asyncGetUserInfoWithUserId:userId queue:dispatch_get_main_queue() completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
        
    }];
}
/**
 *  接收离线消息
 *
 *  @param notifi
 */
//- (void)recieveOffLineMessage:(NSNotification *)notifi{
////    [self.recMesgArr addObject:notifi.object];
//    NSDictionary *rootDict = notifi.object;
//    NSArray *arr = [rootDict objectForKey:@"body"];
//    if (arr.count == 0) {
//        
//    }else{
//        for (NSDictionary *dict in arr) {
//            DHMessageModel *item = [[DHMessageModel alloc]init];
//            NSDictionary *contentDict = [dict objectForKey:@"content"];
//            item.messageId = [dict objectForKey:@"id"];
//            [item setValuesForKeysWithDictionary:contentDict];
//            [item setValuesForKeysWithDictionary:dict];
//            [item setValuesForKeysWithDictionary:[rootDict objectForKey:@"head"]];
//            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//            item.userId = userId;
//            item.targetId = item.fromUserAccount;
//            if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
//                [DHMessageDao insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
//            }
//            [self.recMesgArr addObject:item];
//        }
//        [self updateBadgeValue];
//    }
//}


/**
 *  更新角标
 */
- (void)updateBadgeValue{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self.viewControllers objectAtIndex:2] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",_recMesgArr.count]];
        DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
        [sound play];
    });
}
// 系统参数请求  http://115.236.55.163:8086/LP-bus-msc/f_101_10_1.service
- (void)getSystemDataInfos
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_101_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    __block ViewController *SystemVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *sysArray = infoDic[@"body"];
            
            for (NSDictionary *dict in sysArray) {
                
                NSArray *b98Arr = dict[@"b98"];
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
                    [[NSUserDefaults standardUserDefaults] setObject:timestemDict forKey:@"lp_pay_way"];
                }else if ([dict[@"b20"] isEqualToString:@"url_lp_bus_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_author_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_file_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_pay_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_im_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_upgrade_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_h5_msc"] ){
                    for (NSDictionary *dict2 in b98Arr) {
                        DHDomainModel *item = [[DHDomainModel alloc]init];
                        item.apiId = [NSString stringWithFormat:@"%@/%@/",[dict2 objectForKey:@"b22"],[dict2 objectForKey:@"b20"]];
                        item.api = [NSString stringWithFormat:@"%@/%@/",[dict2 objectForKey:@"b22"],[dict2 objectForKey:@"b20"]];
                        item.apiName = [dict2 objectForKey:@"b20"];
                        item.apiType = @"0";
                        if (![DHDomainDao checkApiWithApi:item.api]) {
                            [DHDomainDao asyncInsertApiToDbWithItem:item];
                        }
                    }
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
                    
                }

                
            }
        }
        
        //NSLog(@"---系统参数---%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
// f_119_11_2
- (void)configSayHelloMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (!item) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self configSayHelloMessage];
        });
    }else{
        NSString *p1 = [NSGetTools getUserSessionId];//sessionId
        NSString *url = [NSString stringWithFormat:@"%@f_119_11_2.service?p2=%@&p1=%@",kServerAddressTest2,item.b80,p1];
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
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showHint:@"欢迎进入触陌世界~"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFromRegitser"];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString * )pushPayNotificationWhenPayForFailure:(NSNotification *)sender{
    NSInteger PayFlag=[sender.object integerValue];
    //获取用户账号信息
    NSNumber *p2 = [NSGetTools getUserID];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:[NSString stringWithFormat:@"%@",p2]];
    
    //获取官方支付账号
    NSString *targetRobotId =[[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
    DHUserInfoModel *robotUser = [DHUserInfoDao getUserWithCurrentUserId:targetRobotId];
    if (robotUser) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [dat timeIntervalSince1970]*1000;
        long long b = a;
        NSString *timeString = [NSString stringWithFormat:@"%lld", b];//转为字符型
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *fmtDate = [fmt stringFromDate:dat];
        DHMessageModel *msg = [[DHMessageModel alloc] init];
        msg.toUserAccount = userinfo.b80;
        msg.roomName = robotUser.b52;
        msg.roomCode = userinfo.b80;
        
        //得到内容
        NSString *messageInfo=nil;
        NSString *MessageFlag=nil;
        switch (PayFlag) {
            case 5:
            {   //Vip
                messageInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"message_vip_content"];
                MessageFlag=@"5";
            }
                break;
            case 6:
            {
                //写信
                MessageFlag=@"6";
                messageInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"message_letter_content"];
            }
                break;
            default:
                break;
        }
        
        msg.messageType = MessageFlag;
        msg.message = messageInfo;
        msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
        msg.timeStamp = fmtDate;
        msg.fromUserAccount = robotUser.b80;
        
        msg.messageId = [self configUUid];// 消息ID
        msg.token = @"";
        msg.roomCode = robotUser.b80;
        msg.targetId = robotUser.b80;
        
        msg.userId = userinfo.b80;
        msg.isRead = @"1";
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:msg];
        // 存储到数据库
        if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
            [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",userinfo.b80]];
        }
        //    _timerIndex ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
            [sound play];
        });
        return robotUser.b80;
    }else{
        return nil;
    }
    
}
//登陆发送支付小助手
- (void )pushPayNotificationWhenUserLogin:(NSNotification *)sender{
    

    NSInteger PayFlag=[sender.object integerValue];
    //获取用户账号信息
    NSNumber *p2 = [NSGetTools getUserID];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:[NSString stringWithFormat:@"%@",p2]];

    //获取官方支付账号
    NSString *targetRobotId =[[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
    
    NSArray *array = [DHMessageDao selectMessageDBWithUserId:[NSString stringWithFormat:@"%@",p2] targetId:targetRobotId atIndex:0];
    //发消息
    
        NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"messageType==$NAME"];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%ld",PayFlag], @"NAME",nil];
        //                NSPredicate *pre=[preTemplate predicateWithSubstitutionVariables: dic];
        NSPredicate *pre=[preTemplate predicateWithSubstitutionVariables:dic];
        
        for(int i=0;i<[array count];i++){
            DHMessageModel *person=[array objectAtIndex: i];
            
            if ([pre evaluateWithObject: person]) {
                return;
            }
        }
        
        DHUserInfoModel *robotUser = [DHUserInfoDao getUserWithCurrentUserId:targetRobotId];
        if (robotUser) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a = [dat timeIntervalSince1970]*1000;
            long long b = a;
            NSString *timeString = [NSString stringWithFormat:@"%lld", b];//转为字符型
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *fmtDate = [fmt stringFromDate:dat];
            DHMessageModel *msg = [[DHMessageModel alloc] init];
            msg.toUserAccount = userinfo.b80;
            msg.roomName = robotUser.b52;
            msg.roomCode = userinfo.b80;
            
            //得到内容
            NSString *messageInfo=nil;
            NSString *MessageFlag=nil;
            switch (PayFlag) {
                case 5:
                {   //Vip
                    messageInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"message_vip_content"];
                    MessageFlag=@"5";
                }
                    break;
                case 6:
                {
                    //写信
                    MessageFlag=@"6";
                    messageInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"message_letter_content"];
                }
                    break;
                default:
                    break;
            }
            
            msg.messageType = MessageFlag;
            msg.message = messageInfo;
            msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
            msg.timeStamp = fmtDate;
            msg.fromUserAccount = robotUser.b80;
            
            msg.messageId = [self configUUid];// 消息ID
            msg.token = @"";
            msg.roomCode = robotUser.b80;
            msg.targetId = robotUser.b80;
            
            msg.userId = userinfo.b80;
            msg.isRead = @"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:msg];
            // 存储到数据库
            if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
                [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",userinfo.b80]];
            }
            //    _timerIndex ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
                [sound play];
            });
            
        }else{
            
        }
    
    
    
}


@end
