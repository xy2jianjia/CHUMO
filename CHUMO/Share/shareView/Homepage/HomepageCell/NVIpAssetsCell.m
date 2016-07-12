//
//  NVIpAssetsCell.m
//  StrangerChat
//
//  Created by zxs on 15/12/29.
//  Copyright © 2015年 long. All rights reserved.
//

#import "NVIpAssetsCell.h"

@implementation NVIpAssetsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        someData = [[UILabel alloc] init];
        
        someData.font = [UIFont fontWithName:Typefaces size:12.0f];
//        someData.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:someData];
        
        
        _choice = [[UILabel alloc] init];
        _choice.font = [UIFont fontWithName:Typefaces size:13.0f];
        _choice.textAlignment = NSTextAlignmentRight;
        _choice.textColor = kUIColorFromRGB(0x323232);
//        _choice.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_choice];
        
        
        _shortLine = [[UILabel alloc] init];
        _shortLine.backgroundColor = kUIColorFromRGB(0xebe8ed);
        [self.contentView addSubview:_shortLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    someData.frame = CGRectMake(10, 10, 60, 35);
    _choice.frame = CGRectMake(CGRectGetMaxX(someData.frame)+10, 5, ScreenWidth-CGRectGetMaxX(someData.frame)-20, 25);
}

+ (CGFloat)basicdatacellHeight {
    
    return 35;
}

- (void)addDataWithsomeData:(NSString *)data  {
    
    someData.text = data;

}
- (void)setsomeDataCellMinx:(CGFloat)minx andType:(NSInteger) type{
    someData.frame = CGRectMake(minx, 5, 60, 25);
    switch (type) {
        case 0:
        {
            someData.textColor = kUIColorFromRGB(0xaaaaaa);
            someData.textAlignment=NSTextAlignmentRight;
        }
            break;
        case 1:
        {
            someData.textColor = kUIColorFromRGB(0x323232);
            someData.textAlignment=NSTextAlignmentLeft;
        }
            break;
            
        default:
            break;
    }
    
}

@end
