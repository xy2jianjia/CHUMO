//
//  WXcell.m
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WXcell.h"

@implementation WXcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layAutOutViews];
    }
    return self;
}

- (void)layAutOutViews {
    _order    = [[UILabel alloc] init];
    _contents = [[UILabel alloc] init];
    
    _order.font = [UIFont systemFontOfSize:17.0f];
    _contents.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:_order];
    [self.contentView addSubview:_contents];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width  = [self stringWidth:_order.text];
    CGFloat mowidth  = [self stringWidth:_contents.text];
    _order.frame = CGRectMake(40, 15, width, 35);
    _contents.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-mowidth-40, 15, mowidth, 35);
}

- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    return r.size.width;
}

+ (CGFloat)wxCellHeight {

    return 40;
}


@end
