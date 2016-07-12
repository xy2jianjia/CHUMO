//
//  NPhotoController.h
//  StrangerChat
//
//  Created by zxs on 15/11/26.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "DHUserAlbumModel.h"

@interface NPhotoController : UIViewController
@property (nonatomic,strong) NSMutableArray *albumArr;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,assign) BOOL isblur;
@end
