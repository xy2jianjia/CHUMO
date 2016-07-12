//
//  ChatBottomView.m
//  微信
//
//  Created by Think_lion on 15/6/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatBottomView.h"
#import "SendTextView.h"
#import "UIView+MJ.h"
#import "UIImage+CH.h"
#define centerMargin 5
#define leftMargin  2
#define buttonWidth 35
#define buttonHeight  buttonWidth
#define inputViewH 36

@interface ChatBottomView ()





@end

@implementation ChatBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //1.定义自己的宽度和高度
        self.width=ScreenWidth;
        self.height=BottomHeight; //跟标签栏的高度一样高
        self.backgroundColor=[UIColor whiteColor];
        //2.添加子控件
        [self setupFirst];
    }
    return self;
}

#pragma mark 添加子控件
-(void)setupFirst
{
    //1.添加一条线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line];
    //2.添加语音按钮
    UIButton *audioBtn=[self addButtonWithImage:@"ToolViewInputVoice" highImage:@"ToolViewInputVoiceHL"  tag:BottomButtonTypeAudio];
    self.audioBtn=audioBtn;
    //3.添加输入框
    [self addTextView];
    //4.添加表情按钮
    UIButton *faceBtn=[self addButtonWithImage:@"ToolViewEmotion" highImage:@"ToolViewEmotion"  tag:BottomButtonTypeEmotion];
    self.faceBtn=faceBtn;
    //5.添加图片按钮
    UIButton *addBtn=[self addButtonWithImage:@"w_liaotian_tp" highImage:@""  tag:BottomButtonTypeAddPicture];
    self.addBtn=addBtn;
    
}
#pragma mark 添加输入框
-(void)addTextView
{
    SendTextView *send=[[SendTextView alloc]init];
  
    [self addSubview:send];
    self.BottominputView=send;

}
#pragma mark 添加按钮
-(UIButton*)addButtonWithImage:(NSString*)image highImage:(NSString*)highImage  tag:(BottomButtonType)tag
{
    UIButton *btn=[[UIButton alloc]init];
    UIImage *image1 = [UIImage imageNamed:image];
    [btn setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn setBackgroundImage:image1 forState:UIControlStateHighlighted];
    btn.tag=tag;
    //添加方法
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark 按钮点击的事件
-(void)buttonClick:(UIButton*)sender
{

    if([self.delegate respondsToSelector:@selector(chatbottomView:buttonTag:)]){
        [self.delegate chatbottomView:self buttonTag:sender.tag];
    }
}

#pragma mark 设置表情按钮的图片
-(void)setEmotionStatus:(BOOL)emotionStatus
{
    _emotionStatus=emotionStatus;
    //取消其他按钮的选中状态
    _addStatus=NO;
    
    if(emotionStatus){
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }else{
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.faceBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewEmotion"] forState:UIControlStateHighlighted];

    }
}
#pragma mark 设置添加图片的按钮
-(void)setAddStatus:(BOOL)addStatus
{
    _addStatus=addStatus;
    _emotionStatus=NO;
    if(addStatus){
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }else{
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage resizedImage:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
    }
}

-(void)layoutSubviews
{
    [super subviews];
    //每个按钮的高度40   父视图的高度49
    CGFloat btnY=(self.height-buttonHeight)*0.5;
 
    CGFloat audioX=leftMargin;
    self.audioBtn.frame=CGRectMake(audioX, btnY, buttonWidth, buttonHeight);
    //2.输入框的frame
    CGFloat inputW=ScreenWidth-3*buttonWidth-leftMargin*2-centerMargin*5;
    //为了看起来更加紧凑  x往右移动1
    CGFloat inputX=CGRectGetMaxX(self.audioBtn.frame)+centerMargin+1;
    CGFloat inputH=inputViewH;
    CGFloat inputY=(self.height-inputH)*0.5;
    self.BottominputView.frame=CGRectMake(inputX, inputY, inputW, inputH);
    //3.表情符号的frame
    CGFloat faceX=CGRectGetMaxX(self.BottominputView.frame)+centerMargin+1;
    self.faceBtn.frame=CGRectMake(faceX, btnY, buttonWidth, buttonHeight);
    //4。添加图片按钮的frame
    CGFloat addImageX=CGRectGetMaxX(self.faceBtn.frame)+centerMargin-2;
    self.addBtn.frame=CGRectMake(addImageX, btnY, buttonWidth, buttonHeight);
    
    
}


@end
