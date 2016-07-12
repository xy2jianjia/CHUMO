//
//  DHMessageToustView.h
//  CHUMO
//
//  Created by xy2 on 16/3/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHMessageToustViewDelegate;
@protocol DHMessageToustViewDelegate <NSObject>

- (void)onClicked;

@end
@interface DHMessageToustView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong) UIImageView *messageIconImageV;
@property (nonatomic,assign) id <DHMessageToustViewDelegate>delegate;
//+ (DHMessageToustView *)shareToustViewWithMessage:(Message *)message;
+ (void) asyncConfigToustViewWithMessage:(DHMessageModel *)message inview:(UIView *)inview delegate:(id<DHMessageToustViewDelegate>)delegate showFrame:(void(^)(CGRect showFrame))showFrame hideFrame:(void(^)(CGRect hideFrame))hideFrame;
@end
