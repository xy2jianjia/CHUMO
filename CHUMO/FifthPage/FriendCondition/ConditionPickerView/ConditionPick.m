//
//  ConditionPick.m
//  StrangerChat
//
//  Created by zxs on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ConditionPick.h"
@interface ConditionPick () {
    
    UIToolbar *toolbar;
    NSInteger show;
    
}

@end
@implementation ConditionPick

+ (ConditionPick *)sharedInstance {

    static ConditionPick *main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        main = [[ConditionPick alloc] init];
        
    });
    return main;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        
        [self N_layoutView];
        
    }
    return self;
}

- (void)N_layoutView {
    
    // 选择框
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 160)];
    _pickerView.showsSelectionIndicator = true;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40);
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
    [self.conditionDelegate conditionPickDonBtnHaveClick:self];
}
/**
 *  收回picker
 */
- (void)hide {
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height+125);
    } completion:^(BOOL finished) {
        
    }];
    
}




@end
