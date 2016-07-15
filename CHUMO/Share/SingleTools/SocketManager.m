//
//  SocketManager.m
//  StrangerChat
//
//  Created by long on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SocketManager.h"
#import "ChatController.h"
@implementation SocketManager

static SocketManager* _socketManager = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _socketManager = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _socketManager ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [SocketManager shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [SocketManager shareInstance] ;
}
//#pragma mark --- 懒加载 ---
- (GCDAsyncSocket *)client {
    if (!_client) {
        _client = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    }
    return _client;
}
- (void)ClientConnectServer{
    //1.连接 -->三次握手
    //2.读 写 都是一样的,我们用一个timer去负责一致读取
    //3.端口  192.168.0.30:9066
    NSError *error = nil;
    [self.client connectToHost:kImServerAddressTest onPort:9066 error:&error];
    
    NSLog(@"----开始连接服务端--");
    // 添加心跳 3分钟返回一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0*3 target:self selector:@selector(heartBeatAction) userInfo:nil repeats:YES];
}
+ (void)ClientConnectServer{
    
    [[SocketManager shareInstance] ClientConnectServer];

}

#pragma mark --- GCDAsyncSocket ---
/**
 *  成功连接 三次握手结束了
 *
 *  @param server 服务器的实例
 *  @param host 服务器的IP地址
 *  @param port 服务器的端口号
 */

- (void)socket:(GCDAsyncSocket *)server didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%s%@",__func__,@"已经连上im服务器");
    [self asyncLoginToimServer];
    //开启timer 来读取 数据
    [self readDataFromServer];
}

/**
 *  接收到im服务器返回来的数据 2016年05月04日11:52:37 --by大海
 *
 *  @param sock
 *  @param data
 *  @param tag  
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if ([str containsString:@"$_$"]) {
        NSString *resultStr = [[str componentsSeparatedByString:@"$_$"] firstObject];
        NSDictionary *info = [self dictionaryWithJsonString:resultStr];
        NSInteger receiveType = [[info objectForKey:@"type"] integerValue];
        id receiveObject = [info objectForKey:@"object"];
        switch (receiveType) {
            case 3001:{
                // 心跳返回
                NSLog(@"%s心跳返回",__func__);
            }
                break;
            case 2001:{
                // 登录返回
                NSLog(@"%s登录IM成功：%@",__func__,receiveObject);
            }
                break;
            case 1008:{
                // 发送消息返回
                NSLog(@"%s%@",__func__,receiveObject);
            }
                break;
            case 1000:{
                // 收到消息
                NSLog(@"%@",receiveObject);
                DHMessageModel *item = [self asyncDidreceiveOnlineMessageWithObject:receiveObject];
                DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
                [sound play];
//                [Mynotification postNotificationName:@"new_didReLoadFriendDataArr" object:item];
                [Mynotification postNotificationName:NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION object:item];
                
                
            }
                break;
            case 1009:{
                // 收到离线消息
                NSLog(@"%@",receiveObject);
                NSArray *arr = [self asyncDidReceiveOffLineMessageWithObject:receiveObject];
                DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
                [sound play];
//                [Mynotification postNotificationName:@"new_didReLoadFriendDataArr" object:arr];
                [Mynotification postNotificationName:NEW_DIDRECEIVE_OFFLINE_MESSAGE_NOTIFICATION object:arr];
                
            }
                break;
            default:
                NSLog(@"收到未知消息");
                break;
        }
    }
    
}

/**
 *  登录im服务器 2016年05月04日11:10:50 --by大海
 */
- (void)asyncLoginToimServer{
    NSDictionary *logininfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    if (logininfo) {
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        NSString *password = [logininfo objectForKey:@"password"];
        NSMutableDictionary *sendInfo = [NSMutableDictionary dictionary];
        NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:userId==nil?@"":userId,@"userId",password==nil?@"":password,@"password", nil];
        [sendInfo setObject:userinfo forKey:@"object"];
        [sendInfo setObject:[NSNumber numberWithInteger:2001] forKey:@"type"];
        NSString *datastr = [NSString stringWithFormat:@"%@$_$",[sendInfo JSONString]];
        [self.client writeData:[datastr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }else{
        NSLog(@"%s用户未登录",__func__);
    }
}
+ (void)asyncLogout{
    [[SocketManager shareInstance] asyncLogout];
}
- (void)asyncLogout{
    [self.client disconnect];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"%s退出im服务器",__func__);
}
/**
 *  接收在线消息 2016年05月04日13:35:26 --by大海
 *
 *  @param object
 *
 *  @return
 */
