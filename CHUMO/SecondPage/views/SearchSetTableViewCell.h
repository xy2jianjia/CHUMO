//
//  SearchSetTableViewCell.h
//  StrangerChat
//
//  Created by long on 15/11/17.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSetTableViewCell : UITableViewCell <UIPickerViewDataSource,UIPickerViewDelegate>
{
    @public
    UIToolbar *_inputAccessoryView;
    UIPickerView *_inputView;
    
    UILabel *label2;
    
    UIPickerView *  pickView;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    //多行
    NSArray *thirdArr;
    
    NSString *selectedProvince;
}
@property (strong,nonatomic,readwrite) UIToolbar *inputAccessoryView;
@property (strong,nonatomic,readwrite) UIPickerView *inputView;
@property (nonatomic,assign) NSInteger rowNum;// 传过来的行数值,哪行
@property (nonatomic,strong) NSArray *dataArray;

@end
