//
//  ChatViewShow.m
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatViewShow.h"
#import "MessageFrameModel.h"
#import "MessageModel.h"

@interface ChatViewShow ()

//
@end

@implementation ChatViewShow

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //1.添加子控件
        [self setupChildView];
        
       
    }
    return self;
}
#pragma mark 添加子控件
-(void)setupChildView
{
   //1.时间
    UILabel *timeLabel=[[UILabel alloc]init];
//    timeLabel.textColor=[UIColor colorWithWhite:0.800 alpha:1];
    timeLabel.font=MyFont(13);
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.textColor=[UIColor colorWithWhite:1 alpha:1];
    timeLabel.backgroundColor = [UIColor colorWithWhite:0.890 alpha:1];
    timeLabel.layer.cornerRadius = 8;
    timeLabel.layer.masksToBounds = YES;
    
    [self addSubview:timeLabel];
    self.timeLabel=timeLabel;
    //2.正文内容
    UIButton *contentBtn=[[UIButton alloc]init];
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.font=MyFont(16);
    contentBtn.titleLabel.numberOfLines=0;  //多行显示
    contentBtn.contentEdgeInsets=UIEdgeInsetsMake(20, 20, 30, 20);
//    [contentBtn addTarget:self action:@selector(didTouchAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    _contentLabel = [[UILabel alloc]init];
//    _contentLabel.textColor = [UIColor blackColor];
//    _contentLabel.font=MyFont(15);
//    _contentLabel.numberOfLines=0;  //多行显示
    
    [self addSubview:contentBtn];
    self.contentBtn=contentBtn;
    //3.头像
    self.headImage=[[UIImageView alloc]init];
    [self addSubview:self.headImage];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    self.headImage.clipsToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UIButton *accessoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:accessoryBtn];
    [accessoryBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    accessoryBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    self.accessoryBtn = accessoryBtn;
}
// 取沙盒图片，根据时间
- (UIImage *)getImageFromShandBoxWithTimeStamp:(NSString *)timeStamp {
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"chatImages"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *targetId = _frameModel.messageModel.targetId;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg",userId,targetId,time];// 当前用户_目标用户_图片id
    NSString *fullPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}
