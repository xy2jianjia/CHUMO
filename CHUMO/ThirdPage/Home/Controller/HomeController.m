//
//  HomeController.m
//  微信
//
//  Created by Think_lion on 15-6-14.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+CH.h"
#import "HomeViewCell.h"
#import "HomeModel.h"
//#import "FmdbTool.h"
#import "ChatController.h"
#import "FmbdMessage.h"
#import "NSGetTools.h"
#import "MyDataViewController.h"
#import "DHContactViewController.h"
#import "DHBlackListDao.h"
#import "NSObject+Chat.h"
#import "AFNHttpRequestOPManager.h"
@interface HomeController ()<UISearchBarDelegate>
@property (nonatomic,assign)int messageCount; //未读的消息总数
@property (nonatomic,strong) NSMutableArray *searchList;

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) NSString *cityNo;
@property (nonatomic,strong) UIView *netWrokView;//网络状态
@property (nonatomic,strong) UIView *netHeadView;
@property (nonatomic,assign) BOOL isnetWroking;
/**
 *  朋友列表
 */
@property (nonatomic,strong) NSMutableArray *friendArr;
@end

@implementation HomeController


-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}
//-(NSMutableArray *)chatData
//{
//    if(!_chatData){
//        _chatData=[NSMutableArray array];
//    }
//    return _chatData;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.searchList = [NSMutableArray array];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    [self readChatData];
}
- (void)asyncGetFriendsListIsLoadMore:(BOOL)isLoadMore{
    NSInteger page = self.friendArr.count / 20;
    if (isLoadMore) {
        if (page == 0) {
            return;
        }
    }
    __weak typeof (&*self )weakSelf = self;
    [HttpOperation asyncGetFriendListWithPage:[NSString stringWithFormat:@"%ld",page + 1] queue:nil completed:^(NSArray *friendList, NSInteger code,NSInteger hasNext) {
        [self.friendArr addObjectsFromArray:friendList];
        if (hasNext == 1) {
            [weakSelf asyncGetFriendsListIsLoadMore:YES];
        }
    }];
}
- (void)new_didReLoadFriendDataArr:(NSNotification *)notifi{
    [self asyncGetFriendsListIsLoadMore:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kUIColorFromRGB(0xffffff);
   
    
    self.tableView.backgroundColor=kUIColorFromRGB(0xffffff);
//    [self registerChatNotification];
    [Mynotification addObserver:self selector:@selector(new_didReceiveRobotMessage:) name:NEW_DIDRECEIVR_ROBOT_MESSAGE object:nil];
    [Mynotification addObserver:self selector:@selector(new_didReceiveOnlineMessage:) name:NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
//    [Mynotification addObserver:self selector:@selector(new_didReceiveOfflineMessage:) name:NEW_DIDRECEIVE_OFFLINE_MESSAGE_NOTIFICATION object:nil];
    [Mynotification addObserver:self selector:@selector(new_didSendedRecommendMessage:) name:@"new_didSendedRecommendMessage" object:nil];
    [Mynotification addObserver:self selector:@selector(new_didReLoadFriendDataArr:) name:@"new_didReLoadFriendDataArr" object:nil];
    self.navigationItem.title = @"信箱";
    NSDictionary *dict = [NSGetTools getCLLocationData];
    self.cityNo = [dict objectForKey:@"a9"];
    // 每隔一秒获取消息
   //1.添加搜索栏
//    [self setupSearchBar];
//    //2.从本地数据库中读取正在聊天的好友数据
//    [self readChatData];
////    3.添加导航栏右侧的按钮
//    [self setupRightButtun];
    //监听消息来得通知
//    [Mynotification addObserver:self selector:@selector(didReceiveOnLineMessage:) name:@"didReceiveOnLineMessage" object:nil];
    self.isnetWroking=YES;
    
    self.tableView.tableHeaderView=self.netHeadView;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取朋友接口
        self.friendArr = [NSMutableArray array];
        [self asyncGetFriendsListIsLoadMore:NO];
    });
    
    
//    [AFNHttpRequestOPManager sharedClient:self];
    
}
- (void)new_didSendedRecommendMessage:(NSNotification *)notifi{
    [self readChatData];
}
#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readChatData
{
    
    //有网络,读取数据库聊天信息
    if (self.isnetWroking) {
        self.chatData = [NSMutableArray array];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        NSArray *arr = [DHMessageDao getChatListWithUserId:userId roomCode:nil];
        for (int i = 0; i < arr.count; i ++) {
            if (![self.chatData containsObject:arr[i]]) {
                BOOL isBlack = [DHBlackListDao checkBlackListUserWithUsertId:[arr[i] targetId]];
                if (isBlack) {
                    
                }else{
                    //请求官方支付账号
                    NSString *officialID = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages_user_id"];
                    
                    if ([[arr[i] targetId] isEqualToString:officialID]) {
                        [self.chatData insertObject:arr[i] atIndex:0];
                    }else{
                        //已经有支付小助手
                        [self.chatData addObject:arr[i]];
                    }
                    
                }
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    DHMessageModel *mesg = [arr objectAtIndex:i];
//                    [self getTargetUserInfoWithUserId:mesg.targetId needReloadData:NO];
//                });
            }
        }
        // 没有数据
        if (self.chatData.count == 0) {
            if (!_imageV) {
                _imageV = [[UIImageView alloc]init];
                [self.view addSubview:_imageV];
            }
            _imageV.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-71.5, 102-64, 143, 156);
            _imageV.image = [UIImage imageNamed:@"mailbox-pattern.png"];
            
            
            if (!_label) {
                _label = [[UILabel alloc]init];
                [self.view addSubview:_label];
            }
            _label.frame = CGRectMake(CGRectGetMinX(_imageV.frame), CGRectGetMaxY(_imageV.frame)+31, CGRectGetWidth(_imageV.frame), 30);
            _label.textAlignment = NSTextAlignmentCenter;
            _label.text = @"还没有人勾搭你";
            
            if (!_btn) {
                _btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.view addSubview:_btn];
            }
            
            _btn.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-55, CGRectGetMaxY(_label.frame)+18, 109.5, 39);
