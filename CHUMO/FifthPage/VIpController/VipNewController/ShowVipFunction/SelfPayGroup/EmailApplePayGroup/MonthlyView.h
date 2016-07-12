//
//  MonthlyView.h
//  Monthly
//
//  Created by zxs on 16/4/19.
//  Copyright © 2016年 YSKS.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@class MonthlyView;
@protocol MonthlyViewDelegate <NSObject>

- (void)clickMonthlyButton:(MonthlyView *)monthly indexTag:(NSInteger)indextag;
- (void)gotoServiceAction;
@end
@interface MonthlyView : UIView {

    UIImageView *_backgroundImage;
    UIView *_dotView;
    UILabel *_monthlyLabel;
    UILabel *_monthlyContent;
    UIButton *_priceButton;
    UILabel *_mounthLabel;
    UILabel *_priceLabel;
    UILabel *_buyLabel;
    UILabel *_giftLabel;
}
@property (nonatomic, assign) id <MonthlyViewDelegate>monthlydelegate;
@property (nonatomic, strong) NSMutableArray *mounthArray;
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSMutableArray *buyArray;
- (void)setmonthlyArray:(NSArray *)n_monthlyArray priceArray:(NSArray *)n_priceArray buyArray:(NSArray *)n_buyArray giftArray:(NSArray *)n_giftArray;
@end
