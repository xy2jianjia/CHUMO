//
//  BecomeVipCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BecomeVipCell.h"

@implementation BecomeVipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {


    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self n_data];
    }
    return self;
}

- (void)n_data {

    allView = [[UIView alloc] init];
    allView.backgroundColor = kUIColorFromRGB(0xf04d6d);
    [self.contentView addSubview:allView];
    
    becomeVip = [[UIImageView alloc] init];
    [allView addSubview:becomeVip];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:Typeface size:20.0f];
    [allView addSubview:titleLabel];
    
}

- (void)layoutSubviews {

    allView.frame = CGRectMake(0, 0, self.bounds.size.width, 55);
    becomeVip.frame = CGRectMake(self.bounds.size.width/2-67, 17, 25, 20);
    titleLabel.frame = CGRectMake(CGRectGetMaxX(becomeVip.frame)+5, 12, 100, 30);
    
}


- (void)addWithimage:(NSString *)imageVip title:(NSString *)title{

    becomeVip.image = [UIImage imageNamed:imageVip];
    titleLabel.text = title;
}

+ (CGFloat)becomeVipCellHeight {

    return 55;
}
@end
