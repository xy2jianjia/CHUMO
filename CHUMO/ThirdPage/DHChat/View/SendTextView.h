//
//  SendTextView.h
//  微信
//
//  Created by Think_lion on 15/7/6.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMEmotion;

@interface SendTextView : UITextView
/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(HMEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)realText;



@end
