//
//  GifView.h
//  CHUMO
//
//  Created by zxs on 16/3/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GifView;
@protocol gifDelegates <NSObject>

- (void)setImageGif:(GifView *)imageGIf tagInte:(NSInteger)tagInte;

@end
@interface GifView : UIView {

    UIImageView *gifImage;
    UIButton *searchBt;
}
@property (nonatomic, weak) id<gifDelegates>gifdelegates;
@end