- (DHMessageModel *)asyncDidreceiveOnlineMessageWithObject:(NSDictionary *)object{
    DHMessageModel *msg = [self configMessageWithObject:object];
    return msg;
}
/**
 *  接收离线消息 2016年05月04日13:35:39 --by大海
 *
 *  @param messageArr
 *
 *  @return
 */
- (NSArray *)asyncDidReceiveOffLineMessageWithObject:(NSArray *)messageArr{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *object in messageArr) {
        DHMessageModel *msg = [self configMessageWithObject:object];
        [tempArr addObject:msg];
    }
    return tempArr;
}
/**
 *  配置消息 2016年05月04日13:37:59--by大海
 *
 *  @param object
 *
 *  @return
 */
- (DHMessageModel *)configMessageWithObject:(NSDictionary *)object{
    DHMessageModel *msg = [[DHMessageModel alloc] init];
    msg.toUserAccount = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    msg.message = [object objectForKey:@"text"];
    msg.fromUserDevice = @"2";// 1:安卓 2:苹果 3:windowPhone
    
    long long timestamp = [[object objectForKey:@"msgTime"] longLongValue];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSString *fmtDate = [fmt stringFromDate:date];
    msg.timeStamp = fmtDate;
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    msg.fromUserAccount = [object objectForKey:@"fromId"];
    
    NSInteger messageType = [[object objectForKey:@"type"] integerValue];
    if (messageType == 1001) {
        msg.messageType = @"1";
    }else if (messageType == 1002){
        msg.messageType = @"8";
    }else if (messageType == 5001){// 图片
        msg.messageType = @"3";
    }else if (messageType == 5002){// 视频
        msg.messageType = @"7";
    }else if (messageType == 5003){// 语音
        msg.messageType = @"4";
    }else if (messageType == 5004){
        msg.messageType = @"9";
    }else if (messageType == 6001){
        msg.messageType = @"10";
    }
    msg.targetUserType = @"";
    msg.messageId = [object objectForKey:@"msgId"];// 消息ID
    msg.token = [NSGetTools getToken];
    msg.targetId = [object objectForKey:@"fromId"];
    msg.userId = userId;
    msg.robotMessageType = @"-1";
    msg.isRead = @"1";
    msg.addr = [object objectForKey:@"addr"];
    msg.fileName = [object objectForKey:@"fileName"];
    msg.lat = [[object objectForKey:@"lat"] doubleValue];
    msg.lng = [[object objectForKey:@"lng"] doubleValue];
    msg.fileUrl = [object objectForKey:@"url"];
    msg.length = [[object objectForKey:@"length"] longValue];
    msg.socketType = [[object objectForKey:@"type"] integerValue];
    return msg;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err.userInfo);
        return nil;
    }
    return dic;
}

/**
 *  发送心跳 2016年05月04日11:54:47 --by大海
 */
- (void)heartBeatAction{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"ping",@"object",[NSNumber numberWithInteger:3001],@"type", nil];
    NSString *str = [NSString stringWithFormat:@"%@$_$",[dict JSONString]];
    [self.client writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
#pragma mark --- 计时器 ---
- (void)readDataFromServer {
    [self.client readDataWithTimeout:-1 tag:0];
    //带1.0f秒延迟的递归
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self readDataFromServer];
    });
    
}
/**
 *  发送消息 2016年05月04日11:57:58 --by大海
 *
 *  @param message
 */
