//
//  TouchmeCell.m
//  StrangerChat
//
//  Created by zxs on 15/12/3.
//  Copyright © 2015年 long. All rights reserved.
//

#import "TouchmeCell.h"

@implementation TouchmeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self n_layOuts];
    }
    return self;
}





- (void)n_layOuts {
    
    
    portrait = [[UIImageView alloc] init];
    [self.contentView addSubview:portrait];
    
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont fontWithName:Typefaces size:18.0f];
    self.title.textColor = kUIColorFromRGB(0x000000);
    [self.contentView addSubview:self.title];
    
    self.VipImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_VipImage];
    
    
    self.age = [[UILabel alloc] init];
    self.age.font = [UIFont fontWithName:Typefaces size:14.0f];
    self.age.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:self.age];
    
    line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor blackColor]; //
    [self.contentView addSubview:line];
    
    height = [[UILabel alloc] init];
    height.font = [UIFont fontWithName:Typefaces size:14.0f];
    height.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:height];
    
    secondLine = [[UILabel alloc] init];
    secondLine.backgroundColor = [UIColor blackColor]; //kUIColorFromRGB(0x999999)
    [self.contentView addSubview:secondLine];
    
    address = [[UILabel alloc] init];
    address.font = [UIFont fontWithName:Typefaces size:14.0f];
    address.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:address];
    
    self.topLine = [[UILabel alloc] init];
    self.topLine.backgroundColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_topLine];
    
    self.downLine = [[UILabel alloc] init];
    self.downLine.backgroundColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_downLine];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    portrait.frame = CGRectMake(15, 10, 60, 60);
    portrait.layer.cornerRadius = 5; // 圆角
    portrait.clipsToBounds = YES;  // 剪切
    
    CGFloat width = [self stringWidth:self.title.text];
    self.title.frame    = CGRectMake(CGRectGetMaxX(portrait.frame)+5, 15, width, 30);
    self.VipImage.frame = CGRectMake(CGRectGetMaxX(_title.frame)+5, CGRectGetMinY(_title.frame), 25, 20);
    
    CGFloat agewidth = [self minstringWidth:self.age.text];
    self.age.frame = CGRectMake(CGRectGetMaxX(portrait.frame)+5, CGRectGetMaxY(self.title.frame), agewidth, 20);
    line.frame = CGRectMake(CGRectGetMaxX(self.age.frame)+5, CGRectGetMinY(_age.frame)+2, 1, 16);
    
    
    CGFloat heightwidth = [self minstringWidth:height.text];
    height.frame = CGRectMake(CGRectGetMaxX(line.frame)+5, CGRectGetMinY(_age.frame), heightwidth, 20);
    secondLine.frame = CGRectMake(CGRectGetMaxX(height.frame)+5, CGRectGetMinY(line.frame), 1, 16);
    address.frame = CGRectMake(CGRectGetMaxX(secondLine.frame)+5, CGRectGetMinY(height.frame), 150, 20);
    
}

- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
    return r.size.width;
}

- (CGFloat)minstringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    return r.size.width;
}

+ (CGFloat)touchmeCellHeight {
    
    return 80;
}
- (void)addDataWithheight:(NSString *)aheight address:(NSString *)aAddress{
    
    
    height.text = aheight;
    address.text = aAddress;
}

// 头像
- (void)cellLoadWithurlStr:(NSURL *)url {

    [portrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"btn-love60x60-n"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}



@end
