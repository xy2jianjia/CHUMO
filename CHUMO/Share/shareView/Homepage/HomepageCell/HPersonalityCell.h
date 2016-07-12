//
//  HPersonalityCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPersonalityCell : UITableViewCell {

    UILabel *titleLabel;
    UILabel *upLine;
    UILabel *downLine;
    
}
@property (nonatomic,strong)UILabel *content;
@property (nonatomic,strong)UILabel *sContent;
@property (nonatomic,strong)UILabel *tContent;
- (void)addDataWithtitleLabel:(NSString *)title;

+ (CGFloat)personacellHeight;
@end
