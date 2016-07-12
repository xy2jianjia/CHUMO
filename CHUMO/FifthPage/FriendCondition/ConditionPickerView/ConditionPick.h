//
//  ConditionPick.h
//  StrangerChat
//
//  Created by zxs on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConditionPick;
@protocol ConditionDelegate <NSObject>

- (void)conditionPickDonBtnHaveClick:(ConditionPick *)select;

@end
@interface ConditionPick : UIView

+ (ConditionPick *)sharedInstance;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIBarButtonItem *nextBtn;
@property (nonatomic,strong)UIBarButtonItem *fixedTanhuang;

@property (nonatomic,assign)id <ConditionDelegate>conditionDelegate;
@end

