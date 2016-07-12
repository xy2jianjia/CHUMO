//
//  DHTool.h
//  UUTong365
//
//  Created by sincsmart on 15/9/22.
//  Copyright (c) 2015年 sincsmart. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface DHTool : NSObject

+ (instancetype)shareTool;

/**
 *  排序数组按时间
 *
 *  @param array 可变数组
 */
+ (void)sortList:(NSMutableArray *)array;
/**
 *  格式化时间
 *
 *  @param str 时间格式
 *
 *  @return 格式化时间yyyy-MM-dd HH:mm:ss
 */
+ (NSDate *)timeFormatter:(NSString *)str;

/**
 *  格式化时间
 *
 *  @param date 当前时间
 *
 *  @return 格式化后的时间字符串yyyyMMddHHmmsssss
 */
- (NSString *)formatDateWithCurrentTime:(NSDate *)date;
/**
 *  压缩图片
 *
 *  @param image     当前图片
 *  @param scaleSize 压缩程度
 *
 *  @return 压缩后的图片
 */
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
/**
 *   保存图片至沙盒
 *
 *  @param currentImage 要保存的图片
 *  @param imageName    图片名字
 */
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
/**
 *  获取图片所在的沙盒路径
 *
 *  @param userId 当前登录的用户id
 *
 *  @return path
 */
- (NSString *)getImagePathWithImageName:(NSString *)imageNameId;
- (NSString *)stringFromDate:(NSDate *)date;

/**
 *  今天昨天
 *
 *  @param date 当前时间
 *
 *  @return
 */
-(NSString *)compareDate:(NSDate *)date;
- (NSDate *)dateWithCurrentTime:(NSString *)date;
/**
 *  设置导航条
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
/**
 *  图片预处理反转
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *  随机数
 *
 *  @param max <#max description#>
 *  @param min <#min description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min;
@end
