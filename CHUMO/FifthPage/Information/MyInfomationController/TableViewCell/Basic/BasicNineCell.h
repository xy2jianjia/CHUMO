//
//  BasicNineCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicNineCell : UITableViewCell {

    UILabel *leftLabel;
}

+ (CGFloat)basicNineCellHeight;
- (void)addTxtleft:(NSString *)name;
@property (nonatomic,strong)UILabel *upLine;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,strong)UILabel *rightLabel;
@end
