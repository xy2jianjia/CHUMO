//
//  HMEmotionTool.m
//  黑马微博
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#define HMRecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

#import "HMEmotionTool.h"
#import "HMEmotion.h"
#import "MJExtension.h"

@implementation HMEmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;

/** 最近表情 */
static NSMutableArray *_recentEmotions;

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"defaultInfo.plist" ofType:nil];
        _defaultEmotions = [HMEmotion objectArrayWithFile:plist];
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
//        /Users/xy2/Library/Developer/CoreSimulator/Devices/CBC39082-01E6-4110-B45B-7300300156A2/data/Containers/Bundle/Application/41A46CA3-3DC8-44D7-B06C-FC8E94219750/StrangerChat.app
//        /Users/xy2/Library/Developer/Xcode/DerivedData/StrangerChat-hfkwqwmnhqwmldhblprixzarrdnx/Build/Products/Debug-iphoneos/StrangerChat.app
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:[NSString stringWithFormat:@"%@",bundlePath]];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emojiInfo.plist" ofType:nil];
        _emojiEmotions = [HMEmotion objectArrayWithFile:plist];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"emoji"];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxhInfo.plist" ofType:nil];
        _lxhEmotions = [HMEmotion objectArrayWithFile:plist];
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:[NSString stringWithFormat:@"%@",bundlePath]];
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HMRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}
// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
+ (void)addRecentEmotion:(HMEmotion *)emotion
{
    // 加载最近的表情数据
//    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
//    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:HMRecentFilepath];
}

+ (HMEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc)
        return nil;
    
    __block HMEmotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(HMEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(HMEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}
@end
