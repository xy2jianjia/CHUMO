//
//  HAssetsCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HAssetsCell;
@protocol AssetsCellDelegate <NSObject>

- (void)setCellBt:(HAssetsCell *)cellBt vcBtag:(NSInteger)vcBtag;

@end
@interface HAssetsCell : UITableViewCell {

    UILabel *assets;
    UIImageView *monthImage;
    UILabel *month;
    UIImageView *propertyImage;  // 房产
    UILabel *property;
    UIImageView *carImage;
    UILabel *car;
    
    UILabel *upLine;
    UILabel *downLine;
    UIButton *vipImage;
}

@property (nonatomic,assign)id <AssetsCellDelegate>assetsDelegate;
- (void)addDataWithassets:(NSString *)assetsTitle monthImage:(NSString *)monImage month:(NSString *)mon propertyImage:(NSString *)proImage property:(NSString *)proper carImage:(NSString *)carImag car:(NSString *)cars vipImage:(NSString *)vip;

+ (CGFloat)assetscellHeight;
@end
