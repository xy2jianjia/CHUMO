//
//  DHWelfareView.h
//  CHUMO
//
//  Created by xy2 on 16/6/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHWelfareView;
@protocol DHWelfareViewDelegate <NSObject>

- (void)selfareOnclickedGoBuyCalledBack;
- (void)selfareOnclickedConformButtonCalledBackWithInfo:(NSString *)conformInfo type:(NSInteger )type;
@end


@interface DHWelfareView : UIView

+ (void)configViewsWithPermission:(BOOL)permission inView:(UIView *)inView delegate:(id <DHWelfareViewDelegate >)delegate;
@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,strong) UIView *selectedView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *subContentLabel;
@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) UIButton *doneBtn;
@property (nonatomic,strong) UITextField *textV ;

@property (weak,nonatomic) id <DHWelfareViewDelegate>delegate;

@end
