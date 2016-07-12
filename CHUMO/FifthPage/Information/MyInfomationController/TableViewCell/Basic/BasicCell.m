//
//  BasicCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BasicCell.h"

@implementation BasicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:textLabel];
    
    portrait = [[UIImageView alloc] init];
    portrait.image = [UIImage imageNamed:@"list_item_icon.png"];
//    portrait.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:portrait];
    
    arrow = [[UIImageView alloc] init];
    [self.contentView addSubview:arrow];
    
    oneLine = [[UILabel alloc] init];
    oneLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:oneLine];
    
    twoLine = [[UILabel alloc] init];
    twoLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:twoLine];
}

- (void)layoutSubviews {

    textLabel.frame = CGRectMake(25, 25, 50, 40);
    portrait.frame  = CGRectMake([[UIScreen mainScreen] bounds].size.width - 65 - 50, 12.5, 65, 65);
    portrait.layer.cornerRadius = portrait.frame.size.width / 2; // 圆角
    portrait.layer.borderColor = [UIColor blackColor].CGColor;//边框颜色,要为CGColor
    portrait.clipsToBounds = true;  // 去掉边框颜色
    portrait.layer.shadowRadius = 10.0;
    arrow.frame     = CGRectMake([[UIScreen mainScreen] bounds].size.width-40, 35, 10, 20);
    oneLine.frame   = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5);
    twoLine.frame   = CGRectMake(0, 89, [[UIScreen mainScreen] bounds].size.width, 0.5);
}

+ (CGFloat)basicCellHeight {

    return 90;
}

- (void)addWithText:(NSString *)text portrait:(NSURL *)aportrait arrow:(NSString *)arrowImage{

    textLabel.text = text;
    arrow.image = [UIImage imageNamed:arrowImage];
    portrait.contentMode = UIViewContentModeScaleAspectFill;
    portrait.clipsToBounds = YES;
    if (aportrait && ![[NSString stringWithFormat:@"%@",aportrait] isEqualToString:@"(null)"]) {
        [portrait sd_setImageWithURL:aportrait placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }else{
//        NSString *path = [[DHTool shareTool] getImagePathWithImageName:@"headerImage.jpg"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        if (image) {
//            portrait.image = image;
//        }else{
            portrait.image = [UIImage imageNamed:@"list_item_icon.png"];
//        }
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
