//
//  DHDateFormatManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHBaseManager.h"
/**
 *  存入沙盒的附加属性之一：主文件夹名
 */
static NSString * const DATE_FORMAT_STRING_NORMAL   = @"yyyy-MM-dd HH:mm:ss";
static NSString * const DATE_FORMAT_STRING_NORMAL_LOWER_HOUR   = @"yyyy-MM-dd hh:mm:ss";
//static NSString * const DATE_FORMAT_STRING_NORMAL_SSS   = @"yyyy-MM-dd HH:mm:ss:sss";
static NSString * const DATE_FORMAT_STRING_NORMAL_NUMBER_FOR_UUID   = @"yyyyMMddHHmmsssss";
@interface DHDateFormatManager : DHBaseManager

/**
 *  获取format
 *
 *  @param formatString
 *
 *  @return 
 */
+ (NSDateFormatter *)asyncConfigFormatWithFormatString:(NSString *)formatString;
/**
 *  格式化日期成字符串
 *
 *  @param date
 *
 *  @return 
 */
+ (NSString *)asyncStringFromDate:(NSDate *)date;

@end
