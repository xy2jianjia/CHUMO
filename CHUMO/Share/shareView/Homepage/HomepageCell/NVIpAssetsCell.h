//
//  NVIpAssetsCell.h
//  StrangerChat
//
//  Created by zxs on 15/12/29.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVIpAssetsCell : UITableViewCell {
    
    UILabel *someData;
    
}

@property (nonatomic,strong)UILabel *shortLine;
@property (nonatomic,strong)UILabel *choice;
+ (CGFloat)basicdatacellHeight;

- (void)addDataWithsomeData:(NSString *)data;
- (void)setsomeDataCellMinx:(CGFloat)minx andType:(NSInteger) type;
@end
