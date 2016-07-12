//
//  UIImageView+Tool.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Tool)
/** 解析gif文件数据的方法 block中会将解析的数据传递出来 */
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray,NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths, NSArray<NSNumber *>* heights))dataBlock;

/** 为UIImageView添加一个设置gif图内容的方法： */
-(void)yh_setImage:(NSURL *)imageUrl;
@end
