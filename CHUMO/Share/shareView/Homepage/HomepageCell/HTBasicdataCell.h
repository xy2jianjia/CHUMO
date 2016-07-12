//
//  HTBasicdataCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTBasicdataCell : UITableViewCell {

    UILabel *someData;
    
}

@property (nonatomic,strong)UILabel *shortLine;
@property (nonatomic,strong)UILabel *choice;
+ (CGFloat)basicdatacellHeight;

- (void)addDataWithsomeData:(NSString *)data;

@end
