//
//  NearPeopleViewController.m
//  StrangerChat
//
//  Created by long on 15/11/4.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NearPeopleViewController.h"
#import "NearPeopleTableViewCell.h"
//#import "NearPeopleModel.h"
//#import "RCDChatViewController.h"
#import "ChatController.h"
#import "Homepage.h"
#import "DHConfigHeaderRefreshTool.h"
#import "RefreshController.h"
#import "JYSayHelloDao.h"
#import "JYNavigationController.h"
@interface NearPeopleViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *allDataArray;
@property (nonatomic,assign) BOOL isnetWroking;

@end

@implementation NearPeopleViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.title = @"附近";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
//    self.isnetWroking=YES;
    self.allDataArray = [NSMutableArray array];
    [self headerRereshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
    
}
#pragma mark -- 下拉上提刷新
//- (void)setupRefresh
//{
////     1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    #warning 自动刷新(一进入程序就下拉刷新)
//     [self.tableView headerBeginRefreshing];
//    
////     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    
//}
#pragma mark 开始进入刷新状态
// 下拉
- (void)headerRereshing
{
    [self.allDataArray removeAllObjects];
    // 设置header
    self.tableView.mj_header = [DHConfigHeaderRefreshTool configHeaderWithTarget:self action:@selector(asyncLoadDataOfDown)];
    [self.tableView.mj_header beginRefreshing];
}

// 上拉
- (void)footerRereshing
{
    __unsafe_unretained typeof(self) collectionV = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSNumber *b96 = [NSGetTools getNearPeopleB96];// 获取是否有下一页
        NSNumber *a69 = [NSGetTools getUserSexInfo];// 性别
        // 位置
        NSDictionary *addressDict = [NSGetTools getCLLocationData];
        if ([b96 intValue] == 1) {
            NSString *a9 = addressDict[@"a9"];
            NSString *a67 = addressDict[@"a67"];
            NSNumber *a38Num = addressDict[@"a38"];// 经
            NSNumber *a40Num = addressDict[@"a40"];// 纬
            CGFloat a38 = [a38Num floatValue];
            CGFloat a40 = [a40Num floatValue];
            static int a95 = 1;
            a95 = a95 + 1;
            [collectionV asyncLoadData];
            
        }else{
            [NSGetTools showAlert:@"没有更多的人，过一会再试试~"];
        }
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [collectionV.tableView.mj_footer endRefreshing];
        });
    }];
}
//上啦加载
- (void)asyncLoadData{
    NSDictionary *locationDict = [NSGetTools getCLLocationData];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
    NSNumber *a69 = [NSGetTools getUserSexInfo];
    [temp setObject:a69 forKey:@"a69"];
    [temp setObject:@"1" forKey:@"a95"];
    [self asyncLoadDataWithUrl:nil parameters:temp];
}
//下拉加载
- (void)asyncLoadDataOfDown{
    [self.allDataArray removeAllObjects];
    NSDictionary *locationDict = [NSGetTools getCLLocationData];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:locationDict];
    NSNumber *a69 = [NSGetTools getUserSexInfo];
    [temp setObject:a69 forKey:@"a69"];
    [temp setObject:@"1" forKey:@"a95"];
    [self asyncLoadDataWithUrl:nil parameters:temp];
}
- (void)asyncLoadDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    
    
    
    NSMutableString *idsStr=[NSMutableString string];
    for (DHUserInfoModel *model in self.allDataArray) {
        [idsStr appendString:[NSString stringWithFormat:@"%@",model.b80]];
        [idsStr appendString:@","];
    }
    NSLog(@"%@",idsStr);
    if (url) {
        if ([idsStr length] == 0) {
            url = [NSString stringWithFormat:@"%@f_108_20_1.service?p1=%@&p2=%@&",url,p1,p2];
        }else{
            url = [NSString stringWithFormat:@"%@f_108_20_1.service?p1=%@&p2=%@&",url,p1,p2];
        }
        
    }else{
        
        if ([idsStr length] == 0) {
            url = [NSString stringWithFormat:@"%@f_108_20_1.service?p1=%@&p2=%@",kServerAddressTest2,p1,p2];
        }else{
            url = [NSString stringWithFormat:@"%@f_108_20_1.service?a117=%@&p1=%@&p2=%@",kServerAddressTest2,idsStr,p1,p2];
        }
        
    }

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //    NSLog(@"-----url-%@--",url);
    [manger GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self footerRereshing];
        [self.tableView.mj_header endRefreshing];
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        // b96 是否有下一页 0:没有 1:有  b95 当前页数
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateNearPeopleB96WithNum:b96];// 更新b96
            for (NSDictionary *dict2 in modelArr) {
                DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                
                [item setValuesForKeysWithDictionary:dict2];
                if ([item.b143 integerValue] != 2) {
//                    [self.allDataArray addObject:item];
                    [self.allDataArray addObject:item];
                }
                
                if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                    [DHUserInfoDao insertUserToDBWithItem:item];
                }else{
                    [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"apiName"];
        __block DHDomainModel *apiModel = nil;
        if (flag) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                apiModel = [DHDomainDao asyncGetApiWithApiName:@"url_lp_bus_msc_2"];
                NSDictionary * parameters = [NSGetTools getCLLocationData];
                [self asyncLoadDataWithUrl:apiModel.api parameters:parameters];

                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apiName"];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
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
                [self asyncLoadDataWithUrl:apiModel.api parameters:parameters];

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
    static NSString *cellIdentifier = @"cellIdentifier3";
    NearPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NearPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,got(20)+gotHeight(50),0,0)];
    }
    if (self.allDataArray.count != 0) {
        cell.model = self.allDataArray[indexPath.row];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        if (![JYSayHelloDao checkSayHellWithTargetId:cell.model.b80 userId:userId]) {
           [cell.hiButton setBackgroundImage:[UIImage imageNamed:@"w_fujin_sayhi.png"] forState:UIControlStateNormal];
            cell.hiButton.enabled=YES;
        }else{
            [cell.hiButton setBackgroundImage:[UIImage imageNamed:@"w_fujin_sayhi_zhihui.png"] forState:UIControlStateNormal];
            cell.hiButton.enabled=NO;
        }
    }
    
    cell.hiButton.tag = indexPath.row;
    [cell.hiButton addTarget:self action:@selector(hiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *showUserinfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserinfoTap:)];
    [cell.iconImageView addGestureRecognizer:showUserinfoTap];
    cell.iconImageView.userInteractionEnabled = YES;
    cell.iconImageView.tag = indexPath.row;
    return cell;
    
}
/**
 *  点击头像显示用户信息
 *
 *  @param sender
 */
