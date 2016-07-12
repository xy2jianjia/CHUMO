//
//  DHContactCell.m
//  StrangerChat
//
//  Created by xy2 on 16/1/14.
//  Copyright © 2016年 long. All rights reserved.
//

#import "DHContactCell.h"

@implementation DHContactCell


-(void)layoutSubviews{
    
    CGSize size = [self hightForContent:_userNameLabel.text fontSize:15];
    CGRect temp = _userNameLabel.frame;
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+10, temp.origin.y, size.width+5, temp.size.height);
//    self.vipIcon.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame)+5, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
}
- (CGSize )hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
