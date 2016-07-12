
//
//  AgreemCell.m
//  StrangerChat
//
//  Created by zxs on 16/1/8.
//  Copyright © 2016年 long. All rights reserved.
//

#import "AgreemCell.h"

@implementation AgreemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setview];
    }
    return self;
}


- (void)setview {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.frame = CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.lineBreakMode =NSLineBreakByCharWrapping; // 保留边界
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
 
}





@end
