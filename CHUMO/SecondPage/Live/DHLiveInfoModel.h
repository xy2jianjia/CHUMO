//
//  DHLiveInfoModel.h
//  CHUMO
//
//  Created by xy2 on 16/7/11.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLiveInfoModel : NSObject
/**
 *  频道id
 */
@property (nonatomic,strong) NSString *cid;
/**
 *  用户头像
 */
@property (nonatomic,strong) NSString *image;
/**
 *  用户昵称
 */
@property (nonatomic,strong) NSString *name;
/**
 *  频道类型
 */
@property (nonatomic,strong) NSString *type;
/**
 *  用户id
 */
@property (nonatomic,strong) NSString *uid;
/**
 *  观众人数
 */
@property (nonatomic,strong) NSString *count;
/**
 *  频道状态（0：空闲； 1：直播； 2：禁用； 3：直播录制）
 */
@property (nonatomic,strong) NSString *status;
/**
 *  网易直播频道id
 */
@property (nonatomic,strong) NSString *neteaseCid;
/**
 *  推流地址
 */
@property (nonatomic,strong) NSString *pushUrl;
/**
 *  http拉流地址
 */
@property (nonatomic,strong) NSString *httpPullUrl;
/**
 *  Hls拉流地址
 */
@property (nonatomic,strong) NSString *hlsPullUrl;
/**
 *  Rtmp拉流地址
 */
@property (nonatomic,strong) NSString *rtmpPullUrl;
/**
 *  直播开始时间
 */
@property (nonatomic,strong) NSString *createTime;
/**
 *  频道更新时间
 */
@property (nonatomic,strong) NSString *updateTime;

@end
