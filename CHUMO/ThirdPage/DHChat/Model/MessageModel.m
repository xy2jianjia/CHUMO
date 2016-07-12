//
//  MessageModel.m
//  微信
//
//  Created by Think_lion on 15/6/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MessageModel.h"
//#import "RegexKitLite.h"
#import "HMRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"
#import "NSDate+CH.h"
@implementation MessageModel


-(void)setBody:(NSString *)body
{
    _body=[body copy];
    
    [self createAttributedText];

}

- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        HMRegexResult *rr = [[HMRegexResult alloc] init];
//        rr.string = *capturedStrings;
//        rr.range = *capturedRanges;
//        rr.emotion = YES;
//        [regexResults addObject:rr];
//    }];
    
    // 匹配非表情
//    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        HMRegexResult *rr = [[HMRegexResult alloc] init];
//        rr.string = *capturedStrings;
//        rr.range = *capturedRanges;
//        rr.emotion = NO;
//        [regexResults addObject:rr];
//    }];
    
    // 排序
//    [regexResults sortUsingComparator:^NSComparisonResult(HMRegexResult *rr1, HMRegexResult *rr2) {
//        int loc1 = rr1.range.location;
//        int loc2 = rr2.range.location;
//        return [@(loc1) compare:@(loc2)];
//    }];
    return regexResults;
}


- (void)createAttributedText
{
    if (self.body == nil) return;
    
 
    self.attributedBody = [self attributedStringWithText:self.body];
    
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(HMRegexResult *result, NSUInteger idx, BOOL *stop) {
        HMEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [HMEmotionTool emotionWithDesc:result.string];
        }
        
        if (emotion) { // 如果有表情
            // 创建附件对象
            HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
            
            // 传递表情
            attach.emotion = emotion;
            attach.bounds = CGRectMake(0, -3, MyFont(16).lineHeight, MyFont(16).lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
 
            
              
            [attributedString appendAttributedString:substr];
        }
    }];
    
    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:MyFont(16) range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}


//-(NSString *)time
//{
//    
//    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
//    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";
//    fmt.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//    NSDate *creatDate=[fmt dateFromString:_time];
//    //判断是否为今年
//    if (creatDate.isThisYear) {//今年
//        if (creatDate.isToday) {
//            //获得微博发布的时间与当前时间的差距
//            NSDateComponents *cmps=[creatDate deltaWithNow];
//            if (cmps.hour>=1) {//至少是一个小时之前发布的
//                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
//            }else if(cmps.minute>=1){//1~59分钟之前发布的
//                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
//            }else{//1分钟内发布的
//                return @"刚刚";
//            }
//        }else if(creatDate.isYesterday){//昨天发的
//            fmt.dateFormat=@"昨天 HH:mm";
//            return [fmt stringFromDate:creatDate];
//        }else{//至少是前天发布的
//            fmt.dateFormat=@"yyyy-MM-dd HH:mm";
//            return [fmt stringFromDate:creatDate];
//        }
//    }else           //  往年
//    {
//        fmt.dateFormat=@"yyyy-MM-dd";
//        return [fmt stringFromDate:creatDate];
//    }
//    return nil;
//}


@end
