//
//  DHTool.m
//  UUTong365
//
//  Created by sincsmart on 15/9/22.
//  Copyright (c) 2015年 sincsmart. All rights reserved.
//

#import "DHTool.h"
@implementation DHTool

+ (instancetype)shareTool{
    static DHTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[DHTool alloc]init];
    });
    return tool;
}
/**
 *  排序数组按时间
 *
 *  @param array 可变数组
 */
//+ (void)sortList:(NSMutableArray *)array{
//    
//    [array sortUsingComparator:^NSComparisonResult(DHReplyModel * obj1, DHReplyModel * obj2){
//        NSDate *d1 = [self timeFormatter:obj1.insertTime];
//        NSDate *d2 = [self timeFormatter:obj2.insertTime];
//        return (d1.timeIntervalSince1970 < d2.timeIntervalSince1970);
//    }];
//    
//}
/**
 *  格式化时间
 *
 *  @param str 时间格式
 *
 *  @return 格式化时间
 */
+ (NSDate *)timeFormatter:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *retDate = [formatter stringFromDate:date];
    return retDate;
}
#pragma mark - image picker delegte

#pragma mark - ZYQAssetPickerController Delegate


/**
 *  获取图片所在的沙盒路径
 *
 *  @param userId 当前登录的用户id
 *
 *  @return path
 */
- (NSString *)getImagePathWithImageName:(NSString *)imageNameId{
//    NSString *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"uploadImages"];
    NSString *fullPath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageNameId]];
    return fullPath;
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    // 获取沙盒目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [[cachePath stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:@"uploadImages"] ;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imagePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [imagePath stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
#pragma mark- 压缩图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**
 *  格式化时间
 *
 *  @param date 当前时间
 *
 *  @return 格式化后的时间字符串
 */
- (NSString *)formatDateWithCurrentTime:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    return [format stringFromDate:date];
}
- (NSDate *)dateWithCurrentTime:(NSString *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    return [format dateFromString:date];
}
/**
 *  今天昨天前天
 *
 *  @param date 当前时间
 *
 *  @return
 */
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *beforeYesterday, *yesterday;
    
    beforeYesterday = [today dateByAddingTimeInterval: -secondsPerDay*2];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]){
        return @"今天";
    }else if ([dateString isEqualToString:yesterdayString]){
        return @"昨天";
    }else if ([dateString isEqualToString:beforeYesterdayString]){
        return @"两天前";
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy年MM月dd日"];
        
        NSString *dateStr = [[fmt stringFromDate:date] substringWithRange:NSMakeRange(5, 6)];
//        [[dateStr substringToIndex:0] integerValue];
//        NSString *month = [[dateStr substringToIndex:1] integerValue] == 0 ? [self returnMonthFormater:[[dateStr substringWithRange:NSMakeRange(1, 2)] integerValue]]:[self returnMonthFormater:[[dateStr substringToIndex:2] integerValue]];
////        NSLog(@"%@",month);
//        NSString *day = [dateStr substringWithRange:NSMakeRange(3, 3)];
//        return [NSString stringWithFormat:@"%@一一一二%@",month,day];
        return dateStr;
    }
}
/**
 *  返回月份
 *
 *  @param month 数字月份
 *
 *  @return 汉字月份
 */
- (NSString *)returnMonthFormater:(NSInteger )month{
    NSArray *months = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    switch (month) {
        case 1:
            return months[0];
            break;
        case 2:
            return months[1];
            break;
        case 3:
            return months[2];
            break;
        case 4:
            return months[3];
            break;
        case 5:
            return months[4];
            break;
        case 6:
            return months[5];
            break;
        case 7:
            return months[6];
            break;
        case 8:
            return months[7];
            break;
        case 9:
            return months[8];
            break;
        case 10:
            return months[9];
            break;
        case 11:
            return months[10];
            break;
        case 12:
            return months[11];
            break;
        default:
            return nil;
            break;
    }
}
+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  随机数
 *
 *  @param max <#max description#>
 *  @param min <#min description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min{
    
    NSInteger index = (arc4random() % (max-min+1))+min;
    return index;
    
}
@end
