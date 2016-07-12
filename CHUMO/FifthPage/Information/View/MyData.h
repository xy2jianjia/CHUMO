//
//  MyData.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DATAWIDTH [[UIScreen mainScreen] bounds].size.width
#define DATAHEIGTH [[UIScreen mainScreen] bounds].size.height

@interface MyData : UIView {

    UIView *allView;
    UILabel *line;
    UILabel *vertical;
    UILabel *verticaLine;
    UILabel *basicLabel;
    UILabel *detaileLabel;
    UILabel *hobbiesLabel;
}

// Basic 基本 Detailed 详细  Hobbies 爱好
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *dividLine;  // 可移动
@property (nonatomic,strong)UIButton *basic;
@property (nonatomic,strong)UIButton *detaile;
@property (nonatomic,strong)UIButton *hobbies;

- (void)addWithbasicNum:(NSString *)basic detaile:(NSString *)detaile hobbies:(NSString *)hobbies;
- (void)setColorWithNumer:(NSInteger)num;
@end
