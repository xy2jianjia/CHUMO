//
//  DHDateFormatManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHDateFormatManager.h"

@implementation DHDateFormatManager

+ (NSDateFormatter *)asyncConfigFormatWithFormatString:(NSString *)formatString{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:formatString];
    return format;
}

+ (NSString *)asyncStringFromDate:(NSDate *)date{
    NSDateFormatter *format = [self asyncConfigFormatWithFormatString:DATE_FORMAT_STRING_NORMAL];
    return [format stringFromDate:date];
}
+ (NSString *)asyncStringFromTimeStamp:(long long )timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(timeStamp / 1000)];
    NSDateFormatter *format = [self asyncConfigFormatWithFormatString:DATE_FORMAT_STRING_NORMAL];
    return [format stringFromDate:date];
}
+ (NSDate *)asyncDateFromString:(NSString *)dateString{
    NSDateFormatter *format = [self asyncConfigFormatWithFormatString:DATE_FORMAT_STRING_NORMAL];
    return [format dateFromString:dateString];
}
+ (NSDate *)asyncDateFromTimeStamp:(long long)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(timeStamp / 1000)];
    return date;
}

+ (NSString *)asyncCreateUUID{
    NSDateFormatter *format = [self asyncConfigFormatWithFormatString:DATE_FORMAT_STRING_NORMAL_NUMBER_FOR_UUID];
    return [format stringFromDate:[NSDate date]];
}
// 某天是否是今天
+(BOOL)isTodayWithSomeDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}
+(BOOL)isYesterdayWithSomeDate:(NSDate *)date
{
    
    NSDate *nowDate = [self dateWithYMDWithDate:[NSDate date]];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMDWithDate:date];
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
    
}

+(BOOL)isThisYearWithSomeDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return nowCmps.year == selfCmps.year;
}

+(NSDateComponents *)deltaWithNowWithSomeDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
}
//返回日期yyyy-MM-dd的格式的日期
+ (NSDate *)dateWithYMDWithDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}
@end
