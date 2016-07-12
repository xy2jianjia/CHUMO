//
//  DHHostLiveInfoViewController.m
//  CHUMO
//
//  Created by xy2 on 16/7/11.
//  Copyright © 2016年 youshon. All rights reserved.
//
/**
 *  主播页面 --2016年07月11日11:49:25 bydh
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */

#import "DHHostLiveInfoViewController.h"
#import "DHLiveInfoView.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"
#import "LSMediaCapture.h"
#import "nMediaLiveStreamingDefs.h"
@interface DHHostLiveInfoViewController ()<HttpOperationDelegate>
/**
 *  观众数组
 */
@property (nonatomic,strong) NSMutableArray *groupUserArr;
/**
 *  评论区数组
 */
@property (nonatomic,strong) NSMutableArray *comunicateArr;
/**
 *  观众播放器
 */
//@property (nonatomic,strong) NELivePlayerController *player;
/**
 *  推流
 */
@property (nonatomic,strong) LSMediaCapture *capture;
@property (nonatomic,assign) LSVideoParaCtx sVideoParaCtx;//推流视频参数设置

@property (nonatomic,strong) DHLiveInfoModel *liveInfo;

@end

@implementation DHHostLiveInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configPlayer];
    // 及时通讯通知测试
    [self postNotificationTest];
    
}
- (void)postNotificationTest{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hehe:) userInfo:nil repeats:YES];
    [timer fire];
}
- (void)hehe:(NSTimer *)timer{
    
    NSArray *messages = @[@"为什么年轻人一定要熬夜",@"皂滑弄人。",@"光阴似箭",@"有求必硬",@"日久生情",@"最饿身重",@"叶落归根",@"为什么上班后都怀念上学的时候？",@"因为不想上班。",@"神回复大赛：发粪涂墙",@"为什么暑假想上班，上班想暑假？？",@"什么我开了飞行模式不能飞",@"什么我开了静音模式还能听到周围的噪音",@"为什么我开了正常模式我的精神病还是没好",@"你被交警拦下，说一句什么话最霸气",@"兄弟，再陪哥来一盅",@"去哪啊叫爸爸免费带你",@"为什么我吃了炫迈还是会停下来",@"一次嚼一盒试试",@"为什么日本AV男优来来回回就那几个？",@"什么我还没上天与太阳肩并肩",@"为什么逗逼污女都在神吧？",@"为什么诸葛亮明明有老婆，却没有孩子，就为了照顾刘禅，做了老处男差不多的角色？",@"诸葛瞻（长子），诸葛怀（幼子）、诸葛果（长女）、诸葛乔（养子，原诸葛瑾之子）",@"古代经常用手捋胡子的都肾不好"];
    NSArray *nameArr = @[@"如梦清瑶",@"落幕我伤",@"小强你别闹o",@"叶落又一生",@"灬为所欲为灬",@"烟火JIN",@"日后在顶",@"亚麻跌吧",@"怕什么咯",@"吴杰超__飞",@"鸽子111222",@"蜡笔蜡笔起床啦",@"疯骚earth"];
    
    NSInteger randomIndex1 = (arc4random() % (messages.count - 1 - 0 +1))+0;
    NSInteger randomIndex2 = (arc4random() % (nameArr.count - 1 - 0 +1))+0;
    LiveMessageModel *item = [[LiveMessageModel alloc]init];
    item.messageId = [NSString stringWithFormat:@"%d",randomIndex1];
    item.message = [messages objectAtIndex:randomIndex1];
    item.targetName = [nameArr objectAtIndex:randomIndex2];
    item.timeStamp = @"2016年07月07日16:30:29";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LIVE_DIDRECEIVED_MESSAGE_NOTIFICATION object:item];
    
}
- (void) live_dataDidLoaded:(DHLiveInfoModel *)liveInfo code:(NSInteger )code{
    dispatch_async(dispatch_get_main_queue(), ^{
    _liveInfo = liveInfo;
    
    NSString *url = nil;
    // 主播
    url = liveInfo.pushUrl;
    
    //初始化直播参数，并创建音视频直播
    NSError* error = nil;
    LSLiveStreamingParaCtx paraCtx;
    paraCtx.eHaraWareEncType             = LS_HRD_NO;
    paraCtx.eOutFormatType               = LS_OUT_FMT_RTMP;
    paraCtx.eOutStreamType               = LS_HAVE_AV; //这里可以设置推音视频流／音频流／视频流，如果只推送视频流，则不支持伴奏播放音乐
    memcpy(&paraCtx.sLSVideoParaCtx, &_sVideoParaCtx, sizeof(LSVideoParaCtx));
    paraCtx.sLSAudioParaCtx.bitrate       = 64000;
    paraCtx.sLSAudioParaCtx.codec         = LS_AUDIO_CODEC_AAC;
    paraCtx.sLSAudioParaCtx.frameSize     = 2048;
    paraCtx.sLSAudioParaCtx.numOfChannels = 1;
    paraCtx.sLSAudioParaCtx.samplerate    = 44100;
    self.capture = [[LSMediaCapture alloc]initLiveStream:url];
    
    [_capture setTraceLevel:LS_LOG_DEFAULT];
    NSError *error1 = nil;
    [self.capture startLiveStreamWithError:&error1];
    if (error1) {
        NSLog(@"初始化推流失败%@",error);
    }
    
        //打开摄像头预览
        [_capture startVideoPreview:self.view];
        [self configLiveViewInview:self.view];
    });
}
- (void)startUpWithUserInfo:(DHUserInfoModel *)userInfo{
    
    [HttpOperation asyncLive_OpenLiveWithTargetUserId:userInfo.b80 nickName:userInfo.b52 portrait:userInfo.b57 type:0 delegate:self];
    
//    [HttpOperation asyncLive_OpenLiveWithTargetUserId:userInfo.b80 nickName:userInfo.b52 portrait:userInfo.b57 type:0 queue:nil completed:^(DHLiveInfoModel *liveInfo, NSInteger code) {
//        
//        _liveInfo = liveInfo;
//        
//        NSString *url = nil;
//        // 主播
//        //        url = @"rtmp://p56d71a0a.live.126.net/live/97fbeb06c256401e9f977c7ec82a50e6?wsSecret=efefcdd2f9bc3d26d5118c6cde5db6c5&wsTime=1467803721";
//        //    NSString *url = @"http://v56d71a0a.live.126.net/live/97fbeb06c256401e9f977c7ec82a50e6.flv";
//        //    NSString *url = @"rtmp://v56d71a0a.live.126.net/live/97fbeb06c256401e9f977c7ec82a50e6";
//        
//        url = liveInfo.pushUrl;
//        
//        //初始化直播参数，并创建音视频直播
//        NSError* error = nil;
//        LSLiveStreamingParaCtx paraCtx;
//        paraCtx.eHaraWareEncType             = LS_HRD_NO;
//        paraCtx.eOutFormatType               = LS_OUT_FMT_RTMP;
//        paraCtx.eOutStreamType               = LS_HAVE_AV; //这里可以设置推音视频流／音频流／视频流，如果只推送视频流，则不支持伴奏播放音乐
//        memcpy(&paraCtx.sLSVideoParaCtx, &_sVideoParaCtx, sizeof(LSVideoParaCtx));
//        paraCtx.sLSAudioParaCtx.bitrate       = 64000;
//        paraCtx.sLSAudioParaCtx.codec         = LS_AUDIO_CODEC_AAC;
//        paraCtx.sLSAudioParaCtx.frameSize     = 2048;
//        paraCtx.sLSAudioParaCtx.numOfChannels = 1;
//        paraCtx.sLSAudioParaCtx.samplerate    = 44100;
//        self.capture = [[LSMediaCapture alloc]initLiveStream:url];
//        
//        [_capture setTraceLevel:LS_LOG_DEFAULT];
//        NSError *error1 = nil;
//        [self.capture startLiveStreamWithError:&error1];
//        if (error1) {
//            NSLog(@"初始化推流失败%@",error);
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //打开摄像头预览
//            [_capture startVideoPreview:self.view];
//            [self configLiveViewInview:self.view];
//        });
//    }];
}

