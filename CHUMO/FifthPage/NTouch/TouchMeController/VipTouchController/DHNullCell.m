//
//  DHNullCell.m
//  StrangerChat
//
//  Created by zxs on 16/1/29.
//  Copyright © 2016年 long. All rights reserved.
//

#import "DHNullCell.h"

@implementation DHNullCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutNull];
    }
    return self;
}

- (void)layoutNull {
    
    _allView   = [[UIView alloc] init];
    _textTitle = [[UILabel alloc] init];
    _nowButton = [[UIButton alloc] init];
    _nowButton.tag = 101;
    
    _allView.backgroundColor   = kUIColorFromRGB(0xF8F8FF);
    [_textTitle setFont:[UIFont systemFontOfSize:16.0f]];
    _textTitle.textAlignment = NSTextAlignmentCenter;
    [_nowButton.layer setBorderWidth:1.0f];
    [_nowButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [_nowButton setTitle:@"现在去" forState:(UIControlStateNormal)];
    [_nowButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_nowButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_nowButton addTarget:self action:@selector(nowAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.contentView addSubview:_allView];
    [_allView addSubview:_textTitle];
    [_allView addSubview:_nowButton];
    
}
- (IBAction)clickAction:(id)sender {
    if ([self.nullDelegate respondsToSelector:@selector(setNullBt:btTag:)]) {
        [self.nullDelegate setNullBt:self btTag:101];
    }
    
}
- (void)nowAction:(UIButton *)sender {
    [self.nullDelegate setNullBt:self btTag:sender.tag];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _allView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    _textTitle.frame = CGRectMake(0, self.center.y - 120, [[UIScreen mainScreen] bounds].size.width, 30);
    _nowButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-120)/2, CGRectGetMaxY(_textTitle.frame)+40, 120, 30);
}
- (void)settextTitle:(NSString *)titles {
    _textTitle.text = titles;
}

+ (CGFloat)nullHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}
@end
