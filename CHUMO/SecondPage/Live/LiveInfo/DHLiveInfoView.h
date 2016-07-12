//
//  DHLiveInfoView.h
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHLiveConmunicateCell.h"
#import "LiveMessageModel.h"


@class DHLiveInfoView;

@protocol DHLiveInfoViewDelegate <NSObject>
/**
 *  关闭直播
 *
 *  @param liveInfoView
 */
- (void)didClosedLiveInfoView:(DHLiveInfoView *)liveInfoView ;
/**
 *  打开用户头像
 *
 *  @param liveInfoView
 *  @param userIndex    用户所在数组的下标
 */
- (void)liveInfoView:(DHLiveInfoView *)liveInfoView didOpenUserInfoWithIndex:(NSInteger )userIndex;


#pragma mark ---聊天列表
- (NSInteger)live_numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)live_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (DHLiveConmunicateCell *)live_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)live_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)live_tableView:(UITableView *)tableView didReceivedMessage:(LiveMessageModel *)liveMessage;

@end

static  NSString * const LIVE_DIDRECEIVED_MESSAGE_NOTIFICATION = @"LIVE_DIDRECEIVED_MESSAGE_NOTIFICATION";
@interface DHLiveInfoView : UIView<UITableViewDelegate,UITableViewDataSource>
/**
 *  直播用户头像
 */
@property (nonatomic,strong) UIImageView *headerImageV;
/**
 *  名字 背景
 */
@property (nonatomic,strong) UIView *nameBgView;
/**
 *  名字label
 */
@property (nonatomic,strong) UILabel *nameLabel;
/**
 *  观看直播的人数label
 */
@property (nonatomic,strong) UILabel *countLabel;
/**
 *  关闭直播按钮
 */
@property (nonatomic,strong) UIButton *closeBtn;

/**
 *  观众头像列表
 */
@property (nonatomic,strong) UIScrollView *groupUserScrollV;
/**
 *  评论列表
 */
@property (nonatomic,strong) UITableView *communicateTableV;
/**
 *  代理
 */
@property (weak,nonatomic) id <DHLiveInfoViewDelegate> delegate;


+ (void )configViewsInView:(UIView *)inView groupUserArr:(NSArray *)groupUserArr deleage:(id <DHLiveInfoViewDelegate>)delegate;

@end
