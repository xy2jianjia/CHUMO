//
//  BasicSelector.h
//  StrangerChat
//
//  Created by zxs on 15/12/7.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZHToobarHeight 160
#define ZHToobarHeights 40
#define ZHAllViewHeight 200
#define ZHHeight [[UIScreen mainScreen] bounds].size.height
#define ZHWidth [[UIScreen mainScreen] bounds].size.width


@class BasicSelector;

@protocol BasicSelectorDelegate <NSObject>


- (void)pickerDonBtnHaveClick:(BasicSelector *)select resultString:(NSString *)resultString;

@end

@interface BasicSelector : UIView


+ (BasicSelector *)sharedInstance;
@property (nonatomic,assign)id<BasicSelectorDelegate> NDelegate;

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIBarButtonItem *nextBtn;


@end