//            [_btn setBackgroundImage:[UIImage imageNamed:@"button-data.png"] forState:UIControlStateNormal];
            _btn.backgroundColor=kUIColorFromRGB(0x934de6);
            _btn.layer.cornerRadius=39.0/2;
            _btn.layer.masksToBounds=YES;
            [_btn setTitle:@"完善资料试试" forState:UIControlStateNormal];
            _btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [_btn addTarget:self action:@selector(toInfoDetailVc:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_btn removeFromSuperview];
                [_label removeFromSuperview];
                [_imageV removeFromSuperview];
                _btn = nil;
                _label = nil;
                _imageV = nil;
            });
            
        }
        //    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        self.messageCount = (int )[DHMessageDao getBadgeValueWithTargetId:nil currentUserId:userId];
        //如果消息数大于0
        if(self.messageCount>0){
            //如果消息总数大于99
            if(self.messageCount>=99){
                self.tabBarItem.badgeValue=@"99+";
            }else{
                self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
            }
            
        }else{
            self.tabBarItem.badgeValue=nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    
}
/**
 *  获取用户列表信息
 *
 *  @param userIds  userId数组   EG:1001,1002,1003
 */
- (void)getUserInfoListWithUserIds:(NSArray *)userIds{
    // 没有数据就停止
    if (userIds.count <= 0) {
        return;
    }
    NSMutableString *idsStr = [NSMutableString string];
    for (int i = 0; i < userIds.count ; i ++ ) {
        NSNumber *aid = [userIds objectAtIndex:i];
        if (i == userIds.count - 1) {
            [idsStr appendFormat:@"%@",aid];
        }else{
            [idsStr appendFormat:@"%@,",aid];
        }
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    NSMutableDictionary *dict = [[NSGetTools getAppInfoDict] mutableCopy];
    [dict setObject:sessionId forKey:@"p1"];
    [dict setObject:userId forKey:@"p2"];
    [dict setObject:idsStr forKey:@"a117"];
    
    NSString *url = [NSString stringWithFormat:@"%@f_108_14_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSArray *bodyArr = infoDic[@"body"];
            for (NSDictionary *temp in bodyArr) {
                DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                if ([temp isKindOfClass:[NSDictionary class]]) {
                    [item setValuesForKeysWithDictionary:temp];
                    if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                        [DHUserInfoDao insertUserToDBWithItem:item];
                    }else{
                        [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}

// 完善信息
- (void)toInfoDetailVc:(UIButton *)sender{
    
    MyDataViewController *myDataVC = [MyDataViewController new];
    [self.navigationController pushViewController:myDataVC animated:YES];
    
}


#pragma mark 删除好友时同步的聊天数据
-(void)deleteFriend:(NSNotification*)note
{
    NSString *uname=[note object];
    //初始化模型的索引
    NSInteger index=0;
    for(HomeModel *model in self.chatData){
        if([model.uname isEqualToString:uname]){
            NSLog(@"%@     %@",model.uname, uname);
            [_chatData removeObjectAtIndex:index];
            //从本地数据库清除
//            [FmdbTool deleteWithName:uname];
            //重新刷新标示图
            [self.tableView reloadData];
        }
        index++;
    }
}
#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    UISearchBar *search=[[UISearchBar alloc]init];
    
    search.frame=CGRectMake(10, 5, ScreenWidth-20, 25);
    search.barStyle=UIBarStyleDefault;
    search.backgroundColor=[UIColor whiteColor];
  
    //实例化一个搜索栏
    //取消首字母吧大写
    search.autocapitalizationType=UITextAutocapitalizationTypeNone;
    search.autocorrectionType=UITextAutocorrectionTypeNo;
    //代理
    search.placeholder=@"搜索";
    search.layer.borderWidth=0;
    
    UIView *searchV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    searchV.backgroundColor=[UIColor colorWithWhite:0.890 alpha:0.7];
    [searchV addSubview:search];
    search.delegate=self;
    self.tableView.tableHeaderView=searchV;
    
    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return YES;
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[self.chatData filteredArrayUsingPredicate:preicate]];
    //刷新表格
    return YES;
}
#pragma mark
-(void)setupRightButtun
{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithIcon:@"Personal-Center" highIcon:nil target:self action:@selector(rightClick)];

}
-(void)rightClick
{
    DHContactViewController *vc = [[DHContactViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
    vc.contactArr = [NSMutableArray arrayWithArray:self.chatData];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchList count];
    }else{
        return self.chatData.count;
    }
    
}
#pragma mark 单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewCell *cell=[HomeViewCell cellWithTableView:tableView cellWithIdentifier:@"homeCell"];
    
    DHMessageModel *item=self.chatData[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSInteger unReadCount = [DHMessageDao getBadgeValueWithTargetId:item.targetId currentUserId:userId];
    HomeModel *model = [[HomeModel alloc]init];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:item.targetId];
    if (!userInfo) {
        [self getTargetUserInfoWithUserId:item.targetId needReloadData:YES];
    }
    model.jid = userInfo.b80;
    model.uname =  userInfo.b52;
    model.cityFlag = [userInfo.b9 isEqualToString:_cityNo]? YES:NO;//同城
    if ([userInfo.b143 integerValue]==5) {
        model.cityFlag = YES;
    }
    model.vipFlag = [userInfo.b144 isEqualToString:@"2"]? NO:YES; //是否vip 1:vip 2:非vip
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger messageType = [item.messageType integerValue];
        NSString *body = nil;
        if (messageType == 1) {
            body = item.message;
        }else if (messageType == 3){
            body = @"[ 图片 ]";
        }else if (messageType == 4){
            body = @"[ 语音 ]";
        }else if (messageType == 5){
            body = @"[ 图片 ]";
        }else if (messageType == 6){
            body = @"[ 图片 ]";
        }else if (messageType == 7){
            body = @"[ 视频 ]";
        }else if (messageType == 8){
            body = @"[ 位置 ]";
        }else if (messageType == 8){
            body = @"[ 文件 ]";
        }
        model.body = body;
    });
    
    model.time = item.timeStamp;
    model.badgeValue = [NSString stringWithFormat:@"%ld",unReadCount];
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    model.headerIcon = userInfo.b57;
//    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
    cell.homeModel=model;
    return cell;
    
    
}
#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //隐藏对象的小红点
    DHMessageModel *item=self.chatData[indexPath.row];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:item.targetId];
    //如果消息数大于0
    if(self.messageCount>0){
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
    }else{
        self.tabBarItem.badgeValue=nil;
    }
    //重新刷新表视图
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ChatController *chat=[[ChatController alloc]init];
        chat.item = item;
        chat.userInfo = userinfo;
        [self.navigationController pushViewController:chat animated:YES];
