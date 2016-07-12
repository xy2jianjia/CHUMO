//
//  PickerPhoto.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-15.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLPhotoAssets.h"

@interface ZLPhotoPickerBrowserPhoto : NSObject

@property (assign,nonatomic) BOOL isVideo;
/**
 *  自动适配是不是以下几种数据
 */
@property (nonatomic , strong) id photoObj;
/**
 *  传入对应的UIImageView,记录坐标
 */
@property (strong,nonatomic) UIImageView *toView;
/**
 *  保存相册模型
 */
@property (nonatomic , strong) ZLPhotoAssets *asset;
/**
 *  URL地址
 */
@property (nonatomic , strong) NSURL *photoURL;
/**
 *  原图
 */
@property (nonatomic , strong) UIImage *photoImage;
@property (strong,nonatomic)   UIImage *aspectRatioImage;
/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;
/**
 *  描述
 */
@property (nonatomic , strong) NSString *b17;
/**
 *  记录id
 */
@property (nonatomic , strong) NSString *b34;
/**
 *  图片
 */
@property (nonatomic , strong) NSString *b59;
@property (nonatomic , strong) NSString *b60;
/**
 *  排序
 */
@property (nonatomic , strong) NSString *b73;
/**
 *  昵称审核状态:1:通过  2：待审核
 */
@property (nonatomic , strong) NSString *b75;
/**
 *  分类 1：眼缘大图 2：普通
 */
@property (nonatomic , strong) NSString *b78;
/**
 *  b80:相册所属用户ID
 */
@property (nonatomic , strong) NSString *b80;
/**
 *  点赞用户ID
 */
@property (nonatomic , strong) NSString *b109;
/**
 *  相册ID
 */
@property (nonatomic , strong) NSString *b108;
/**
 *  点赞用户昵称
 */
@property (nonatomic , strong) NSString *b52;
/**
 *  用户照片大
 */
@property (nonatomic , strong) NSString *b58;
//@property (nonatomic , strong) NSString *b60;
/**
 *  传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
 */
+ (instancetype)photoAnyImageObjWith:(id)imageObj;




@end
