//
//  RefreshView.h
//  CHUMO
//
//  Created by zxs on 16/2/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Width [[UIScreen mainScreen] bounds].size.width
#define Height [[UIScreen mainScreen] bounds].size.height
@class RefreshView;
@protocol RefreshViewDelegate <NSObject>

- (void)setRefre:(RefreshView *)refre inte:(NSInteger)inter;

@end
@interface RefreshView : UIView {

    UIImageView *comImage;
    UIButton *refresh;
}
@property (nonatomic, weak) id<RefreshViewDelegate>refreshDelegate;
@end
