//
//  ChatController.h
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "DHRecordTipView.h"
#import "UIImage+CH.h"
#import "DHConfigHeaderRefreshTool.h"
#import "DHOpenImage.h"
//#import "EaseMob.h"
//static NSString * const NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION = @"NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION";
@interface ChatController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

//@property (nonatomic,strong) NSString *jid;
////聊天用户的 头像
//@property (nonatomic,weak) UIImage *photo;
//@property (nonatomic,copy) NSString *photoUrl;

@property (nonatomic ,strong)DHMessageModel *item;
//聊天用户
@property (nonatomic,strong) DHUserInfoModel *userInfo;


@property (nonatomic,strong) AVAudioSession *avSession;

@property (nonatomic,strong) AVAudioRecorder *avRecorder;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSURL *urlPlay;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic,assign) BOOL isAudioBtnSelected;
@property (nonatomic,assign) BOOL isPictureBtnSelected;
/**
 *  录音时间计时器
 */
@property (nonatomic,strong) NSTimer *secTimer;
/**
 *  录音时间计时器的自增变量，用于判断录音时间，单位：s
 */
@property (nonatomic,assign) NSInteger secIndex;

@end
