//
//  ChatController.m
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatController.h"
#import "ChatBottomView.h"
#import "ChatViewCell.h"
//#import "XMPPJID.h"
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "SendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotionTool.h"
#import "UIView+MJ.h"
#import "Homepage.h"
#import "HFVipViewController.h"
#import "DHMsgPlaySound.h"
#import "DHAlertView.h"
#import "KxMenu.h"
#import "ReportController.h"
#import "DHBlackListDao.h"
#import "SocketManager.h"
//#import "YS_HtmlPayViewController.h"
#import "YS_SelfPayViewController.h"
#import "YS_VipCenterViewController.h"
#import "YS_ApplePayVipViewController.h"
#import "MonthlyViewController.h"
#import "JYNavigationController.h"
#import "YS_SelfMailPayViewController.h"
@interface ChatController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,ChatBottomViewDelegate,UIAlertViewDelegate,DHAlertViewDelegate,ChatPayButtonProtocol>

//底部工具栏
@property (nonatomic,weak) ChatBottomView *chatBottom;
//查询结果集合
//@property (nonatomic,strong)  NSFetchedResultsController *resultController;
//定义一个表视图
@property (nonatomic,weak) UITableView *table;
//存放messageFrameModel的数组
@property (nonatomic,strong) NSMutableArray *frameModelArr;
//内容输入框
@property (nonatomic,weak) SendTextView *bottomInputView;
//表情键盘
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
//用户自己的头像
@property (nonatomic,strong) NSData *headImage;

@property (nonatomic,assign) BOOL isChangeHeight;
//表视图的高
@property (nonatomic,assign) CGFloat tableViewHeight;

//是否改变键盘样式
@property (nonatomic,assign) BOOL  changeKeyboard;
/**
 *  消息model
 */
@property (nonatomic,strong) DHMessageModel *msg;
/**
 *   每次下拉刷新历史数据，记录要跳到在哪一行
 */
//@property (nonatomic,assign) NSInteger scrollToRow;
///**
// *  是否是下拉刷新加载历史数据，yes：是，no：不是
// */
//@property (nonatomic,assign) BOOL isLoadMoreData;

@end


@implementation ChatController


-(NSMutableArray *)frameModelArr
{
    if(_frameModelArr==nil){
        _frameModelArr=[NSMutableArray array];
    }
    return _frameModelArr;
}

- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = ScreenWidth;
        self.kerboard.height = 216;
    }
    return _kerboard;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.chatBottom.hidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
    self.chatBottom.hidden = YES;
    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    for (UIView *view in window.subviews) {
//        if ([view isKindOfClass:[ChatBottomView class]]) {
//            [view removeFromSuperview];
//            break;
//        }
//    }
}
- (void)viewDidLoad
{
//    self.isLoadMoreData = NO;
    [super viewDidLoad];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    [Mynotification addObserver:self selector:@selector(new_didReceiveOnlineMessage:) name:NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:self.item.targetId];
    if (![userinfo.b143 isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"titlebar-more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(reportAction)];
        //3.添加底部view
        [self setupBottomView];
    }
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置背景颜色
    self.view.backgroundColor=[UIColor whiteColor];
//    // 不是会员
//    if ([self.userInfo.b143 integerValue] == 2) {
//        
//    }
    
//    [self createRoom];
    //1 添加表示图
    [self setupTableView];
    //2.加载聊天数据
    [self loadChatData];
    
    //监听键盘的移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide:) name:UIKeyboardWillHideNotification object:nil];
    // 监听表情选中的通知
    [Mynotification addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [Mynotification addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    //监听表情发送按钮点击
    [Mynotification addObserver:self selector:@selector(faceSend) name:FaceSendButton object:nil];
    [Mynotification addObserver:self selector:@selector(sendMessageResult:) name:SendMessageResult object:nil];
    [Mynotification addObserver:self selector:@selector(gethistoryMessageResult:) name:GetMessageResult object:nil];
    [Mynotification addObserver:self selector:@selector(new_didReceiveRobotMessage:) name:NEW_DIDRECEIVR_ROBOT_MESSAGE object:nil];
    [self headerRereshing];
}
- (void)headerRereshing{
//    self.isLoadMoreData = YES;
    // 设置header
    self.table.mj_header = [DHConfigHeaderRefreshTool configHeaderWithTarget:self action:@selector(getHistoryData)];
//    [self.table.mj_header beginRefreshing];
}
- (void)getHistoryData{
    self.bottomInputView.editable = NO;
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 记录上次最早的时间
    NSString *lastTime = [[[self.frameModelArr firstObject] messageModel] time];
    if (!lastTime) {
        lastTime = [fmt stringFromDate:[NSDate date]];
    }
    NSArray *array = [DHMessageDao selectMessageDBWithUserId:_item.userId targetId:_item.targetId lastTime:lastTime];
    DHUserInfoModel *userInfo = self.userInfo;
    NSString *targetHeaderUrl = userInfo.b57;
    self.navigationItem.title = userInfo.b52;
    NSString *headerUrl = [NSGetTools getIconB57];
    
    for (DHMessageModel *item in array) {
        MessageModel *msgModel=[[MessageModel alloc]init];
        msgModel.body=item.message;
        if ([item.messageType integerValue] == 1) {
            msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
        }else{
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[item.message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            msgModel.attributedBody = attrStr;
        }
        msgModel.time=item.timeStamp;
        if (self.frameModelArr.count < 1) {
            msgModel.hiddenTime = NO;
        }else{
            MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
            NSString *lastTime = itemMsg.messageModel.time;
            NSDate *date1 = [fmt dateFromString:lastTime];
            NSDate *date2 = [fmt dateFromString:item.timeStamp];
            NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
            if (intervalMin < 1) {
                msgModel.hiddenTime = YES;
            }else{
                msgModel.hiddenTime = NO;
            }
        }
        msgModel.to=item.toUserAccount;
        msgModel.messageType = item.messageType;
        msgModel.targetUserType = item.targetUserType;
        msgModel.targetId = _item.targetId;
        // 设置头像
        msgModel.targetHeaderUrl = targetHeaderUrl;
        msgModel.headerUrl = headerUrl;
        //是不是当前用户
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        if ([item.fromUserAccount isEqualToString:userId]) {
            msgModel.isCurrentUser=YES;
        }else{
            msgModel.isCurrentUser=NO;
        }
        //根据frameModel模型设置frame
        MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
        // 获取音频的时间
        float audioDurationSeconds = item.fileDuration;
        UIImage *plaImage = nil;
        if ([item.messageType integerValue] == 3) {
            BOOL isEixt = [self isFileExistWithTimeStamp:item.timeStamp targetId:_item.targetId messageType:3];
            if (!isEixt) {
                plaImage = [UIImage imageNamed:@"list_item_icon.png"];
                msgModel.chatImageUrl = item.fileUrl;
            }else{
                UIImage *image = [self getImageFromShandBoxWithTimeStamp:item.timeStamp targetId:_item.targetId];
                plaImage = image;
                msgModel.localChatImage = plaImage;
            }
        }else if ([item.messageType integerValue] == 4){
            msgModel.audioDuration = audioDurationSeconds;
            BOOL isEixt = [self isFileExistWithTimeStamp:item.timeStamp targetId:_item.targetId messageType:4];
            if (!isEixt) {
                // 异步保存到沙盒
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *chatImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.fileUrl]];
                    [self saveChatFileWithFile:chatImageData timeStamp:item.timeStamp targetId:_item.targetId];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            msgModel.fileUrl = item.fileUrl;
            frameModel.messageModel=msgModel;
            BOOL isBlack = [DHBlackListDao checkBlackListUserWithUsertId:item.targetId];
            if (isBlack) {
                
            }else{
                [self.frameModelArr insertObject:frameModel atIndex:0];
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table.mj_header endRefreshing];
        self.bottomInputView.editable = YES;
        [self.table reloadData];
        [self scrollToBottomWithAnimated:NO];
    });
}

#pragma mark 加载聊天数据
-(void)loadChatData{
     self.bottomInputView.editable = NO;
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 记录上次最早的时间
    NSString *lastTime = [[[self.frameModelArr firstObject] messageModel] time];
    if (!lastTime) {
        lastTime = [fmt stringFromDate:[NSDate date]];
    }
    NSArray *array = [DHMessageDao selectMessageDBWithUserId:_item.userId targetId:_item.targetId lastTime:lastTime];
    DHUserInfoModel *userInfo = self.userInfo;
    NSString *targetHeaderUrl = userInfo.b57;
    self.navigationItem.title = userInfo.b52;
    NSString *headerUrl = [NSGetTools getIconB57];
    
    for (DHMessageModel *item in array) {
        MessageModel *msgModel=[[MessageModel alloc]init];
        msgModel.body=item.message;
        if ([item.messageType integerValue] == 1) {
            msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
        }else{
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[item.message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            msgModel.attributedBody = attrStr;
        }
        msgModel.time=item.timeStamp;
        if (self.frameModelArr.count < 1) {
            msgModel.hiddenTime = NO;
        }else{
            MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
            NSString *lastTime = itemMsg.messageModel.time;
            NSDate *date1 = [fmt dateFromString:lastTime];
            NSDate *date2 = [fmt dateFromString:item.timeStamp];
            NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
            if (intervalMin < 1) {
                msgModel.hiddenTime = YES;
            }else{
                msgModel.hiddenTime = NO;
            }
        }
        msgModel.to=item.toUserAccount;
        msgModel.messageType = item.messageType;
        msgModel.targetUserType = item.targetUserType;
        msgModel.targetId = _item.targetId;
        // 设置头像
        msgModel.targetHeaderUrl = targetHeaderUrl;
        msgModel.headerUrl = headerUrl;
        //是不是当前用户
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        if ([item.fromUserAccount isEqualToString:userId]) {
            msgModel.isCurrentUser=YES;
        }else{
            msgModel.isCurrentUser=NO;
        }
        //根据frameModel模型设置frame
        MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
        // 获取音频的时间
        float audioDurationSeconds = item.fileDuration;
        UIImage *plaImage = nil;
        if ([item.messageType integerValue] == 3) {
            BOOL isEixt = [self isFileExistWithTimeStamp:item.timeStamp targetId:_item.targetId messageType:3];
            if (!isEixt) {
                plaImage = [UIImage imageNamed:@"list_item_icon.png"];
                msgModel.chatImageUrl = item.fileUrl;
            }else{
                UIImage *image = [self getImageFromShandBoxWithTimeStamp:item.timeStamp targetId:_item.targetId];
                plaImage = image;
                msgModel.localChatImage = plaImage;
            }
        }else if ([item.messageType integerValue] == 4){
            msgModel.audioDuration = audioDurationSeconds;
            
            BOOL isEixt = [self isFileExistWithTimeStamp:item.timeStamp targetId:_item.targetId messageType:4];
            if (!isEixt) {
                // 异步保存到沙盒
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *chatImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.fileUrl]];
                    [self saveChatFileWithFile:chatImageData timeStamp:item.timeStamp targetId:_item.targetId];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            msgModel.fileUrl = item.fileUrl;
            frameModel.messageModel=msgModel;
            BOOL isBlack = [DHBlackListDao checkBlackListUserWithUsertId:item.targetId];
            if (isBlack) {
                
            }else{
                [self.frameModelArr insertObject:frameModel atIndex:0];
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table.mj_header endRefreshing];
        self.bottomInputView.editable = YES;
        [self.table reloadData];
        [self scrollToBottomWithAnimated:NO];
    });
    
}
// 跳到指定一行
- (void)scrollToIndexWithMoreCount:(NSInteger )moreCount{

    NSInteger index = moreCount;
    if (self.frameModelArr.count > 0) {
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    NSLog(@"%@",item.message);
    if ([item.fromUserAccount integerValue] == [self.userInfo.b80 integerValue]) {
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        item.userId = userId;
        item.roomCode = _item.roomCode;
        item.roomName = _item.roomName;
        item.targetId = self.userInfo.b80;
        item.isRead = @"1";
        if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
            [DHMessageDao insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
        }
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:item.fromUserAccount];
        if (!userInfo) {
            [self getTargetUserInfoWithUserId:item.fromUserAccount];
        }
        MessageModel *msgModel=[[MessageModel alloc]init];
        msgModel.body=item.message;
        if ([item.messageType integerValue] == 1) {
            msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
        }else{
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[item.message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            msgModel.attributedBody = attrStr;
        }
        msgModel.time=item.timeStamp;
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if (self.frameModelArr.count < 1) {
            msgModel.hiddenTime = NO;
        }else{
            MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
            NSString *lastTime = itemMsg.messageModel.time;
            NSDate *date1 = [fmt dateFromString:lastTime];
            NSDate *date2 = [fmt dateFromString:item.timeStamp];
            NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
            if (intervalMin < 1) {
                msgModel.hiddenTime = YES;
            }else{
                msgModel.hiddenTime = NO;
            }
        }
        msgModel.to=item.toUserAccount;
        msgModel.messageType = item.messageType;
        msgModel.targetUserType = item.targetUserType;
        msgModel.targetId = _item.targetId;
        
        
        DHUserInfoModel *userInfo1 = self.userInfo;
        NSString *targetHeaderUrl = userInfo1.b57;
        NSString *headerUrl = [NSGetTools getIconB57];
        // 设置头像
        msgModel.targetHeaderUrl = targetHeaderUrl;
        msgModel.headerUrl = headerUrl;
        //是不是当前用户
        if ([item.fromUserAccount integerValue] == [userId integerValue]) {
            msgModel.isCurrentUser=YES;
        }else{
            msgModel.isCurrentUser=NO;
        }
        // 获取音频的时间
        float audioDurationSeconds = item.fileDuration;
        UIImage *plaImage = nil;
        if ([item.messageType integerValue] == 3) {
            BOOL isEixt = [self isFileExistWithTimeStamp:item.timeStamp targetId:_item.targetId messageType:3];
            if (!isEixt) {
                plaImage = [UIImage imageNamed:@"list_item_icon.png"];
                msgModel.chatImageUrl = item.fileUrl;
            }else{
                UIImage *image = [self getImageFromShandBoxWithTimeStamp:item.timeStamp targetId:_item.targetId];
                plaImage = image;
                msgModel.localChatImage = plaImage;
            }
        }else if ([item.messageType integerValue] == 4){
            msgModel.audioDuration = audioDurationSeconds;
        }
        
        //根据frameModel模型设置frame
        MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            msgModel.fileUrl = item.fileUrl;
            frameModel.messageModel=msgModel;
            BOOL isBlack = [DHBlackListDao checkBlackListUserWithUsertId:item.targetId];
            if (isBlack) {
                
            }else{
                [self.frameModelArr addObject:frameModel];
            }
            [self.table reloadData];
            [self scrollToBottomWithAnimated:YES];
        });
    }
}
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
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}
- (void)backAction{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)hideKeyBoard{
    self.chatBottom.hidden = NO;
    [self.bottomInputView resignFirstResponder];
}


- (BOOL)isFileExistWithTimeStamp:(NSString *)timeStamp targetId:(NSString *)targetId messageType:(NSInteger )messageType{
    
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *imagePath = nil;
    NSString *imageName = nil;
    if (messageType == 3) {
        imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"chatImages"] ;
        BOOL existed = [fileManager fileExistsAtPath:imagePath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg",userId,targetId,time];// 当前用户_目标用户_图片id
    }else if (messageType == 4){
        imagePath = [[cachePath stringByAppendingPathComponent:@"file"] stringByAppendingPathComponent:@"chatAudio"] ;
        imageName = [NSString stringWithFormat:@"%@_%@_%@.mp3",userId,targetId,time];// 当前用户_目标用户_图片id
    }
    NSString *fullPath = [imagePath stringByAppendingPathComponent:imageName];
    NSFileManager *fm = [NSFileManager defaultManager];
    //判断沙盒下是否存在
    
    BOOL isExist = [fm fileExistsAtPath:fullPath];
    return isExist;
}
#pragma mark 把聊天数据转成模型
-(void)dataToModel
{
    //
 
}

#pragma mark 添加表视图
-(void)setupTableView
{
    if(self.table==nil) {
        UITableView *table=[[UITableView alloc]init];
//        table.allowsSelection=NO;  //单元不可以被选中
        table.separatorStyle=UITableViewCellSeparatorStyleNone;  //去掉线
        CGFloat tableH= ScreenHeight;
        self.tableViewHeight=tableH;  //表示图的高
        table.frame=CGRectMake(0, 0, ScreenWidth, tableH-64);
        table.delegate=self;
        table.dataSource=self;
        [self.view addSubview:table];
        self.table=table;
//        [self.table registerClass:[ChatViewCell class] forCellReuseIdentifier:@"chatViewCell"];
    }
}
#pragma mark 返回有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.frameModelArr.count  ;
}
#pragma mark 输入框的代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   //写这个是为了不会在keyboardWillShow里面在调整tableView的高度(否则会错乱)
    self.isChangeHeight=YES;
    NSString *body=[self trimStr:textView.text];
    if([text isEqualToString:@"\n"]){
        //如果没有要发送的内容返回空
        if([body isEqualToString:@""]) return NO;
        //发送消息
        [self sendMsgWithText:_bottomInputView.realText bodyType:@"text"];
        self.bottomInputView.text=nil;
        return NO;
    }
    return YES;
}
- (BOOL )isAllReadyToSendMessage{
//#warning 测试专用，用完注掉，然后解开下面的
//    return YES;
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    DHUserInfoModel *targetFriend = [DHFriendDao getFriendWithFriendId:_item.targetId];
    // 免费朋友关系，可以发消息
    if ([targetFriend.friendType integerValue] == 2) {
        return YES;
    }else{
        if ([userinfo.b69 integerValue] == 1) {
            
            //非同城推荐人员
//            NSArray *array = [DHMessageDao selectMessageDBWithUserId:_item.userId targetId:_item.targetId atIndex:0];
//            
//            if (array.count>0) {
//                DHMessageModel *temp = [array firstObject];
//                if ([temp.targetUserType  isEqualToString:@"4"]) {
//                    _msg.targetUserType=@"4";//同城推荐消息
//                    return YES;
//                }else{
//                    if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]) {
//                        [self hideKeyBoard];
//                        DHAlertView *alert1 = [[DHAlertView alloc]init];
//                        [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"开通写信功能，无限畅通聊天~"];
//                        alert1.delegate = self;
//                        [self.view addSubview:alert1];
//                        return NO;
//                    }else{
//                        return YES;
//                    }
//                }
//            }else{
//                if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]) {
//                    [self hideKeyBoard];
//                    DHAlertView *alert1 = [[DHAlertView alloc]init];
//                    [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"开通写信功能，无限畅通聊天~"];
//                    alert1.delegate = self;
//                    [self.view addSubview:alert1];
//                    return NO;
//                }else{
//                    return YES;
//                }
//            }
            if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]) {
                [self hideKeyBoard];
                DHAlertView *alert1 = [[DHAlertView alloc]init];
                [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"开通写信功能，无限畅通聊天~"];
                alert1.delegate = self;
                [self.view addSubview:alert1];
                return NO;
            }else{
                return YES;
            }
        }else{
            return YES;
        }
    }
    
}
//#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString*)bodyType{

    BOOL isAllReady = [self isAllReadyToSendMessage];
    if (isAllReady == NO) {
        return;
    }
    BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:_userInfo.b80];
    if (isblack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已将ta拉黑，不能发送消息~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [aler show];
            
        });
        
    }else{
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *fmtDate = [fmt stringFromDate:dat];
        _msg = [[DHMessageModel alloc] init];
        _msg.toUserAccount = self.item.targetId;
        //    @"101111601";
        //    self.item.targetId;
        _msg.roomName = self.navigationItem.title;
        _msg.roomCode = [NSGetTools getRoomCode];
        _msg.message = text;
        _msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
        _msg.timeStamp = fmtDate;
        //    _msg.icon = self.photoUrl;
        //    _msg.type = 0;//自己发的
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        _msg.fromUserAccount = userId;
        _msg.messageType = @"1";
        NSString *messageId = [self configUUid];
        _msg.messageId = messageId;// 消息ID
        _msg.token = [NSGetTools getToken];
        _msg.roomCode = _item.roomCode;
        _msg.roomName = _item.roomName;
        _msg.targetId = self.item.targetId;
        _msg.userId = userId;
        // 不是机器人消息
        
        _msg.robotMessageType = @"-1";
        _msg.isRead = @"2";
        
        _msg.fileUrl = @"";
        _msg.length = 0;
        _msg.fileName = @"";
        _msg.addr = @"";
        _msg.lat = 0;
        _msg.lng = 0;
        _msg.socketType = 1001;
        DHUserInfoModel *targetFriend = [DHFriendDao getFriendWithFriendId:_item.targetId];
        _msg.friendType = [targetFriend.friendType integerValue];
        // 存储到数据库
        if (![DHMessageDao checkMessageWithMessageId:_msg.messageId targetId:_msg.targetId]) {
            [DHMessageDao insertMessageDataDBWithModel:_msg userId:[NSString stringWithFormat:@"%@",userId]];
        }
        DHUserInfoModel *userInfo = self.userInfo;
        //        EMChatText *txtChat = [[EMChatText alloc] initWithText:text];
        //        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
        // 生成message 101111601，109112802
//        NSDictionary *system_pm = [NSGetSystemTools getsystem_pm];
//        NSArray *allkeys = [system_pm allKeys];
//        NSString *attr1 = nil;
//        for (NSString *key in allkeys) {
//            if (([key isEqualToString:@"T_"] || [key isEqualToString:@"t_"]) || ([key isEqualToString:@"P_"] || [key isEqualToString:@"p_"])) {
//                attr1 = key;
//                break;
//            }
//        }
        //        EMMessage *message = [[EMMessage alloc] initWithReceiver:[NSString stringWithFormat:@"%@%@",attr1,self.item.targetId] bodies:@[body]];
        //        message.messageType = eMessageTypeChat; // 设置为单聊消息
        //        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        //        EMMessage *messageResult = [chatManager asyncSendMessage:message progress:nil];
        //        NSLog(@"%@",messageResult);
        
        [SocketManager asyncSendMessageWithMessageModel:_msg];
        
        MessageModel *msgModel=[[MessageModel alloc]init];
        
        msgModel.body=text;
        msgModel.attributedBody = [[NSAttributedString alloc]initWithString:text];
        msgModel.time=fmtDate;
        msgModel.from = _msg.userId;
        msgModel.messageId = _msg.messageId;
        msgModel.targetId = _item.targetId;
        //        msgModel.fileUrl = @"";// 文本形式不需要文件链接
        if (self.frameModelArr.count < 1) {
            msgModel.hiddenTime = NO;
        }else{
            MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
            NSString *lastTime = itemMsg.messageModel.time;
            NSDate *date1 = [fmt dateFromString:lastTime];
            NSDate *date2 = [fmt dateFromString:fmtDate];
            NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
            if (intervalMin < 1) {
                msgModel.hiddenTime = YES;
            }else{
                msgModel.hiddenTime = NO;
            }
        }
        msgModel.to=_msg.fromUserAccount;
        msgModel.messageType = _msg.messageType;
        msgModel.targetUserType = _msg.targetUserType;
        
        NSString *headerUrl = userInfo.b57;
        NSString *imageurl = [NSGetTools getIconB57];
        msgModel.targetHeaderUrl=headerUrl;
        msgModel.headerUrl=imageurl; //获得用户自己的头像
        //是不是当前用户
        msgModel.isCurrentUser=YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //根据frameModel模型设置frame
                MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
                frameModel.messageModel=msgModel;
                //把frameModel添加到数组中
                [self.frameModelArr addObject:frameModel];
                [self.table reloadData];
                [self scrollToBottomWithAnimated:YES];
                
                // 回调反馈发给哪个机器人
                if ([self.userInfo.b143 integerValue] == 2) {
                    NSArray *msgArr = [DHMessageDao getRobotChatListWithUserId:self.userInfo.b80];
                    DHMessageModel *lastMessage = [msgArr lastObject];
                    NSString *type = nil;
                    if (!lastMessage) {
                        type = @"1";
                    }else{
                        type = lastMessage.robotMessageType;
                    }
                    [Mynotification postNotificationName:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:_msg];
                }
            });
            
        });
    }
}
-(void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger)index{
    if (index == 1) {
        // 规避线程bug
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]) {
#pragma mark 商店版
                MonthlyViewController *moVC=[[MonthlyViewController alloc]init];
                UINavigationController *moenthnc=[[UINavigationController alloc]initWithRootViewController:moVC];
                [self presentViewController:moenthnc animated:YES completion:nil];
//                [self.navigationController pushViewController:moVC animated:YES];
            }else{
#pragma mark 企业版
                YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
                
                temp.payMainCode=[goodDict objectForKey:@"b13"];
                temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//                temp.payMainCode=@"1005";
//                temp.payComboType=@"2";//单买
                temp.navigationItem.title=@"写信包月服务";
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
//                [self.navigationController pushViewController:temp animated:YES];
            }
        });
    }
}

