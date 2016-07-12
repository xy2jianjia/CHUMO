//
//  DHLiveInfoView.m
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLiveInfoView.h"

@implementation DHLiveInfoView

+ (void )configViewsInView:(UIView *)inView groupUserArr:(NSArray *)groupUserArr deleage:(id <DHLiveInfoViewDelegate>)delegate{
    [[[DHLiveInfoView alloc]init] configViewsInView:inView groupUserArr:groupUserArr deleage:delegate];
}
- (void )configViewsInView:(UIView *)inView groupUserArr:(NSArray *)groupUserArr deleage:(id <DHLiveInfoViewDelegate>)delegate{
    [self registerNotification];
    self.delegate = delegate;
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    
    // 主播头像
    _headerImageV = [[UIImageView alloc]init];
    _headerImageV.frame = CGRectMake(CGRectGetMinX(self.bounds)+10, CGRectGetMinY(self.bounds)+4, 38, 38);
    _headerImageV.layer.masksToBounds = YES;
    _headerImageV.layer.cornerRadius = 38/2;
    _headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageV.clipsToBounds = YES;
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1467786522&di=aabc13676e1bab6196f255c345e7067e&src=http://t-1.tuzhan.com/9f22a0485752/c-2/l/2013/04/15/16/782a7cb2988148eebac581a688ce8f2c.jpg"] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    [self addSubview:_headerImageV];
    
    // 名字背景
    _nameBgView = [[UIView alloc]init];
    _nameBgView.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+14, CGRectGetMinY(self.bounds)+5, ScreenWidth - 10-38-14-10-28, 28);
    _nameBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4000];
    _nameBgView.layer.cornerRadius = 14;
    _nameBgView.layer.masksToBounds = YES;
    [self addSubview:_nameBgView];
    
    // 名字label
    _nameLabel =[[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMinX(_nameBgView.bounds)+9, CGRectGetMinY(_nameBgView.bounds), 100, CGRectGetHeight(_nameBgView.bounds));
    _nameLabel.font = [UIFont  systemFontOfSize:15];
    _nameLabel.textColor = kUIColorFromRGB(0x323232);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = @"羞答答的玫瑰";
    [_nameBgView addSubview:_nameLabel];
    
    // 人数label
    _countLabel = [[UILabel alloc]init];
    _countLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+9, CGRectGetMinY(_nameLabel.frame), CGRectGetWidth(_nameBgView.bounds)-9-9-9-CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_nameLabel.frame));
    _countLabel.font = [UIFont systemFontOfSize:15];
    _countLabel.textColor = kUIColorFromRGB(0x666);
    _countLabel.text = @"当前100人";
    [_nameBgView addSubview:_countLabel];
    
    
    // 关闭按钮
    _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeBtn.frame = CGRectMake(ScreenWidth - 10-28, CGRectGetMinY([[UIScreen mainScreen] bounds])+5, 28, 28);
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"exit"] forState:(UIControlStateNormal)];
    [_closeBtn addTarget:self action:@selector(closeLiveAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_closeBtn];
    if (groupUserArr.count > 0) {
        // 观众头像列表
        _groupUserScrollV =[[UIScrollView alloc]init];
        _groupUserScrollV.frame = CGRectMake(0, CGRectGetMaxY(_headerImageV.frame)+9, ScreenWidth, 44);
        _groupUserScrollV.contentSize = CGSizeMake(10 + groupUserArr.count *44+(groupUserArr.count - 1) * 12 , 0);
        CGFloat width = 44;
        for (int i = 0; i < groupUserArr.count; i ++) {
            NSString *portaiUrl = [groupUserArr objectAtIndex:i];
            UIImageView *userBtn = [[UIImageView alloc]init];
            userBtn.frame = CGRectMake(10 + 44*i+12*i, CGRectGetMinY(_groupUserScrollV.bounds), width, width);
            userBtn.userInteractionEnabled = YES;
            userBtn.layer.masksToBounds = YES;
            userBtn.layer.cornerRadius = 44/2;
            userBtn.contentMode = UIViewContentModeScaleAspectFill;
            userBtn.clipsToBounds = YES;
            // 记录下标
            userBtn.tag = i;
            UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchUserPortrait:)];
            [userBtn addGestureRecognizer:openTap];
            [userBtn sd_setImageWithURL:[NSURL URLWithString:portaiUrl] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            [_groupUserScrollV addSubview:userBtn];
        }
        [self addSubview:_groupUserScrollV];
    }
   // 评论区
    _communicateTableV = [[UITableView alloc]init];
    _communicateTableV.backgroundColor = [UIColor clearColor];
    
    _communicateTableV.frame = CGRectMake(10, ScreenHeight -173, ScreenWidth-20, 116);
    _communicateTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _communicateTableV.allowsSelection = NO;
    
    _communicateTableV.delegate = self;
    _communicateTableV.dataSource = self;
    [_communicateTableV registerClass:[DHLiveConmunicateCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_communicateTableV];
    [inView addSubview:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_delegate && [_delegate respondsToSelector:@selector(live_numberOfSectionsInTableView:)]) {
        return [_delegate live_numberOfSectionsInTableView:tableView];
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(live_tableView:numberOfRowsInSection:)]) {
        return [_delegate live_tableView:tableView numberOfRowsInSection:section];
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(live_tableView:heightForRowAtIndexPath:)]) {
        return [_delegate live_tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 0;
    }
}

-(DHLiveConmunicateCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(live_tableView:cellForRowAtIndexPath:)]) {
        return [_delegate live_tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        return nil;
    }
}
- (void)live_didReceivedMessage:(NSNotification *)notifi{
    if (_delegate && [_delegate respondsToSelector:@selector(live_tableView:didReceivedMessage:)]) {
        LiveMessageModel *item = notifi.object;
//        item.messageId = @"1";
//        item.message = @"思念是一种病";
//        item.targetId = @"10086";
//        item.targetName = @"大话西游";
//        item.timeStamp = @"2016年07月07日16:20:51";
        [_delegate live_tableView:_communicateTableV didReceivedMessage:item];
    }
}

/**
 *  关闭直播
 *
 *  @param sender
 */
- (void)closeLiveAction:(UIButton *)sender{

    if (_delegate && [_delegate respondsToSelector:@selector(didClosedLiveInfoView:)]) {
        return [_delegate didClosedLiveInfoView:self];
    }

}
/**
 *  点击用户头像
 *
 *  @param sender
 */
- (void)didTouchUserPortrait:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag;
    if (_delegate && [_delegate respondsToSelector:@selector(liveInfoView:didOpenUserInfoWithIndex:)]) {
        [_delegate liveInfoView:self didOpenUserInfoWithIndex:index];
    }
}
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(live_didReceivedMessage:) name:LIVE_DIDRECEIVED_MESSAGE_NOTIFICATION object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