- (void)showUserinfoTap:(UITapGestureRecognizer *)sender{
    
    DHUserInfoModel *model = self.allDataArray[sender.view.tag];
    Homepage *otherVC = [[Homepage alloc]init];
    otherVC.touchP2 = model.b80;
    otherVC.item = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:otherVC];
        [self presentViewController:nav animated:YES completion:nil];
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self uoloadLookMeInfo:model];
//    });
    
}

// 打招呼
- (void)hiButtonAction:(UIButton *)sender
{
    NSInteger indexNum = sender.tag;
//    NearPeopleModel *model = self.allDataArray[indexNum];
    DHUserInfoModel *model = self.allDataArray[indexNum];
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
                //是否打过招呼
                if (![JYSayHelloDao checkSayHellWithTargetId:targetId userId:userId]) {
                    //招呼图片
                    NearPeopleTableViewCell *cell=(NearPeopleTableViewCell*)[[sender superview]superview];
                    [cell.hiButton setBackgroundImage:[UIImage imageNamed:@"w_fujin_sayhi_zhihui.png"] forState:UIControlStateNormal];
                    cell.hiButton.enabled=NO;
                    
                    //插入打招呼表
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *dateTime=[[NSDate alloc]init];
                    model.sayHellTime=[dateFormatter stringFromDate:dateTime];
                    model.targetType=@"1";
                    [JYSayHelloDao insertSayHellListUserToDBWithItem:model];
                    
                    //发送打招呼信息
                    NSString *token = [NSGetTools getToken];
                    NSDateFormatter *format = [[NSDateFormatter alloc]init];
                    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *date = [format stringFromDate:[NSDate date]];
                    
                    DHMessageModel *item = [[DHMessageModel alloc]init];
                    item.messageId = [self configUUid];
                    item.messageType = @"1";
                    
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
                    
                    if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
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
                        //        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"lastRobotMessageType",model.b80,@"targetRobotId", nil];
                        
                        [Mynotification postNotificationName:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:item];
                    }
                    
                    
                    //        ChatController *vc = [[ChatController alloc]init];
                    //        vc.item = item;
                    //        vc.userInfo = model;
                    //        [self.navigationController pushViewController:vc animated:YES];
                }else{
                    return;
                }
                
                
            }
        }
    }];
    
    
    
    
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