- (void)new_didReceiveOnlineMessage:(NSNotification *)notifi{
    DHMessageModel *msg = notifi.object;
    // 存储到数据库
    if (![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",msg.userId]];
    }
    // 消息的对方id与当前聊天页面的targetId一致就更新页面。否则不更新。
    
    if ([msg.targetId isEqualToString:self.item.targetId]) {
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:msg.targetId];
        BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:_userInfo.b80];
        if (isblack) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                        [self showHint:@"已经被拉黑，不接收此人的消息"];
            });
        }else{
            if (!userInfo) {
                [self getTargetUserInfoWithUserId:msg.targetId];
            }
            MessageModel *msgModel=[[MessageModel alloc]init];
            msgModel.body=msg.message;
            if ([msg.messageType integerValue] == 1) {
                msgModel.attributedBody = [[NSAttributedString alloc]initWithString:msg.message];
            }else{
                NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[msg.message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                msgModel.attributedBody = attrStr;
            }
            msgModel.time=msg.timeStamp;
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (self.frameModelArr.count < 1) {
                msgModel.hiddenTime = NO;
            }else{
                MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
                NSString *lastTime = itemMsg.messageModel.time;
                NSDate *date1 = [fmt dateFromString:lastTime];
                NSDate *date2 = [fmt dateFromString:msg.timeStamp];
                NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
                if (intervalMin < 1) {
                    msgModel.hiddenTime = YES;
                }else{
                    msgModel.hiddenTime = NO;
                }
            }
            msgModel.to=msg.toUserAccount;
            msgModel.messageType = msg.messageType;
            msgModel.targetUserType = msg.targetUserType;
            msgModel.targetId = msg.targetId;
            
            DHUserInfoModel *userInfo1 = self.userInfo;
            NSString *headerUrl = userInfo1.b57;
            NSString *imageurl = [NSGetTools getIconB57];
            
            msgModel.targetHeaderUrl = headerUrl;
            msgModel.headerUrl = imageurl;
            //是不是当前用户
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            if ([msg.fromUserAccount isEqualToString:userId]) {
                msgModel.isCurrentUser=YES;
            }else{
                msgModel.isCurrentUser=NO;
            }
            
//            NSData *chatImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:msg.fileUrl]];
            
            //根据frameModel模型设置frame
            MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([msg.messageType integerValue] == 3) {
//                    UIImage *chatImage = [UIImage imageWithData:chatImageData];
                    msgModel.chatImageUrl = msg.fileUrl;
                    
                }else if ([msg.messageType integerValue] == 4){
                    // 获取音频的时间
                    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:msg.fileUrl] options:nil];
                    CMTime audioDuration = audioAsset.duration;
                    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
                    msgModel.audioDuration = audioDurationSeconds;
//                    msgModel.audioDuration = msg.fileDuration;;
//                    NSArray *seTemp = [msg.fileUrl componentsSeparatedByString:@"."];
//                    [self saveChatFileWithFile:chatImageData timeStamp:msgModel.time targetId:msgModel.targetId];
                }
                frameModel.messageModel=msgModel;
                //把frameModel添加到数组中
                [self.frameModelArr addObject:frameModel];
                [self.table reloadData];
                [self scrollToBottomWithAnimated:YES];
            });
        }
    }
    
}
/**
 *  比较分钟差
 *
 *  @param date1 从哪个时间
 *  @param date2 到哪个时间
 *
 *  @return
 */