+ (void)asyncSendMessageWithMessageModel:(DHMessageModel *)message{
    [[SocketManager shareInstance] asyncSendMessageWithMessageModel:message];
}
- (void)asyncSendMessageWithMessageModel:(DHMessageModel *)message{
    if (message) {
        
        [self asyncSaveFrienShipWithFriendId:message.targetId friendType:message.friendType];
        
        NSMutableDictionary *sendinfo = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *messageInfo = [NSMutableDictionary dictionary];
        [messageInfo setObject:message.messageId forKey:@"msgId"];
        [messageInfo setObject:message.userId forKey:@"fromId"];
//        [messageInfo setObject:message.timeStamp forKey:@"msgTime"];
        [messageInfo setObject:message.message forKey:@"text"];
        [messageInfo setObject:message.targetId forKey:@"toId"];
        
//        [messageInfo setObject:message.targetId forKey:@"type"];
        [messageInfo setObject:[message.fileUrl length] == 0?@"":message.fileUrl forKey:@"url"];
        [messageInfo setObject:[NSNumber numberWithLong:message.length] forKey:@"length"];
        [messageInfo setObject:[message.fileName length] == 0?@"":message.fileName forKey:@"fileName"];
        [messageInfo setObject:[message.addr length] == 0?@"":message.addr forKey:@"addr"];
        [messageInfo setObject:[NSNumber numberWithDouble:message.lat] forKey:@"lat"];
        [messageInfo setObject:[NSNumber numberWithDouble:message.lng] forKey:@"lng"];
//        [messageInfo setObject:[NSNumber numberWithDouble:message.friendType] forKey:@"a78"];
//#warning 测试id 104134401,104131201
//        [messageInfo setObject:@"104134401" forKey:@"toId"];
        NSInteger socketType = message.socketType;
        
        [messageInfo setObject:[NSNumber numberWithInteger:socketType] forKey:@"type"];
        [sendinfo setObject:messageInfo forKey:@"object"];
        [sendinfo setObject:[NSNumber numberWithInteger:1000] forKey:@"type"];
        
        NSString *sendStr = [NSString stringWithFormat:@"%@$_$",[sendinfo JSONString]];
        NSData *data = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
        [self.client writeData:data withTimeout:-1 tag:0];
    }
}
/**
 *  确定好友关系
 *
 *  @param friendId 
 */
- (void)asyncSaveFrienShipWithFriendId:(NSString *)friendId friendType:(NSInteger )friendType{
    if (friendType == 0) {
        friendType = 1;
    }
    
    __weak typeof (&*self )weakSelf = self;
    [HttpOperation asyncGetSimPleUserInfoWithUserId:friendId queue:dispatch_get_main_queue() completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
        if (friendId && userInfoModel) {
            [HttpOperation asyncSaveFriendshipWithFriendId:friendId friendType:friendType friendName:userInfoModel.b52 queue:dispatch_get_main_queue() completed:^(NSDictionary *registerInfo) {
                // 将好友关系保存到本地
                self.friendArr = [NSMutableArray array];
                [weakSelf asyncGetFriendsListIsLoadMore:NO completed:^(NSArray *friendList, NSInteger code) {
                    
                }];
            }];
        }
    }];
    
    
    
    
}
- (void)asyncGetFriendsListIsLoadMore:(BOOL)isLoadMore completed:(void(^)(NSArray *friendList, NSInteger code))completed{
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
            [weakSelf asyncGetFriendsListIsLoadMore:YES completed:completed];
        }
        completed(self.friendArr,code);
    }];
}
/**
 *  发送消息 2016年05月04日11:57:58 --by大海
 *
 *  @param message
 */
+ (void)asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl ,long dataLength,NSString *fileName))completed{
    [[SocketManager shareInstance] asyncUploadImageWithImageList:imageList completed:completed];
}
- (void)asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl ,long dataLength,NSString *fileName))completed{
    
    [HttpOperation im_asyncUploadImageWithImageList:imageList completed:^(NSString *imageUrl, long datalength, NSString *fileName) {
        completed(imageUrl,datalength,fileName);
    }];
}
/**
 *  发送消息 2016年05月17日09:55:10 --by大海
 *
 *  @param message
 */