- (void)configPlayer{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (!userInfo) {
        __weak typeof (&* self)weakSelf = self;
        [HttpOperation asyncGetUserInfoWithUserId:userId queue:nil completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
            [weakSelf startUpWithUserInfo:userInfoModel];
        }];
    }else{
        [self startUpWithUserInfo:userInfo];
    }
}
- (void)configLiveViewInview:(UIView *)inview{
    _groupUserArr = @[@"http://www.qq1234.org/uploads/allimg/150129/1615131V7-0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/16151313a-9.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615133443-3.jpg",@"http://img3.imgtn.bdimg.com/it/u=3589741497,617053446&fm=21&gp=0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615135403-6.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615134139-5.jpg",@"http://lol.wanyx.com/img.wanyx.com/public/upload/hero6da7464f173512c8773e6c6a8a94303c.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615131V7-0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/16151313a-9.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615133443-3.jpg",@"http://img3.imgtn.bdimg.com/it/u=3589741497,617053446&fm=21&gp=0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615135403-6.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615134139-5.jpg",@"http://lol.wanyx.com/img.wanyx.com/public/upload/hero6da7464f173512c8773e6c6a8a94303c.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615131V7-0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/16151313a-9.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615133443-3.jpg",@"http://img3.imgtn.bdimg.com/it/u=3589741497,617053446&fm=21&gp=0.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615135403-6.jpg",@"http://www.qq1234.org/uploads/allimg/150129/1615134139-5.jpg",@"http://lol.wanyx.com/img.wanyx.com/public/upload/hero6da7464f173512c8773e6c6a8a94303c.jpg"].mutableCopy;
    [DHLiveInfoView configViewsInView:inview groupUserArr:_groupUserArr deleage:self];
    NSArray *messages = @[@"为什么年轻人一定要熬夜",@"皂滑弄人。",@"光阴似箭",@"有求必硬",@"日久生情",@"最饿身重",@"叶落归根",@"为什么上班后都怀念上学的时候？",@"因为不想上班。",@"神回复大赛：发粪涂墙",@"为什么暑假想上班，上班想暑假？？",@"什么我开了飞行模式不能飞",@"什么我开了静音模式还能听到周围的噪音",@"为什么我开了正常模式我的精神病还是没好",@"你被交警拦下，说一句什么话最霸气",@"兄弟，再陪哥来一盅",@"去哪啊叫爸爸免费带你",@"为什么我吃了炫迈还是会停下来",@"一次嚼一盒试试",@"为什么日本AV男优来来回回就那几个？",@"什么我还没上天与太阳肩并肩",@"为什么逗逼污女都在神吧？",@"为什么诸葛亮明明有老婆，却没有孩子，就为了照顾刘禅，做了老处男差不多的角色？",@"诸葛瞻（长子），诸葛怀（幼子）、诸葛果（长女）、诸葛乔（养子，原诸葛瑾之子）",@"古代经常用手捋胡子的都肾不好"];
    NSArray *nameArr = @[@"如梦清瑶",@"落幕我伤",@"小强你别闹o",@"叶落又一生",@"灬为所欲为灬",@"烟火JIN",@"日后在顶",@"亚麻跌吧",@"怕什么咯",@"吴杰超__飞",@"鸽子111222",@"蜡笔蜡笔起床啦",@"疯骚earth"];
    
    _comunicateArr = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        NSInteger randomIndex1 = (arc4random() % (messages.count - 1 - 0 +1))+0;
        NSInteger randomIndex2 = (arc4random() % (nameArr.count - 1 - 0 +1))+0;
        LiveMessageModel *item = [[LiveMessageModel alloc]init];
        item.messageId = [NSString stringWithFormat:@"%d",i];
        item.message = [messages objectAtIndex:randomIndex1];
        item.targetName = [nameArr objectAtIndex:randomIndex2];
        item.timeStamp = @"2016年07月07日16:30:29";
        [_comunicateArr addObject:item];
    }
    
}