- (NSInteger )getLastIntavalTimeWithDate1:(NSDate *)date1 date2:(NSDate *)date2{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger intvalMin = [d minute];
    return intvalMin;
}
-(void)alertViewCancel:(UIAlertView *)alertView{
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 10000) {
            DHUserInfoModel *item = self.userInfo;
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *blackTime = [fmt stringFromDate:[NSDate date]];
            item.blackTime = blackTime;
            if (![DHBlackListDao checkBlackListUserWithUsertId:item.b80]) {
                [DHBlackListDao insertBlackListUserToDBWithItem:item];
            }
        }else{
            // 规避线程bug
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark H5
//                HFVipViewController *vip = [[HFVipViewController alloc] init];
//                [self.navigationController pushViewController:vip animated:YES];
                if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
                YS_ApplePayVipViewController *temp = [[YS_ApplePayVipViewController alloc]init];
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
//                [self.navigationController pushViewController:temp animated:YES];
                }else{
#pragma mark 企业版
                YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
                    
                temp.payMainCode=[goodDict objectForKey:@"b13"];
                temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//                temp.payMainCode=@"1006";
//                temp.payComboType=@"1";//套餐
                temp.navigationItem.title=@"开通VIP会员";
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
//                [self.navigationController pushViewController:temp animated:YES];
                }
            });

        }
    }
}