+ (void)asyncUploadAudioWithFileData:(NSData *)audioData completed:(void(^)(NSString *audioUrl ,long dataLength,NSString *fileName))completed{
    [[SocketManager shareInstance] asyncUploadAudioWithFileData:audioData completed:completed];
}
- (void)asyncUploadAudioWithFileData:(NSData *)audioData completed:(void(^)(NSString *audioUrl ,long dataLength,NSString *fileName))completed{
    
    [HttpOperation im_asyncUploadAudioWithAudioData:audioData completed:^(NSString *fileUrl, long datalength, NSString *fileName) {
        completed(fileUrl,datalength,fileName);
    }];
}
//#pragma mark  ---- 开房间和发送消息----
//// 开房间
//- (void)creatRoomWithString:(NSString *)string account:(NSString *)account
//{
//    //NSString *userAccount = [NSGetTools getUserAccount];
//    NSString *token = [NSGetTools getToken];
//    NSLog(@"getToken:%@",token);
//    NSNumber *seqCodeNum = [NSNumber numberWithInt:6];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
////    109112802 101111601
//    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"109112802",@"userAccount", nil];
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    [dict4 setValue:dict3 forKey:@"to"];
//    [dict setValue:dict2 forKey:@"head"];
//    [dict setValue:dict4 forKey:@"body"];
//    NSString *headStr = @"$102101|";
//    //NSString *jsonStr = [self dictionaryToJson:dict];
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *roomStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    NSLog(@"---发送开房间消息--%@",roomStr);
//    [self.client writeData:[roomStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
//
//// 退房间
//- (void)exitRoomWithString:(NSString *)string account:(NSString *)account
//{
//    //NSString *userAccount = [NSGetTools getUserAccount];
//    NSString *token = [NSGetTools getToken];
//    NSNumber *seqCodeNum = [NSNumber numberWithInt:8];
//    NSString *roomCode = [NSGetTools getRoomCode];// 房间号
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
//    
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomCode,@"roomCode", nil];
//    [dict setValue:dict2 forKey:@"head"];
//    [dict setValue:dict4 forKey:@"body"];
//    NSString *headStr = @"$102102|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *exitStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    NSLog(@"---退房间消息--%@",exitStr);
//    [self.client writeData:[exitStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}

//// 发送消息
//- (void)sendMessageWithMesssageModel:(Message *)item
//{
//    NSString *token = [NSGetTools getToken];
//    NSString *roomName = item.roomName;
//    NSString *roomCode = item.roomCode;
//    NSNumber *seqCodeNum = [NSNumber numberWithInt:10];
//   // NSNumber *msgType = [NSNumber numberWithInt:1];// 消息类型 1:文本 2:语音 3:视频 4:普通文件
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    // head
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
//    // body
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    // to 109112802 101111601
//    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"109112802",@"userAccount", nil];
//    // content
//    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:item.message,@"message",item.messageType,@"messageType", nil];
//    
//    [dict4 setValue:item.messageId forKey:@"chatId"];
//    [dict4 setValue:dict3 forKey:@"to"];
//    [dict4 setValue:dict5 forKey:@"content"];
//    [dict4 setValue:roomName forKey:@"roomName"];
//    [dict4 setValue:roomCode forKey:@"roomCode"];
//    [dict setValue:dict2 forKey:@"head"];
//    [dict setValue:dict4 forKey:@"body"];
//    
//    NSString *headStr = @"$102103|";
//    //NSString *jsonStr = [self dictionaryToJson:dict];
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    NSLog(@"---发送消息---%@",messageStr);
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}

