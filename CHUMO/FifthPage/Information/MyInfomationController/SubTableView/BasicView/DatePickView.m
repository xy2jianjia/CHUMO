//
//  DatePickView.m
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DatePickView.h"


@interface DatePickView ()

@end


@implementation DatePickView

+ (DatePickView *)sharedInstance {
    
    static DatePickView *main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        main = [[DatePickView alloc] init];
        
    });
    return main;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.width+200, [[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        
        [self datePickerView];
        
    }
    return self;
}



#pragma mark --- datePicker
- (void)datePickerView {
    
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 160)];
    //设置本地化
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期格式
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *dateStr=@"1900-01-01 00-00-00";
    NSDate *newdate=[dateFormatter dateFromString:dateStr];
    self.datePicker.minimumDate=newdate;
    [self addSubview:self.datePicker];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    CGFloat screenW = self.bounds.size.width;
    //设置尺寸
    toolbar.frame = CGRectMake(0, 0, screenW, 40);
    //添加按钮
    UIBarButtonItem *prevBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(prevBtnAction)];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"出生日期" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction)];
    //固定弹簧
    UIBarButtonItem *fixedTanhuang = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //一定设置宽度
    fixedTanhuang.width = (screenW - 175)/2;
    //伸缩弹簧
    UIBarButtonItem *flexTanhuang = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[prevBtn,fixedTanhuang,nextBtn,flexTanhuang,doneBtn];
    
    [self addSubview:toolbar];
    
}

- (void)prevBtnAction {  // 取消

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height+25);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)doneBtnAction { // 确认
    
    [self.datePickDelegate datepickerDonBtnHaveClick:self resultString:@"done"];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height+25);
    } completion:^(BOOL finished) {
        
    }];
}
@end
