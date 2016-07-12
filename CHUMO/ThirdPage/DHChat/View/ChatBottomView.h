//
//  ChatBottomView.h
//  微信
//
//  Created by Think_lion on 15/6/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatBottomView;
@class SendTextView;
@class IOSr;
//定义此view的高度
#define BottomHeight 49

//定义一个枚举
typedef enum{
    BottomButtonTypeEmotion, //表情按钮
    BottomButtonTypeAddPicture, //图片按钮
    BottomButtonTypeAudio, //语音按钮
    
}BottomButtonType;


//定义一个协议
@protocol ChatBottomViewDelegate <NSObject>

@optional
-(void)chatbottomView:(ChatBottomView*)bottomView buttonTag:(BottomButtonType)buttonTag;

@end


@interface ChatBottomView : UIView

@property (nonatomic,weak) SendTextView *BottominputView;


@property (nonatomic,weak) id<ChatBottomViewDelegate>delegate;

//表情按钮的选中状态
@property (assign,nonatomic) BOOL emotionStatus;
//添加图片按钮的选中状态
@property (assign,nonatomic) BOOL addStatus;

@property (nonatomic,weak) UIButton *temp;

@property (nonatomic,weak) UIButton *audioBtn;  //语音按钮
@property (nonatomic,weak) UIButton *faceBtn; //表情按钮
@property (nonatomic,weak) UIButton *addBtn;  //发送图片的按钮

@end