//// 发送已读消息的信息
//- (void)sendAlreadyReadMsgInfoWithModel:(Message *)model
//{
//    NSString *token = [NSGetTools getToken];
//    NSNumber *seqCodeNum = [NSNumber numberWithInt:12];
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    // head
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
//    // body
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    
//    [dict4 setValue:model.messageId forKey:@"id"];
//    [dict setValue:dict2 forKey:@"head"];
//    [dict setValue:dict4 forKey:@"body"];
//    
//    NSString *headStr = @"$103102|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    NSLog(@"---发送已读消息---%@",messageStr);
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    
//}
//$102107|len{"head":{"seqCode":12,"token":String 令牌},"body":{"from":{"userAccount":String} "sendTime":String ->开始时间}协议体}
//- (void)getMessageWithTargetId:(NSString *)userId{
//    NSString *token = [NSGetTools getToken];
////    NSNumber *userId = [NSGetTools getUserID];
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    // head
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:12],@"seqCode",token,@"token",nil];
//    // body
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *date = [fmt stringFromDate:[NSDate date]];
//    NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userAccount", nil];
//    NSDictionary *temp1 = [NSDictionary dictionaryWithObjectsAndKeys:date,@"sendTime", nil];
//    [dict4 setValue:temp1 forKey:@"sendTime"];
//    [dict4 setValue:temp forKey:@"from"];
//    [dict setValue:dict2 forKey:@"head"];
//    [dict setValue:dict4 forKey:@"body"];
//    
//    NSString *headStr = @"$102107|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
////    NSLog(@"%@",messageStr);
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
//$103104|len{"head":{"seqCode":4,"token":String}，Body:{ "toUserAccount ":Stsring,}}
//- (void)getOffLineMessageWithToken:(NSString *)token correntUserId:(NSString *)correntUserId{
////$102107|107{"head":{"token":"1e6f4406-7b76-4d58-8a76-c811755a6509","seqCode":"4"},"body":{"toUserAccount":"10414800"}}
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
//    [headDict setObject:token forKey:@"token"];
//    [headDict setObject:@"4" forKey:@"seqCode"];
//    [bodyDict setObject:correntUserId forKey:@"toUserAccount"];
//    [dict setValue:headDict forKey:@"head"];
//    [dict setValue:bodyDict forKey:@"body"];
//    NSString *headStr = @"$103104|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
//$ 104101|len{"head":{"seqCode":4,"token":String}，“body":{"fromUserAccount":String 上个机器人的账号，可以多个，最后一个账号去掉逗号}}
//- (void)getRobotWithToken:(NSString *)token fromUserAccount:(NSString *)fromUserAccount{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
//    [headDict setObject:token forKey:@"token"];
//    [headDict setObject:@"4" forKey:@"seqCode"];
//    // 第一次请求，不传该字段
//    if ([fromUserAccount length] != 0) {
//        [bodyDict setObject:fromUserAccount forKey:@"toUserAccount"];
//    }else{
//       [bodyDict setObject:@"" forKey:@"toUserAccount"];
//    }
//    
//    [dict setValue:headDict forKey:@"head"];
//    [dict setValue:bodyDict forKey:@"body"];
//    NSString *headStr = @"$104101|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}


// 发送机器人消息
//$ 104102|len{"head":{"seqCode":4,"token":String},"body":{"toUserAccount":String,机器人" contentType ":Integer ->机器人内容类别"content":{" message":String , 消息内容" messageType":Integer,消息类型"timeStamp":String 时间戳}}}
//- (void)sendRobotMessageWithToken:(NSString *)token{
////$104102|203{"head":{"token":"1e6f4406-7b76-4d58-8a76-c811755a6509","seqCode":"4"},"body":{"contentType":1,"content":{"message":"机器人消息","timeStamp":"2015-12-29 11:43:35","messageType":1},"toUserAccount":"10414800"}}
//    
//    NSDictionary *robotDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"rebotResult"];
//    NSDictionary *msgDict = [robotDict objectForKey:@"content"];
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
//    [headDict setObject:token forKey:@"token"];
//    [headDict setObject:@"4" forKey:@"seqCode"];
//    [bodyDict setObject:[robotDict objectForKey:@"toUserAccount"] forKey:@"toUserAccount"];
//    [bodyDict setObject:[robotDict objectForKey:@"contentType"] forKey:@"contentType"];
//    NSDictionary *contentDict = [NSDictionary dictionaryWithObjectsAndKeys:[msgDict objectForKey:@"message"],@"message",[msgDict objectForKey:@"messageType"], @"messageType",[msgDict objectForKey:@"timeStamp"],@"timeStamp", nil];
//    [bodyDict setObject:contentDict forKey:@"content"];
//    
//    [dict setValue:headDict forKey:@"head"];
//    [dict setValue:bodyDict forKey:@"body"];
//    NSString *headStr = @"$104102|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
/**
 *  发送已阅$103102|len{"head":{"seqCode":12,"token":String 令牌},"body":{"id":long 消息id}协议体}
 *
 *  @param token
 *  @param messageId
 */
//- (void)readMessageWithToken:(NSString *)token messageId:(NSString *)messageId{
//    
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
////    $103102|len{"head":{"seqCode":12,"token":String 令牌},"body":{"id":long 消息id}协议体}
//    [headDict setObject:token forKey:@"token"];
//    [headDict setObject:@"12" forKey:@"seqCode"];
//    [bodyDict setObject:messageId forKey:@"id"];
//    [dict setValue:headDict forKey:@"head"];
//    [dict setValue:bodyDict forKey:@"body"];
//    NSString *headStr = @"$103102|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
//
////获取当前屏幕显示的viewcontroller(聊天界面)
//- (UIViewController *)activityViewController
//{
//    UIViewController *vc = nil;
//    
//    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
//        vc = [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController visibleViewController];
//    }
//    
//    return vc;
//}

@end
