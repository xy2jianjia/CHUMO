//
//  DetaiPicker.h
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZHToobarHeight 160
#define ZHToobarHeights 40
#define ZHAllViewHeight 200
#define ZHHeight [[UIScreen mainScreen] bounds].size.height
#define ZHWidth [[UIScreen mainScreen] bounds].size.width

@class DetaiPicker;

@protocol DetaiSelectorDelegate <NSObject>


- (void)pickerDonBtnHaveClick:(DetaiPicker *)select resultString:(NSString *)resultString;

@end


@interface DetaiPicker : UIView


+ (DetaiPicker *)sharedInstance;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIBarButtonItem *nextBtn;
@property (nonatomic,strong)UIBarButtonItem *fixedTanhuang;
@property (nonatomic,assign)id<DetaiSelectorDelegate>detaisDatagate;







@end