//    });
    
    // 修改阅读
    [DHMessageDao updateMessageIsReadStatusWithStatus:@"2" targetId:item.targetId];
}
- (void)getTargetUserInfoWithUserId:(NSString *)userId needReloadData:(BOOL)needReloadData{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    //    LP-bus-msc/ f_108_13_1
    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,sessionId,userId,appinfoStr];
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
            if ([dict2 isKindOfClass:[NSDictionary class]]) {
                [item setValuesForKeysWithDictionary:dict2];
                if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                    [DHUserInfoDao insertUserToDBWithItem:item];
                }else{
                    [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
                }
            }
        }
        if (needReloadData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}
-(void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
#pragma mark 滑动删除单元格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 改变删除单元格按钮的文字
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark 单元格删除的点击事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HomeModel *homeModel=self.chatData[indexPath.row];
    DHMessageModel *item = self.chatData[indexPath.row];
//    NSString *name=homeModel.uname;
    //当点击删除按钮的时候执行
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //删除该好友所有的聊天数据
        [self.chatData removeObject:item];
        // 删除ui
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        [DHMessageDao deleteChatWithTargetId:item.targetId userId:item.userId];
        
        // 更新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//            [self viewWillAppear:YES];
        });
    }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            //                        [self showHint:@"已经被拉黑，不接收此人的消息"];
        });
    }else{
        if (!userInfo) {
            [self getTargetUserInfoWithUserId:msg.targetId needReloadData:YES];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
        [self readChatData];
    }
}


