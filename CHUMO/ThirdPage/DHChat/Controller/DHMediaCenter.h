//
//  DHMediaCenter.h
//  CHUMO
//
//  Created by xy2 on 16/5/13.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^imagePickupCallback)(NSArray *imageList);

@interface DHMediaCenter : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) id viewController;
/**
 *  接收拍照的照片，只有一张
 */
@property (nonatomic,strong) UIImage *photoImage;
/**
 *  从相册获取的图片数组
 */
@property (nonatomic,strong) NSArray *imageList;
//@property (nonatomic,strong) imagePiackupCallback callBacked;
@end