//传递模型
-(void)setFrameModel:(MessageFrameModel *)frameModel
{
    _frameModel=frameModel;
    //设置自己的frame
    self.frame=frameModel.chatF;
  
    //1.时间的frame
    self.timeLabel.frame=frameModel.timeF;
    self.timeLabel.text=[frameModel.messageModel.time substringWithRange:NSMakeRange(11, 5)];
    //2头像的frame
    if(frameModel.messageModel.isCurrentUser){  //如果是自己
//        UIImage *head=frameModel.messageModel.headImage?[UIImage imageWithData:.headImage]:[UIImage imageNamed:@"list_item_icon.png"];
        NSString *url = frameModel.messageModel.headerUrl;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    }else{  //如果是聊天的用户
        NSString *url = frameModel.messageModel.targetHeaderUrl;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
//       self.headImage.image=frameModel.messageModel.otherPhoto?frameModel.messageModel.otherPhoto:[UIImage imageNamed:@"list_item_icon.png"];
    }
   
    self.headImage.frame=frameModel.headF;
    //3.内容的frame
    if ([frameModel.messageModel.messageType integerValue] == 5 ) {
        self.contentBtn.tag = 5000;
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"pay-VipHelper"] forState:UIControlStateNormal];
//        self.contentBtn.tag=5;
        self.contentBtn.frame=frameModel.contentF;
    }else if([frameModel.messageModel.messageType integerValue] == 6){
         self.contentBtn.tag = 6000;
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"pay-EmailHelper"] forState:UIControlStateNormal];
//        self.contentBtn.tag=6;
        self.contentBtn.frame=frameModel.contentF;
    }else if([frameModel.messageModel.messageType integerValue] == 3){
         self.contentBtn.tag = 3000;
        self.contentBtn.frame=frameModel.contentF;
        if(frameModel.messageModel.isCurrentUser){  //如果是自己

            NSString *chatImageUrl = frameModel.messageModel.chatImageUrl;
            
//            UIImage *image=[DHTool fixOrientation:image1];
            
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.frame = CGRectMake(CGRectGetMinX(self.contentBtn.bounds)+15, 10, self.contentBtn.bounds.size.width-30, self.contentBtn.bounds.size.height-30);
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.layer.masksToBounds = YES;
            imageV.layer.cornerRadius = 5;
            if (frameModel.messageModel.localChatImage) {
                imageV.image = frameModel.messageModel.localChatImage;
            }else{
                [imageV sd_setImageWithURL:[NSURL URLWithString:chatImageUrl] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            }
            
            [self.contentBtn addSubview:imageV];
//            [self.contentBtn setImage:image forState:(UIControlStateNormal)];
            // 图片
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
            
        }else {  //别人的

            NSString *chatImageUrl = frameModel.messageModel.chatImageUrl;
//            UIImage *image1 = frameModel.messageModel.chatImage;
//            UIImage *image=[DHTool fixOrientation:image1];
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.frame = CGRectMake(CGRectGetMinX(self.contentBtn.bounds)+15, 10, self.contentBtn.bounds.size.width-30, self.contentBtn.bounds.size.height-30);
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.layer.masksToBounds = YES;
            imageV.layer.cornerRadius = 5;
            if (frameModel.messageModel.localChatImage) {
                imageV.image = frameModel.messageModel.localChatImage;
            }else{
                [imageV sd_setImageWithURL:[NSURL URLWithString:chatImageUrl] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            }
//            [imageV sd_setImageWithURL:[NSURL URLWithString:chatImageUrl] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
            [self.contentBtn addSubview:imageV];
            // 图片
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
        }
        
//        self.contentBtn.tag=3;
        
//        UIImage *image = [self getImageFromShandBoxWithTimeStamp:frameModel.messageModel.time];
        
    }else if([frameModel.messageModel.messageType integerValue] == 4){
         self.contentBtn.tag = 4000;
        // 语音
        self.contentBtn.frame=frameModel.contentF;
        //4.设置聊天的背景图片
        CGRect temp = frameModel.contentF;
        if(frameModel.messageModel.isCurrentUser){  //如果是自己
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
            self.accessoryBtn.frame = CGRectMake(temp.origin.x - 30, temp.origin.y, 30, 30);
            
            UIImage *image = [UIImage imageNamed:@"w_liaotian_yy"];
            UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
            imageV.frame = CGRectMake(CGRectGetMaxX(self.contentBtn.bounds)-30, CGRectGetMidY(self.contentBtn.bounds)-13, 18, 18);
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.layer.masksToBounds = YES;
            [self.contentBtn addSubview:imageV];
            
        }else {  //别人的
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
            self.accessoryBtn.frame = CGRectMake(CGRectGetMaxX(temp) , temp.origin.y, 30, 30);
            UIImage *image = [UIImage imageNamed:@"w_liaotian_yyr"];
            UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
            imageV.frame = CGRectMake(CGRectGetMinX(self.contentBtn.bounds)+10, CGRectGetMidY(self.contentBtn.bounds)-13, 18, 18);
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.layer.masksToBounds = YES;
            //        imageV.layer.cornerRadius = 5;
            [self.contentBtn addSubview:imageV];
        }
        NSInteger audioDuration = (NSInteger)frameModel.messageModel.audioDuration;
        if (audioDuration < 1) {
            audioDuration = 1;
        }
        [self.accessoryBtn setTitle:[NSString stringWithFormat:@"%ld''",audioDuration] forState:(UIControlStateNormal)];
        
    }else if([frameModel.messageModel.messageType integerValue] == 7){
         self.contentBtn.tag = 7000;
        // 视频
        self.contentBtn.frame=frameModel.contentF;
    }else{
         self.contentBtn.tag = 1000;
        self.contentBtn.frame=frameModel.contentF;
        if ([frameModel.messageModel.messageType integerValue] == 1) {
            [self.contentBtn setAttributedTitle:frameModel.messageModel.attributedBody forState:UIControlStateNormal];
        }else{
            NSString *htmlString = frameModel.messageModel.body;
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [self.contentBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        }
        //4.设置聊天的背景图片
        if(frameModel.messageModel.isCurrentUser){  //如果是自己
            //        self.contentLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SenderTextNodeBkg"]];
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
        }else {  //别人的
            //        self.contentLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ReceiverAppNodeBkg"]];
            [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
        }
        self.contentBtn.frame=frameModel.contentF;
    }
    [self.contentBtn addTarget:self action:@selector(ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    self.contentLabel.attributedText = frameModel.messageModel.attributedBody;
//    self.contentLabel.frame = frameModel.contentF;
//    [self.contentLabel sizeToFit];
    
    
    
}
- (void)ButtonAction:(UIButton *)sender{
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1000:
            
            break;
        case 3000:
            if (nil!=_delegate &&[self.delegate respondsToSelector:@selector(didTouchContentButtonOpenImageWithBtn:)]){
                [self.delegate didTouchContentButtonOpenImageWithBtn:sender];
            }
            break;
        case 4000:
            if (nil!=_delegate &&[self.delegate respondsToSelector:@selector(didTouchContentButtonWithBtn:)]){
                [self.delegate didTouchContentButtonWithBtn:sender];
            }
            break;
        case 5000:
            if (nil!=_delegate &&[self.delegate respondsToSelector:@selector(PayButtonToPayPageByTag:)]) {
                [self.delegate PayButtonToPayPageByTag:sender.tag];
            }
            break;
        case 6000:
            if (nil!=_delegate &&[self.delegate respondsToSelector:@selector(PayButtonToPayPageByTag:)]) {
                [self.delegate PayButtonToPayPageByTag:sender.tag];
            }
            break;
        case 7000:
            
            break;
            
        default:
            break;
    }
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];

    
}
- (CGSize )getLayoutFrameWithContent:(NSString *)content fontSize:(CGFloat)fontSize subViewSize:(CGSize )subViewSize{
    CGSize size = [content boundingRectWithSize:subViewSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
@end