#pragma mark 表情按钮点击发送
-(void)faceSend{
    
    NSString *str=[self trimStr:_bottomInputView.text];
    if(str.length<1) return;
    //发送消息
    [self sendMsgWithText:_bottomInputView.realText bodyType:@"text"];
     self.bottomInputView.text=nil;
}

#pragma mark 表示图单元
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ChatViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"chatViewCell" forIndexPath:indexPath];
    ChatViewCell *cell = [ChatViewCell configTableViewCell];
    //传递模型
    MessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    
    cell.frameModel=frameModel;
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:self.item.targetId];
    if (![frameModel.messageModel.targetUserType isEqualToString:@"3"] && ![userinfo.b143 isEqualToString:@"3"]) {
        UITapGestureRecognizer *showUserinfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserinfoTap:)];
        [cell.viewShow.headImage addGestureRecognizer:showUserinfoTap];
    }
    if ([frameModel.messageModel.messageType isEqualToString:@"5"] || [frameModel.messageModel.messageType isEqualToString:@"6"]) {
        cell.viewShow.delegate=self;
    }
    if ([frameModel.messageModel.messageType isEqualToString:@"4"]) {
        cell.viewShow.delegate=self;
    }
    cell.viewShow.headImage.userInteractionEnabled = YES;
    cell.viewShow.headImage.tag = indexPath.row;
    cell.viewShow.delegate=self;
    return cell;

}
-(void)PayButtonToPayPageByTag:(NSInteger)buttTag{
    
    switch (buttTag) {
        case 5000:
        {
#pragma mark 支付小助手---H5版
//            YS_HtmlPayViewController *temp = [[YS_HtmlPayViewController alloc]init];
//            temp.urlWeb=@"http://10.10.16.206:8080/workPlace/H5/ios/Pay/index.html";
//            temp.payMainCode=@"1003";
//            temp.payComboType=@"1";//套餐
//            temp.navigationItem.title=@"开通VIP会员";
//            [self.navigationController pushViewController:temp animated:YES];
#pragma mark 支付小助手---原生版
            YS_SelfPayViewController *temp = [[YS_SelfPayViewController alloc]init];
            NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:1];
            
            temp.payMainCode=[goodDict objectForKey:@"b13"];
            temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//            temp.payMainCode=@"1006";
//            temp.payComboType=@"1";//套餐
            temp.navigationItem.title=@"开通VIP会员";
            UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
            [self presentViewController:tempnc animated:YES completion:nil];
//            [self.navigationController pushViewController:temp animated:YES];
        }
            break;
        case 6000:
        {
#pragma mark 支付小助手---H5版
//            YS_HtmlPayViewController *temp = [[YS_HtmlPayViewController alloc]init];
//            temp.urlWeb=@"http://10.10.16.206:8080/workPlace/H5/ios/Pay/index.html";
//            temp.payMainCode=@"1004";
//            temp.payComboType=@"2";//单买
//            temp.navigationItem.title=@"写信包月服务";
//            [self.navigationController pushViewController:temp animated:YES];
#pragma mark 支付小助手---原生版
            YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
            NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
            
            temp.payMainCode=[goodDict objectForKey:@"b13"];
            temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
//            temp.payMainCode=@"1005";
//            temp.payComboType=@"2";//单买
            temp.navigationItem.title=@"写信包月服务";
            UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
            [self presentViewController:tempnc animated:YES completion:nil];
//            [self.navigationController pushViewController:temp animated:YES];
        }
            break;
        default:
            break;
    }
}
/**
 *  点击头像显示用户信息
 *
 *  @param sender
 */
- (void)showUserinfoTap:(UITapGestureRecognizer *)sender{
    MessageFrameModel *model = [self.frameModelArr objectAtIndex:sender.view.tag];
    MessageModel *msgmodel = model.messageModel;
    Homepage *otherVC = [[Homepage alloc]init];
    
    if (msgmodel.isCurrentUser) {
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *user = [DHUserInfoDao getUserWithCurrentUserId:userId];
        otherVC.touchP2 = userId;
        otherVC.item = user;
    }else{
        otherVC.touchP2 = self.item.targetId;
        otherVC.item = self.userInfo;
    }
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:otherVC];
    [self presentViewController:nav animated:YES completion:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self uoloadLookMeInfo:model];