-(void)didClosedLiveInfoView:(DHLiveInfoView *)liveInfoView{
//    [self shutDownPlayer];
    [self shutDownCapture];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self shutDownPlayer];
//    [self shutDownCapture];
}

- (void)shutDownCapture{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否关闭直播？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpOperation asyncLive_ColsedLiveWithChanelId:_liveInfo.neteaseCid chanelName:_liveInfo.name type:0 queue:nil completed:^(NSString *msg, NSInteger code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:msg];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [self.capture stopLiveStream:^(NSError *error) {
            if (error) {
                NSLog(@"关闭推流失败：%@",error);
            }
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  释放播放器，注销
 */
- (void)shutDownPlayer{
//    [self.player stop];
//    [self.player shutdown];
//    [self.player.view removeFromSuperview];
//    self.player = nil;
}
-(void)liveInfoView:(DHLiveInfoView *)liveInfoView didOpenUserInfoWithIndex:(NSInteger)userIndex{
    
    NSLog(@"%@",[_groupUserArr objectAtIndex:userIndex]);
    
}
-(NSInteger)live_numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)live_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comunicateArr.count;
}
-(CGFloat)live_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveMessageModel *item = [_comunicateArr objectAtIndex:indexPath.row];
    CGFloat height1 = [self hightForContent:[NSString stringWithFormat:@"%@：",item.targetName] fontSize:15].height+10;
    CGFloat height2 = [self hightForContent:[NSString stringWithFormat:@"%@：",item.message] fontSize:15].height+10;
    if (height1 == height2) {
        return height1+0+0;
    }else{
        return height1 > height2 ? height1+00+0 : height2+0+0;
    }
}
-(DHLiveConmunicateCell *)live_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DHLiveConmunicateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LiveMessageModel *item = [_comunicateArr objectAtIndex:indexPath.row];
    [cell setMessageModel:item];
    return cell;
}

-(void)live_tableView:(UITableView *)tableView didReceivedMessage:(LiveMessageModel *)liveMessage{
    if (_comunicateArr.count > 100) {
        [_comunicateArr removeObjectsInRange:NSMakeRange(0, 80)];
    }
    [_comunicateArr addObject:liveMessage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        [self scrollToBottomWithAnimated:YES tableView:tableView];
    });
    
}
#pragma mark 滚到最后一行的方法
-(void)scrollToBottomWithAnimated:(BOOL)animated tableView:(UITableView *)tableView{
    
    //如果数组李米娜没有值 返回
    if(!_comunicateArr.count) return;
    // 2.让tableveiw滚动到最后一行
    NSIndexPath *path = [NSIndexPath indexPathForRow:_comunicateArr.count - 1  inSection:0];
    /*
     AtIndexPath: 要滚动到哪一行
     atScrollPosition:滚动到哪一行的什么位置
     animated:是否需要滚动动画
     */
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}

- (CGSize )hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake(ScreenWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

@end
