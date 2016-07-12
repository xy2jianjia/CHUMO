//
//  ChatViewShow.h
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrameModel;

@protocol ChatPayButtonProtocol <NSObject>

- (void) PayButtonToPayPageByTag:(NSInteger)buttTag;
- (void) didTouchContentButtonWithBtn:(UIButton *)btn;
- (void) didTouchContentButtonOpenImageWithBtn:(UIButton *)btn;
@end
@interface ChatViewShow : UIView
@property (nonatomic,weak) id<ChatPayButtonProtocol> delegate;
@property (nonatomic,strong) MessageFrameModel *frameModel;
//时间
@property (nonatomic,weak) UILabel *timeLabel;
//正文内容
@property (nonatomic,weak) UIButton *contentBtn;
//@property (nonatomic,strong) UILabel *contentLabel;
//头像
@property (nonatomic,strong) UIImageView *headImage;
/**
 *  辅助按钮，可以显示音频时间，可以点击重发消息
 */
@property (nonatomic,strong) UIButton *accessoryBtn;

@end