//    });
    
}
#pragma mark 返回单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    return frameModel.cellHeight;

}
#pragma mark 添加底部的view
-(void)setupBottomView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
   
    ChatBottomView *bottom=[[ChatBottomView alloc]init];
    bottom.BottominputView.delegate=self; //实现输入框的代理
    bottom.delegate=self;
    bottom.x=0;
    bottom.y=keyWindow.height-bottom.height;
    [keyWindow addSubview:bottom];
    self.chatBottom=bottom;
    //传递输入框
    self.bottomInputView=bottom.BottominputView;
}
#pragma mark 底部工具栏按钮的点击
-(void)chatbottomView:(ChatBottomView *)bottomView buttonTag:(BottomButtonType)buttonTag
{
    switch (buttonTag) {
        case BottomButtonTypeEmotion:  //打开表情键盘
            [self openEmotion];
            break;
        case BottomButtonTypeAddPicture:  //打开添加图片键盘
            [self addPicture];
            break;
        case BottomButtonTypeAudio:  //
            [self addAudioWithChatBottomView:bottomView];
            break;
      
    }
}
#pragma mark 打开表情键盘
-(void)openEmotion
{
    for (UIView *aview in self.bottomInputView.subviews) {
        if ([aview isKindOfClass:[UILabel class]]) {
            [aview removeFromSuperview];
            break;
        }
    }
    //切换键盘
    self.changeKeyboard=YES;
    if(self.bottomInputView.inputView){  //自定义的键盘
        self.bottomInputView.inputView=nil;
        self.chatBottom.emotionStatus=NO;
        
    }else{  //系统自带的键盘
        
        self.bottomInputView.inputView=self.kerboard;
        self.chatBottom.emotionStatus=YES;
    }
    
    
    [self.bottomInputView resignFirstResponder];
    //切换完成
    self.changeKeyboard=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomInputView becomeFirstResponder];
    });

}
#pragma mark 打开添加图片的键盘
-(void)addPicture{
    
//    //切换键盘
//    self.changeKeyboard=YES;
//    if(self.bottomInputView.inputView){  //自定义的键盘
//        self.bottomInputView.inputView=nil;
//        self.chatBottom.emotionStatus=NO;
//    }
    [self.bottomInputView becomeFirstResponder];
//    [self.bottomInputView resignFirstResponder];
    
    //切换完成
//    self.changeKeyboard=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.bottomInputView resignFirstResponder];
        [self hideKeyBoard];
    });
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
    [myActionSheet showInView:self.view];
    [self.view bringSubviewToFront:myActionSheet];
    
}
- (void)addAudioWithChatBottomView:(ChatBottomView *)chatBottomView{
    self.bottomInputView.text = @"";
    if (!_isAudioBtnSelected) {
        // 未选择，显示录音按钮
        [chatBottomView.audioBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:(UIControlStateNormal)];
        [self hideKeyBoard];
        _isAudioBtnSelected = YES;
        UILabel *label = [[UILabel alloc]init];
        label.frame = self.bottomInputView.bounds;
        label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        label.text  = @"长按 说话";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToTalk:)];
        [label addGestureRecognizer:longGesture];
        
        [self.bottomInputView addSubview:label];
    }else{
        [chatBottomView.audioBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:(UIControlStateNormal)];
        [self.bottomInputView becomeFirstResponder];
        _isAudioBtnSelected = NO;
        for (UIView *aview in self.bottomInputView.subviews) {
            if ([aview isKindOfClass:[UILabel class]]) {
                [aview removeFromSuperview];
                break;
            }
        }
    }
}
- (void)longPressToTalk:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UILabel *label = (UILabel *)gesture.view;
        label.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
        self.chatBottom.addBtn.enabled = NO;
        self.chatBottom.audioBtn.enabled = NO;
        self.chatBottom.faceBtn.enabled = NO;
        [self startRecording];
        NSNumber *sec = [NSNumber numberWithInteger:0];
        _secTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secTimerAction:) userInfo:sec repeats:YES];
        [_secTimer fire];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        UILabel *label = (UILabel *)gesture.view;
        label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        self.chatBottom.addBtn.enabled = YES;
        self.chatBottom.audioBtn.enabled = YES;
        self.chatBottom.faceBtn.enabled = YES;
        [self stopRecording];
        if (_secIndex < 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _secIndex = 0;
                [_secTimer invalidate];
                _secTimer = nil;
//                [self showHint:@"录音时间太短"];
                [DHRecordTipView configWarningTipInView:self.view];
            });
            return;
        }else{
            _secIndex = 0;
            [_secTimer invalidate];
            _secTimer = nil;
            // 录音时间超过1秒，才发到服务器
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self playAudio];
            });
        }
    }
}
- (void)secTimerAction:(NSTimer *)timer{
    ++ _secIndex ;
}
- (void)didTouchContentButtonWithBtn:(UIButton *)btn{
    ChatViewCell *cell = (ChatViewCell *)[[[btn superview] superview] superview];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    MessageFrameModel *frameModel = [self.frameModelArr objectAtIndex:index.row];
//    NSArray *seTemp = [frameModel.messageModel.fileUrl componentsSeparatedByString:@"."];
    NSString *mp3FilePathName = [self getChatFileFromShandBoxWithTimeStamp:frameModel.messageModel.time targetId:frameModel.messageModel.targetId ];
    
//    int result = [VoiceConverter ConvertAmrToWav:mp3FilePathName wavSavePath:mp3FilePathName];
    NSURL *url = [NSURL fileURLWithPath:mp3FilePathName];
    // 设为活动
    NSError *error1 = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:&error1];
    NSError *error = nil;
    if (_player) {
        [_player stop];
        _player = nil;
    }
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:mp3FilePathName];
//    _player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    [_player prepareToPlay];
    _player.enableRate = YES;
    _player.meteringEnabled = YES;// 开启音量检测
    _player.delegate = self;
    [_player play];
}
- (void ) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL ) flag {
    if  (flag == YES) {
        NSLog(@"%sPlayback finish.",__func__ );
        [player stop];
        [_player stop];
        _player = nil;
        player = nil;
    }
}
- (void)playAudio{
    BOOL isAllReady = [self isAllReadyToSendMessage];
    if (isAllReady == NO) {
        return;
    }
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    BOOL isSuccess = [self toMp3];
    NSString *mp3FilePathName = [NSString stringWithFormat:@"%@/%@.mp3", cachePath, @"lll"];
    NSData *data = [NSData dataWithContentsOfFile:mp3FilePathName];
    if (isSuccess) {
        [SocketManager asyncUploadAudioWithFileData:data completed:^(NSString *audioUrl, long dataLength, NSString *fileName) {
            DHMessageModel *item = [[DHMessageModel alloc]init];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *fmtDate = [fmt stringFromDate:dat];
            // 保存到沙盒
            item = [[DHMessageModel alloc] init];
            item.toUserAccount = self.item.targetId;
            item.roomName = self.navigationItem.title;
            item.roomCode = [NSGetTools getRoomCode];
            item.message = @"";
            item.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
            item.timeStamp = fmtDate;
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            item.fromUserAccount = userId;
            item.messageType = @"4";
            NSString *messageId = [self configUUid];
            item.messageId = messageId;// 消息ID
            item.token = [NSGetTools getToken];
            item.roomCode = _item.roomCode;
            item.roomName = _item.roomName;
            item.targetId = self.item.targetId;
            item.userId = userId;
            item.robotMessageType = @"-1";
            item.isRead = @"2";
            // 不是机器人消息
            item.fileUrl = audioUrl;
            item.length = dataLength;
            item.fileName = fileName;
            item.addr = @"";
            item.lat = 0;
            item.lng = 0;
            item.socketType = 5003;
            DHUserInfoModel *targetFriend = [DHFriendDao getFriendWithFriendId:_item.targetId];
            item.friendType = [targetFriend.friendType integerValue];
            AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:item.fileUrl] options:nil];
            CMTime audioDuration = audioAsset.duration;
            float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
            item.fileDuration = audioDurationSeconds;
            [SocketManager asyncSendMessageWithMessageModel:item];
            [self saveChatFileWithFile:data timeStamp:item.timeStamp targetId:item.targetId];
            // 存储到数据库
            if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
                [DHMessageDao insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
            }
            DHUserInfoModel *userInfo = self.userInfo;
            MessageModel *msgModel=[[MessageModel alloc]init];
            msgModel.body=item.message;
            msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
            msgModel.time=fmtDate;
            msgModel.from = _msg.userId;
            msgModel.messageId = item.messageId;
            msgModel.targetId = item.targetId;
            if (self.frameModelArr.count < 1) {
                msgModel.hiddenTime = NO;
            }else{
                MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
                NSString *lastTime = itemMsg.messageModel.time;
                NSDate *date1 = [fmt dateFromString:lastTime];
                NSDate *date2 = [fmt dateFromString:fmtDate];
                NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
                if (intervalMin < 1) {
                    msgModel.hiddenTime = YES;
                }else{
                    msgModel.hiddenTime = NO;
                }
            }
            msgModel.to=self.item.fromUserAccount;
            msgModel.messageType = @"4";// 4为语音
            msgModel.targetUserType = self.item.targetUserType;
            //是不是当前用户
            msgModel.isCurrentUser=YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *headerUrl = userInfo.b57;
                NSString *imageurl = [NSGetTools getIconB57];
                dispatch_async(dispatch_get_main_queue(), ^{
                    msgModel.targetHeaderUrl = headerUrl;
                    msgModel.headerUrl = imageurl; //获得用户自己的头像
                    if ([item.messageType integerValue] == 3) {
                        msgModel.chatImageUrl = item.fileUrl;
                    }else if ([item.messageType integerValue] == 4){
                        // 获取音频的时间
                        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:item.fileUrl] options:nil];
                        CMTime audioDuration = audioAsset.duration;
                        float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
                        msgModel.audioDuration = audioDurationSeconds;
                    }
                    msgModel.fileUrl = item.fileUrl;
                    //根据frameModel模型设置frame
                    MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
                    frameModel.messageModel=msgModel;
                    //把frameModel添加到数组中
                    [self.frameModelArr addObject:frameModel];
                    [self.table reloadData];
                    [self scrollToBottomWithAnimated:YES];
                });
                
            });
        }];
    }
}
//转换Mp3格式方法
- (BOOL )toMp3 {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *mp3FilePathName = [NSString stringWithFormat:@"%@/%@.mp3", cachePath, @"lll"]; //新转换mp3文件路径
    NSString *cafFilePathName = [cachePath stringByAppendingPathComponent:@"lll.caf"];
    NSString *cafFilePath = cafFilePathName;    //caf文件路径
    
    NSString *mp3FilePath = mp3FilePathName;//存储mp3文件的路径
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除");
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        if(pcm == NULL){
            NSLog(@"file not found");
        }else{
            
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            
            unsigned char mp3_buffer[MP3_SIZE];
            lame_t lame = lame_init();
            
            lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
            
            lame_set_in_samplerate(lame, 8000.0);//11025.0
            
            //lame_set_VBR(lame, vbr_default);
            
            lame_set_brate(lame,8);
            
            lame_set_mode(lame,3);
            
            lame_set_quality(lame,2); /* 2=high 5 = medium 7=low 音质*/
            
            lame_init_params(lame);

            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            } while (read != 0);
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
            return YES;
        }
    }@catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        return NO;
    }@finally {
        NSLog(@"执行完成");
    }
}
- (void)startRecording{
    // 播放状态下录音，结束播放
    if (_player) {
        [_player stop];
        _player = nil;
    }
    _avSession = [AVAudioSession sharedInstance];
    [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [_avSession setActive:YES error:nil];
    NSMutableDictionary * recordSetting = [ NSMutableDictionary dictionary ];
    
    [recordSetting setValue :[ NSNumber numberWithInt : kAudioFormatLinearPCM ] forKey : AVFormatIDKey ]; //
    
    [recordSetting setValue :[ NSNumber numberWithFloat : 8000.0 ] forKey : AVSampleRateKey ];//采样率
    
    [recordSetting setValue :[ NSNumber numberWithInt : 2 ] forKey : AVNumberOfChannelsKey ];//声音通道， 这里必须为双通道
    
    [recordSetting setValue :[ NSNumber numberWithInt : AVAudioQualityLow ] forKey : AVEncoderAudioQualityKey ];//音频质量
//    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:44100.0], AVSampleRateKey,[NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,[NSNumber numberWithInt:2], AVNumberOfChannelsKey,nil];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.caf", strUrl]];
    
    _avRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    [_avRecorder prepareToRecord];
    _avRecorder.delegate = self;
    _avRecorder.meteringEnabled = YES;// 设置可获取返回分贝值
    [_avRecorder peakPowerForChannel:0];
    [_avRecorder record];
    
    //设置定时检测
    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}
// 聊天文件保存到沙盒
- (void)saveChatFileWithFile:(NSData *)fileData timeStamp:(NSString *)timeStamp targetId:(NSString *)targetId {
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"file"] stringByAppendingPathComponent:@"chatAudio"] ;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imagePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //        NSString *targetId = _item.userId;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.mp3",userId,targetId,time];// 当前用户_目标用户_图片id
    NSString *fullPath = [imagePath stringByAppendingPathComponent:imageName];
    int result = [VoiceConverter ConvertAmrToWav:fullPath wavSavePath:fullPath];
    // 将图片写入文件
    [fileData writeToFile:fullPath atomically:NO];
    
}
// 取沙盒文件，根据时间
- (NSString *)getChatFileFromShandBoxWithTimeStamp:(NSString *)timeStamp targetId:(NSString *)targetId{
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"file"] stringByAppendingPathComponent:@"chatAudio"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    NSString *targetId = targetId;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@",userId,targetId,time];// 当前用户_目标用户_图片id
    NSString *fullPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",imageName]];
    return fullPath;
}
- (void)stopRecording{
    [_avRecorder stop];
    [_timer invalidate];
    [DHRecordTipView disMiss];
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [_avSession setActive: NO error: nil];
}
// 音量提示视图
- (void)detectionVoice{
    [_avRecorder updateMeters];//刷新音量数据
    double lowPassResults = pow(10, (0.05 * [_avRecorder peakPowerForChannel:0]));
    [DHRecordTipView configTipInView:self.view volume:lowPassResults];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.chatBottom.hidden = YES;
    switch (buttonIndex){
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
        default:
            self.chatBottom.hidden = NO;
            break;
    }
}
#pragma mark - 拍照
- (void)openCamera{
    NSUInteger sourceType = 0;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    // 拍照
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    picker.allowsEditing = NO;
    NSArray *arr = [NSArray arrayWithObject:image];
    
    [self configPichtureWithImageArr:arr];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}
