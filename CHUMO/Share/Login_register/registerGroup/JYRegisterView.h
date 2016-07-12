//
//  JYRegisterView.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/1.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JYRegisterViewDelegate <NSObject>
- (void)getRegisterType:(NSInteger)type;
@end
@interface JYRegisterView : UIView
@property (nonatomic,strong)UIView *bgAlphaView;
@property (nonatomic,assign)id<JYRegisterViewDelegate> delegate;
@end
