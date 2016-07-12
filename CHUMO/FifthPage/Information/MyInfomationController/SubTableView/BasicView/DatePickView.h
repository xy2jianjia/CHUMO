//
//  DatePickView.h
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickView;

@protocol DatePickViewDelegate <NSObject>

- (void)datepickerDonBtnHaveClick:(DatePickView *)select resultString:(NSString *)resultString; 
@end


@interface DatePickView : UIView

+ (DatePickView *)sharedInstance;
@property (nonatomic,assign)id <DatePickViewDelegate> datePickDelegate;
@property (strong, nonatomic)UIDatePicker *datePicker;

@end