// 聊天图片保存到沙盒
- (void)saveChatImageWithImage:(UIImage *)image timeStamp:(NSString *)timeStamp targetId:(NSString *)targetId{
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        // 获取沙盒目录
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"chatImages"] ;
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:imagePath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//        NSString *targetId = _item.userId;
        NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg",userId,targetId,time];// 当前用户_目标用户_图片id
        NSString *fullPath = [imagePath stringByAppendingPathComponent:imageName];
        // 将图片写入文件
        [imageData writeToFile:fullPath atomically:NO];

}
// 取沙盒图片，根据时间
- (UIImage *)getImageFromShandBoxWithTimeStamp:(NSString *)timeStamp targetId:(NSString *)targetId{
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"chatImages"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    NSString *targetId = _item.userId;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg",userId,targetId,time];// 当前用户_目标用户_图片id
    NSString *fullPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}
/**
 *  放大图片
 *
 *  @param btn
 */
- (void)didTouchContentButtonOpenImageWithBtn:(UIButton *)btn{
    UIImageView *v = (UIImageView *)[[btn subviews] lastObject];
    [DHOpenImage showImage:v];
}
- (void)configPichtureWithImageArr:(NSArray *)imageList{
    BOOL isAllReady = [self isAllReadyToSendMessage];
    if (isAllReady == NO) {
        return;
    }
    // 上传
    [SocketManager asyncUploadImageWithImageList:imageList completed:^(NSString *imageUrl,long dataLength,NSString *fileName) {
        
        DHMessageModel *item = [[DHMessageModel alloc]init];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *fmtDate = [fmt stringFromDate:dat];
        // 保存到沙盒
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
//            [self saveChatImageWithImage:image timeStamp:fmtDate targetId:self.item.targetId];
        item = [[DHMessageModel alloc] init];
        item.toUserAccount = self.item.targetId;
        item.roomName = self.navigationItem.title;
        item.roomCode = [NSGetTools getRoomCode];
        item.message = @"";
        item.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
        item.timeStamp = fmtDate;
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        item.fromUserAccount = userId;
        item.messageType = @"3";
        NSString *messageId = [self configUUid];
        item.messageId = messageId;// 消息ID
        item.token = [NSGetTools getToken];
        item.roomCode = _item.roomCode;
        item.roomName = _item.roomName;
        item.targetId = self.item.targetId;
        item.userId = userId;
        item.robotMessageType = @"-1";
        item.isRead = @"2";
        // 不是机器人消息
        item.fileUrl = imageUrl;
        item.length = dataLength;
        item.fileName = fileName;
        item.addr = @"";
        item.lat = 0;
        item.lng = 0;
        item.socketType = 5001;
        DHUserInfoModel *targetFriend = [DHFriendDao getFriendWithFriendId:_item.targetId];
        item.friendType = [targetFriend.friendType integerValue];
        [SocketManager asyncSendMessageWithMessageModel:item];
        // 存储到数据库
        if (![DHMessageDao checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
            [DHMessageDao insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
        }
        DHUserInfoModel *userInfo = self.userInfo;
        MessageModel *msgModel=[[MessageModel alloc]init];
        msgModel.body=item.message;
        msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
        msgModel.time=fmtDate;
        msgModel.from = _msg.userId;
        msgModel.messageId = item.messageId;
        msgModel.targetId = item.targetId;
        //            msgModel.fileUrl = imageUrl;
        if (self.frameModelArr.count < 1) {
            msgModel.hiddenTime = NO;
        }else{
            MessageFrameModel *itemMsg = [self.frameModelArr lastObject];
            NSString *lastTime = itemMsg.messageModel.time;
            NSDate *date1 = [fmt dateFromString:lastTime];
            NSDate *date2 = [fmt dateFromString:fmtDate];
            NSInteger intervalMin = [self getLastIntavalTimeWithDate1:date1 date2:date2];
            if (intervalMin < 1) {
                msgModel.hiddenTime = YES;
            }else{
                msgModel.hiddenTime = NO;
            }
        }
        msgModel.to=self.item.fromUserAccount;
        msgModel.messageType = @"3";
        msgModel.targetUserType = self.item.targetUserType;
        //NSLog(@"%@",self.photo);
        //    msgModel.hiddenTime=YES; //隐藏时间
        //是不是当前用户
        msgModel.isCurrentUser=YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *headerUrl = userInfo.b57;
            NSString *imageurl = [NSGetTools getIconB57];
            dispatch_async(dispatch_get_main_queue(), ^{
                msgModel.targetHeaderUrl = headerUrl;
                msgModel.headerUrl = imageurl; //获得用户自己的头像
                msgModel.chatImageUrl = item.fileUrl;
                //根据frameModel模型设置frame
                MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
                frameModel.messageModel=msgModel;
                //把frameModel添加到数组中
                [self.frameModelArr addObject:frameModel];
                [self.table reloadData];
                [self scrollToBottomWithAnimated:YES];
            });
            
        });
    }];
}
#pragma mark - 本地相册
- (void)openLocalPhoto{
    NSMutableArray *imageArr = [NSMutableArray array];
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    pickerVc.maxCount = 1;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
        __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        for (int i = 0;i <assets.count; i ++) {
            UIImage *originImage= [assets[i] originImage];
            [imageArr addObject:originImage];
            
        }
        [weakSelf configPichtureWithImageArr:imageArr];
    };
}
#pragma mark  键盘将要出现的时候
-(void)keybordAppear:(NSNotification*)note
{
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //滚回最后一行
            [self scrollToBottomWithAnimated:YES];
            self.chatBottom.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
            //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
            if(self.frameModelArr.count>5){
                self.table.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
                return;
            }
            //数组中得模型数量小于等于5的话 才改变tableView的高度
            if(self.isChangeHeight==NO){
                if(ScreenHeight<568){ //是iphone4s/4
                    self.table.height=self.table.height-keyboardF.size.height;
                    
                }else{  //是iphone5/5s/6/6plus
                    self.table.height=self.table.height-BottomHeight*0.5-keyboardF.size.height;
                    //NSLog(@"iphone5/5s/6/6plus");
                }
                self.isChangeHeight=YES;
            }
        });
    }];
}
#pragma mark 键盘将要隐藏的时候
-(void)keybordHide:(NSNotification*)note
{
    if(self.changeKeyboard) return ;
    
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatBottom.transform=CGAffineTransformIdentity;
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count>5){
            self.table.transform=CGAffineTransformIdentity;
        }
        if(self.table.height<self.tableViewHeight){
              self.table.height=self.tableViewHeight-64;  //tableView回到原来的高度
        }
      
        self.isChangeHeight=NO; //设置NO当键盘keybordAppear 就又可以调整tableView的高度了
    }];
}


