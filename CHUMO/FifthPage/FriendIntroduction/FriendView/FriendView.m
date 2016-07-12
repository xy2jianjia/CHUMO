//
//  FriendView.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "FriendView.h"

@implementation FriendView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self n_layOut];
    }
    return self;
}


- (void)n_layOut {

    _contentView = [[UITextView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.textAlignment = NSTextAlignmentJustified;
    _contentView.font = [UIFont systemFontOfSize:14];
    [self addSubview:_contentView];
    
//    line = [[UILabel alloc] init];
//    line.backgroundColor = [UIColor grayColor];
//    [_contentView addSubview:line];
    
//    nextLine = [[UILabel alloc] init];
//    nextLine.backgroundColor = [UIColor grayColor];
//    [_contentView addSubview:nextLine];
    
    textLabel = [[UILabel alloc] init];
    textLabel.textColor = kUIColorFromRGB(0x999999);
    textLabel.font = [UIFont fontWithName:Typefaces size:13];
    [self addSubview:textLabel];

}


- (void)layoutSubviews {

    _contentView.frame = CGRectMake(0, 10, self.bounds.size.width, 200);
//    line.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
//    nextLine.frame = CGRectMake(0, 229, self.bounds.size.width, 2);
    textLabel.frame = CGRectMake(10,CGRectGetMaxY(_contentView.frame) , self.bounds.size.width-10, 35);

}


- (void)addWithText:(NSString *)text {

    
    textLabel.text = text;
}

@end
