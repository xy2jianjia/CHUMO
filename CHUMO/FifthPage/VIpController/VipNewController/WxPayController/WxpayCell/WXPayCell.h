//
//  WXPayCell.h
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPayCell : UITableViewCell {
    UIImageView *_payImage;
    UILabel *_payLabel;
    
}
@property (nonatomic ,strong) UIButton *payDot;
@property (nonatomic,assign)NSInteger payFlag;
- (void)setPayImage:(NSString *)payImage payLabel:(NSString *)payLabel payFlag:(NSInteger)payFlag;
+ (CGFloat)wxPayCellHeight;
@end