#pragma mark  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    [self.bottomInputView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.bottomInputView];
}


#pragma mark  当点击表情键盘上的删除按钮时调用

- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.bottomInputView deleteBackward];
}


#pragma mark  当textView的文字改变就会调用
- (void)textViewDidChange:(UITextView *)textView
{
    //self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


#pragma mark 当时图开始滚动的时候  隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
#pragma mark 滚到最后一行的方法
-(void)scrollToBottomWithAnimated:(BOOL)animated{
    
    //如果数组李米娜没有值 返回
    if(!self.frameModelArr.count) return;
    // 2.让tableveiw滚动到最后一行
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.frameModelArr.count - 1  inSection:0];
    
    /*
     AtIndexPath: 要滚动到哪一行
     atScrollPosition:滚动到哪一行的什么位置
     animated:是否需要滚动动画
     */
   // NSLog(@"%zd  数组个数%zd",path.row,self.frameModelArr.count);

 [self.table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"@"];
    return arr[0];
}

-(void)dealloc
{
    [Mynotification removeObserver:self];
    [_player stop];
    _player = nil;
   
}
- (void)reportAction{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Ta的主页"
                     image:[UIImage imageNamed:@"Bombbox-ta-icon"]
                    target:self
                    action:@selector(pushHomePageAction:)],
      
      [KxMenuItem menuItem:@"举报Ta"
                     image:[UIImage imageNamed:@"w_xx_lt_jbta"]
                    target:self
                    action:@selector(pushReportAction:)],
      [KxMenuItem menuItem:@"加入黑名单"
                   image:[UIImage imageNamed:@"ico-black.png"]
                  target:self
                  action:@selector(addToBlackListAction:)],
    
    ];
    
    
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 67;
    targetFrame.origin.x = targetFrame.origin.x + ScreenWidth-24;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
    
}
- (void)pushHomePageAction:(id)sender{
    Homepage *otherVC = [[Homepage alloc]init];
    
    otherVC.touchP2 = self.item.targetId;
    otherVC.item = self.userInfo;
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:otherVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)pushReportAction:(id)sender{
    ReportController *reportVC=[[ReportController alloc]init];
    reportVC.touchP2 = self.item.targetId;
    [self.navigationController pushViewController:reportVC animated:YES];
    
}
- (void)addToBlackListAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"触陌提示" message:@"拉黑后将不会收到对方发来的消息，可在“系统设置--黑名单”中解除，是否拉黑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拉黑", nil];
    alert.tag = 10000;
    [alert show];
}
//// 生成32位uuid
//- (NSString *)configUUid{
//    char data[32];
//    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
//}
@end