/**
 *  接收在线消息
 *
 *  @param notifi
 */
- (void)new_didReceiveRobotMessage:(NSNotification *)notifi{
    DHMessageModel *item = notifi.object;
    // 判断是否是当前聊天对象的消息，如果是，就接收，不是就放弃
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    item.userId = userId;
    item.targetId = item.fromUserAccount;
    item.isRead = @"1";
    if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
    }
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:item.fromUserAccount];
    BOOL isBlack = [DHBlackListDao checkBlackListUserWithUsertId:item.targetId];
    if (isBlack) {
        
    }else{
        if (!userInfo) {
            [self getTargetUserInfoWithUserId:item.fromUserAccount needReloadData:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self readChatData];
        });
    }
    
}
//滚动视图停止编辑
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)dealloc
{
    [Mynotification removeObserver:self];
//    NSLog(@"销毁了");
}
#pragma mark 实时检测网络
-(void)havingNetworking:(NSNotification *)isNetWorking{
    NSString *sender = isNetWorking.object;
    self.isnetWroking=[sender boolValue];
    if ([sender boolValue]) {
        self.tableView.tableHeaderView=self.netHeadView;
    }else{
        self.tableView.tableHeaderView=self.netWrokView;
        
    }
}
-(UIView *)netWrokView{
    if (!_netWrokView) {
        _netWrokView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        _netWrokView.backgroundColor=kUIColorFromRGB(0xffffff);
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
        headView.backgroundColor=kUIColorFromRGB(0xffdfdf);
        
        UIImageView *loogImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 24)];
        loogImag.image=[UIImage imageNamed:@"w_xinxiang_jintanhao"];
        [headView addSubview:loogImag];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loogImag.frame)+15, 8, ScreenWidth-CGRectGetMaxX(loogImag.frame)-10-15, 24)];
        titleLabel.textColor=kUIColorFromRGB(0xaaaaaa);
        titleLabel.text=@"网络连接不可用";
        titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [headView addSubview:titleLabel];
        
        [_netWrokView addSubview:headView];
        
    }
    return _netWrokView;
}
-(UIView *)netHeadView{
    if (!_netHeadView) {
        
        _netHeadView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _netHeadView.backgroundColor=kUIColorFromRGB(0xffffff);
        
    }
    return _netHeadView;
}
#pragma mark 分区头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.netWrokView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60.0f;
//}
@end
