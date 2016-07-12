//
//  BindView.h
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindView : UIView {

    UIImageView *photoImage;
    UILabel *bindNum;
    
}
@property (nonatomic,strong)UIButton *replacement; // 更换
- (void)addDataWithphotoImage:(NSString *)image bindNum:(NSString *)bind;
@end
