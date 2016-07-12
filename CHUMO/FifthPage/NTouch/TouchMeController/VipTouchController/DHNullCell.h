//
//  DHNullCell.h
//  StrangerChat
//
//  Created by zxs on 16/1/29.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHNullCell;
@protocol DHNullCellDelegate <NSObject>

- (void)setNullBt:(DHNullCell *)nullBt btTag:(NSInteger)btTag;

@end
@interface DHNullCell : UITableViewCell {
    UIView *_allView;
    UILabel *_textTitle;
    UIButton *_nowButton;
}
@property (weak, nonatomic) IBOutlet UIButton *setButAction;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
- (void)settextTitle:(NSString *)titles;
+ (CGFloat)nullHeight;
@property (nonatomic , assign)id<DHNullCellDelegate>nullDelegate;
@end
