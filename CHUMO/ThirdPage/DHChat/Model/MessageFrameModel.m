//
//  MessageFrameModel.m
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MessageFrameModel.h"
#import "MessageModel.h"
//头像的宽度
#define headIconW 50
#define contentFont MyFont(14)
//聊天内容的文字距离四边的距离
#define ContentEdgeInsets 20

@implementation MessageFrameModel

- (CGSize )getLayoutFrameWithContent:(NSString *)content fontSize:(CGFloat)fontSize subViewSize:(CGSize )subViewSize{
    CGSize size = [content boundingRectWithSize:subViewSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
// 取沙盒图片，根据时间
- (UIImage *)getImageFromShandBoxWithTimeStamp:(NSString *)timeStamp{
    NSString *time = [[timeStamp stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"chatImages"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *targetId = _messageModel.targetId;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg",userId,targetId,time];// 当前用户_目标用户_图片id
    NSString *fullPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}
//根据模型设置frame
-(void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel=messageModel;
    CGFloat padding =10;  //间距为10
    
    //1.设置时间的frame (不需要隐藏时间)
    if(messageModel.hiddenTime==NO){
        NSString *time = [messageModel.time substringWithRange:NSMakeRange(11, 5)];
        CGSize timeSize = [self getLayoutFrameWithContent:time fontSize:13 subViewSize:CGSizeMake(ScreenWidth-280, 20)];
        CGFloat timeX=CGRectGetMidX([[UIScreen mainScreen] bounds]) - timeSize.width/2.0;
        CGFloat timeY=5;
        CGFloat timeW=timeSize.width+10;
        CGFloat timeH=20;
        _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.设置头像
    CGFloat iconW=headIconW;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=CGRectGetMaxY(_timeF)+padding;
    //如果是自己
    if(messageModel.isCurrentUser){
        iconX=ScreenWidth-iconW-padding;
    }else{  //是正在和自己聊天的用户
         iconX=padding;
    }
    _headF=CGRectMake(iconX, iconY, iconW, iconH);
    //3.设置聊天内容的frame  (聊天内容的宽度最大100  高不限)
    //如果是写信和VIP
    if ([messageModel.messageType isEqualToString:@"5"]||[messageModel.messageType isEqualToString:@"6"]) {
        CGFloat contentW=(((250)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
        CGFloat contentH=(((125)/568.0f) * [[UIScreen mainScreen] bounds].size.height);
        CGFloat contentY=iconY+2;
        CGFloat contentX=0;
        //如果是自己
        if(messageModel.isCurrentUser){
            contentX=iconX-padding-contentW;
        }else{  //如果是聊天用户
            contentX=CGRectGetMaxX(_headF)+padding;
        }
        _contentF=CGRectMake(contentX, contentY, contentW, contentH);
    }else if ([messageModel.messageType integerValue] == 3){
//        UIImage *image = messageModel.chatImage;
//        CGSize imageSize = image.size;
        // 图片
        CGFloat contentH = 0;
        CGFloat contentW = 0;
        CGFloat contentY=iconY+2;
        CGFloat contentX=0;
        
        
//        if (imageSize.width > imageSize.height) {
//            CGFloat times = imageSize.width/imageSize.height;
//            contentW = (((125 * times)/375.0f) * [[UIScreen mainScreen] bounds].size.width) > 187 ?187:(((125 * times)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
//            contentH = (((125)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
//            contentY=iconY+2;
//            contentX = 0;
//        }else if (imageSize.width < imageSize.height){
//            CGFloat times = imageSize.height/imageSize.width;
//            contentW = (((125)/667.0f) * [[UIScreen mainScreen] bounds].size.height);
//            contentH = (((125*times)/667.0f) * [[UIScreen mainScreen] bounds].size.height)>187?187:(((125*times)/667.0f) * [[UIScreen mainScreen] bounds].size.height);
//            contentY=iconY+2;
//            contentX = 0;
//        }else{
            contentW = (((187)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
            contentH = (((187)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
            contentY=iconY+2;
            contentX = 0;
//        }
        //如果是自己
        if(messageModel.isCurrentUser){
            contentX=iconX-padding-contentW;
        }else{  //如果是聊天用户
            contentX=CGRectGetMaxX(_headF)+padding;
        }
        _contentF=CGRectMake(contentX, contentY, contentW, contentH);
        
    }else if ([messageModel.messageType integerValue] == 4){
        
        CGFloat contentW = messageModel.audioDuration*15 + ContentEdgeInsets*2;
        if (contentW >= 187) {
            contentW = (((187)/375.0f) * [[UIScreen mainScreen] bounds].size.width);
        }
        CGFloat contentH = 35 + 10;
        CGFloat contentY=iconY+2;
        CGFloat contentX=0;
        //如果是自己
        if(messageModel.isCurrentUser){
            contentX=iconX-padding-contentW;
        }else{  //如果是聊天用户
            contentX=CGRectGetMaxX(_headF)+padding;
        }
        _contentF=CGRectMake(contentX, contentY, contentW, contentH);
    }else if ([messageModel.messageType integerValue] == 7){
        
    }else{
        CGSize contentSize=CGSizeMake(200, MAXFLOAT);
        CGSize contentR;
        //如果有表情的话
        NSAttributedString *text = nil;
        NSString *string = nil;
        if ([messageModel.messageType integerValue] == 1) {
            text = [[NSAttributedString alloc] initWithAttributedString:messageModel.attributedBody];
            string = [NSString stringWithFormat:@"%@",text];
        }else{
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[messageModel.body dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            text = attrStr;
            string = [text string];
        }
        contentR= [self hightForContent:string fontSize:16 size:contentSize];
        //    [text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        //    }else{
        //        contentR=[messageModel.body boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentFont} context:nil];
        //    }
        CGFloat contentW=contentR.width+ContentEdgeInsets*2;
        CGFloat contentH=contentR.height+10;
        CGFloat contentY=iconY+2;
        CGFloat contentX=0;
        //如果是自己
        if(messageModel.isCurrentUser){
            contentX=iconX-padding-contentW;
        }else{  //如果是聊天用户
            contentX=CGRectGetMaxX(_headF)+padding;
        }
        _contentF=CGRectMake(contentX, contentY, contentW, contentH);
    }
    
    //单元格的高度
    CGFloat maxIconY=CGRectGetMaxY(_headF);
    CGFloat maxContentY=CGRectGetMaxY(_contentF);
    
    _cellHeight=MAX(maxIconY, maxContentY)+padding;
    //4.聊天单元view的frame
    _chatF=CGRectMake(0, 0, ScreenWidth, _cellHeight);
}

- (CGSize)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize size:(CGSize)size{
    CGSize resultSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return resultSize;
}

@end
