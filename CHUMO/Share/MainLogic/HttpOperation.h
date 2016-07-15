//
//  HttpOperation.h
//  CHUMO
//
//  Created by xy2 on 16/4/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YS_PayModel.h"
#import "DHLiveInfoModel.h"
#import "ASIFormDataRequest.h"
#import "DHLiveImMsgModel.h"
#import "DhFriendModel.h"
@class HttpOperation;

@protocol HttpOperationDelegate <NSObject>

- (void) live_dataDidLoaded:(DHLiveInfoModel *)liveInfo code:(NSInteger )code;

@end

@interface HttpOperation : NSObject<ASIHTTPRequestDelegate>
@property (nonatomic,weak) id <HttpOperationDelegate >delegate;
/**
 *  注册
 *
 *  @param queue 一般传main_queue
 *  @param completed
 */
+ (void)asyncRegisterWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed;
/**
 *  登录
 *
 *  @param username  用户名
 *  @param password  密码
 *  @param queue     一般传main_queue
 *  @param completed 
 */
+ (void)asyncLoginWithUserName:(NSString *)username password:(NSString *)password queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *loginInfo))completed;
/**
 *  保存用户信息
 *
 *  @param userInfoDict 用户信息
 *  @param queue
 *  @param completed    
 */
+ (void)asyncSaveUserInfoWithUserInfoDict:(NSDictionary *)userInfoDict queue:(dispatch_queue_t )queue completed:(void(^)(NSString *b34))completed;
/**
 *  获取用户详细信息
 *
 *  @param p2        userId
 *  @param queue
 *  @param completed 
 */
+ (void)asyncGetUserInfoWithUserId:(NSString *)p2 queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *info,DHUserInfoModel *userInfoModel))completed;
/**
 *  获取后台配置的系统数据
 *
 *  @param queue
 *  @param completed 
 */
+ (void)asyncGetSystemConfigrationInfoWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed;
/**
 *  加载头像
 *
 *  @param queue
 *  @param completed 
 */
+ (void)asyncConfigHeaderImageDataWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed;
/**
 *  发官方消息
 */
+ (void)asyncConfigSayHelloMessage;
/**
 *  上传im图片
 *
 *  @param imageList 图片数组
 *  @param completed 
 */
+ (void)im_asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl ,long datalength,NSString *fileName))completed;
/**
 *  上传音频
 *
 *  @param audioData
 *  @param completed
 */
+ (void)im_asyncUploadAudioWithAudioData:(NSData *)audioData completed:(void(^)(NSString *fileUrl ,long datalength,NSString *fileName))completed;
/**
 *  app升级机制
 *
 *  @param completed 
 */
+ (void)asyncUpgradeWithCompleted:(void(^)(NSDictionary *infoDic))completed;
/**
 *  接入聊天前,保存当前用户与target用户的好友关系
 *
 *  @param friendId   对方id
 *  @param friendName 对方昵称
 *  @param queue
 *  @param completed  
 */
+ (void)asyncSaveFriendshipWithFriendId:(NSString *)friendId friendName:(NSString *)friendName queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed;
/**
 *  1.1	检查用户是否有兑换话费权限
 *
 *  @param queue     
 *  @param completed true：有记录  false：无记录
 */
+ (void)asyncChargesWithQueue:(dispatch_queue_t )queue completed:(void(^)(BOOL permission , NSInteger code))completed;
/**
 *  用户兑换话费
 *
 *  @param phoneNumber 电话号码
 *  @param queue
 *  @param completed
 */
+ (void)asyncExchangeChargesWithPhoneNumber:(NSString * )phoneNumber queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo , NSInteger code,NSString *msg))completed;
/**
 *  用户兑换码兑换
 *
 *  @param prepaidCode 兑换码
 *  @param queue
 *  @param completed
 */
+ (void)asyncExchangePrepaidCodeWithPrepaidCode:(NSString *)prepaidCode queue:(dispatch_queue_t )queue completed:(void(^)(NSInteger code,NSString *msg))completed;
/**
 *  提取vip列表：获取商品列表
 *
 *  @param type      1:套餐  2：单卖
 *  @param goodsCode 商品编码
 *  @param catagery  1：普通商品 2：活动商品
 *  @param queue
 *  @param completed 
 */
+ (void)asyncGetVipListWithType:(NSInteger )type goodsCode:(NSInteger )goodsCode catagery:(NSInteger )catagery queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *vipArr , NSInteger code))completed;
/**
 *  取消请求
 *
 *  @param queue 
 */
+ (void)asyncCancelRequestWithQueue:(dispatch_queue_t )queue;
/**
 *  请求对话信息
 */
+ (void)asyncGetMessagesOfMySelfWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed;
/**
 *  统计---保存用户状态：1：激活 2：活跃 3：注册（注册成功、注册失败）目前只做1和3
 *
 *  @param userType  用户类型1：激活 2：活跃 3：注册（成功），4注册（失败）
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectSaveWithUserType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计---保存支付统计信息
 *
 *  @param payType   支付类型 1:支付宝2：微信3：系统 4:易联
 *  @param price     支付金额
 *  @param status    支付状态 1:成功 2：失败 3:等待支付 4:回退 （目前只做成功的）
 *  @param goodCode  商品编号
 *  @param orderNum  订单号
 *  @param userType  用户类型 1：新用户2：老用户
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectPaySaveWithPayType:(NSInteger )payType price:(float )price status:(NSInteger )status goodCode:(NSString *)goodCode orderNum:(NSString *)orderNum userType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计---保存事件
 *
 *  @param pointType 事件类型 1：注册按钮 2：点击头像（选择性别） 3：选择年龄 4：昵称确定 5：…其他事件可自定义
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectEventSaveWithPointType:(NSInteger )pointType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计 ---保存升级信息
 *
 *  @param oldAppVer  老版本号
 *  @param oldAppName 老版本名称
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectUpgradeSaveWithOldAppVer:(NSString *)oldAppVer oldAppName:(NSString *)oldAppName queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计 --- 应用下载信息统计
 
 *
 *  @param source        1：商店 2：banner 3：站内push4：消息栏 5：快捷方式 6：静默7：积分墙 8：贴片广告  9：退出 10：定时弹窗  11：webview下载
 *  @param status        1：请求下载 3：下载成功 4：安装成功 2：断点续传
 *  @param target_app_id 被下载应用appId
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectDownLoadSaveWithSource:(NSInteger )source status:(NSInteger )status target_app_id:(NSString *)target_app_id queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计 ---	推广用户信息上传
 *
 *  @param ticket    用户票据 1001-1008-1005
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectExpandUpLoadSaveWithTicket:(NSString *)ticket queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;
/**
 *  统计 -- 推广用户应用下载上传
 *
 *  @param webCode      推广站点编号
 *  @param appId        推广应用编号
 *  @param downloadType 下载类型 1：主动下载 2：自动下载';
 *  @param keynum       关键词
 *  @param queue
 *  @param completed
 */
+ (void)asyncCollectExpandUserDownLoadUpLoadSaveWithWebCode:(NSString *)webCode appId:(NSString *)appId downloadType:(NSInteger )downloadType keynum:(NSString *)keynum queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed;

/**
 *  直播 --- 开启直播
 *
 *  @param targetUserId 用户id
 *  @param nickName     用户昵称
 *  @param portrait     头像链接
 *  @param type         频道类型 ( 0 : rtmp, 1 : hls, 2 : http)
 *  @param queue
 *  @param completed    
 */
+ (void)asyncLive_OpenLiveWithTargetUserId:(NSString *)targetUserId nickName:(NSString *)nickName portrait:(NSString *)portrait type:(NSInteger )type delegate:(id <HttpOperationDelegate>)delegate;
/**
 *  直播 --- 关闭直播
 *
 *  @param chanelId   频道id
 *  @param chanelName 频道名称
 *  @param type       频道类型 ( 0 : rtmp, 1 : hls, 2 : http)
 *  @param queue
 *  @param completed
 */
+ (void)asyncLive_ColsedLiveWithChanelId:(NSString *)chanelId chanelName:(NSString *)chanelName type:(NSInteger )type queue:(dispatch_queue_t )queue completed:(void(^)(NSString *msg , NSInteger code))completed;
/**
 *  直播 --- 获取直播列表
 *
 *  @param curPage   当前页
 *  @param pageSize  请求页数
 *  @param queue
 *  @param completed
 */
+ (void)asyncLive_GetChanelListWithCurPage:(NSInteger )curPage pageSize:(NSInteger )pageSize queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *chanelList , NSInteger code))completed;

/**
 *  直播 ---网易im登录
 *
 *  @param queue
 *  @param completed 
 */
+ (void)asyncLiveIM_GetLoginTokenWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *neteaseImInfo , NSInteger code))completed;
/**
 *  直播 --- 网易聊天室发消息
 *
 *  @param roomId     主播的直播频道id
 *  @param resendFlag 重发消息标记，0：非重发消息，1：重发消息，如重发消息会按照msgid检查去重逻辑
 *  @param msgModel   消息model：（1）、客户端消息id，使用uuid等随机串，msgId相同的消息会被客户端去重；
 *  （2）、消息类型：
 *  0: 表示文本消息，
 *  1: 表示图片，
 *  2: 表示语音，
 *  3: 表示视频，
 *  4: 表示地理位置信息，
 *  6: 表示文件，
 *  10: 表示Tips消息，
 *  100: 自定义消息类型
 *  （3）消息内容，格式同消息格式示例中的body字段,长度限制2048字节
 ）
 *  @param queue
 *  @param completed
 */
+ (void)asyncLiveIM_SendMessageWithRoomId:(NSString *)roomId resendFlag:(NSString *)resendFlag msgModel:(DHLiveImMsgModel *)msgModel queue:(dispatch_queue_t )queue completed:(void(^)(DHLiveImMsgModel *msgModel , NSInteger code))completed;
/**
 *  好友关系查询
 *
 *  @param queue
 *  @param completed 
 */
+ (void)asyncGetFriendListWithPage:(NSString *)page queue:(dispatch_queue_t )queue completed:(void(^)(NSArray *friendList , NSInteger code,NSInteger hasNext))completed;


@end
