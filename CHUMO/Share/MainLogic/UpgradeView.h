//
//  UpgradeView.h
//  CHUMO
//
//  Created by xy2 on 16/5/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class UpgradeView;
//@protocol UpgradeViewDelegate <NSObject>
//
//
//
//@end
@interface UpgradeView : UIView
+ (UIView *)configUpgradeViewWithType:(NSInteger )tipType inview:(UIView *)inview versionDict:(NSDictionary *)versionDict;

/**
 *  更新版本数据
 */
@property (nonatomic,strong) NSDictionary *upgrade_dict;

@end
