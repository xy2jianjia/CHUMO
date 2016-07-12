//
//  DetaiPicker.m
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DetaiPicker.h"

@interface DetaiPicker () {
    
    UIToolbar *toolbar;
    NSInteger show;
    
}

@end


@implementation DetaiPicker

+ (DetaiPicker *)sharedInstance {
    
    static DetaiPicker *main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        main = [[DetaiPicker alloc] init];
        
    });
    return main;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0,ZHHeight - ZHAllViewHeight+100, ZHWidth, ZHAllViewHeight)];
    if (self) {
        
        [self N_layoutView];
        
    }
    return self;
}

- (void)N_layoutView {
    
    // 选择框
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ZHAllViewHeight-ZHToobarHeight, [[UIScreen mainScreen] bounds].size.width, ZHToobarHeight)];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ZHToobarHeights);
    UIBarButtonItem *prevBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(prevBtnAction)];
    _nextBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnBtnAction)];
    
    _fixedTanhuang = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //一定设置宽度
    _fixedTanhuang.width = ([[UIScreen mainScreen] bounds].size.width - 120)/2;
    //伸缩弹簧
    _fixedTanhuang = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[prevBtn,_fixedTanhuang,_nextBtn,_fixedTanhuang,doneBtn];
    [self addSubview:toolbar];
    
    
}

#pragma mark --- toolbarButton
- (void)prevBtnAction {
    
    [self hide];
}

- (void)doneBtnBtnAction {
    
    [self hide];
    [self.detaisDatagate pickerDonBtnHaveClick:self resultString:@"deno"];
}
/**
 *  收回picker
 */
- (void)hide {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(0, ZHHeight+25);
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
