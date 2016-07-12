//
//  OpinionView.h
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionView : UIView {

    UILabel *titleLabel;
    UIView *contactView;
    UILabel *contactTitle;

    UILabel *topLine;
    UILabel *centreLine;
    UILabel *bottomLine;
    
}
@property (nonatomic,strong)UIButton *submit;
@property (nonatomic,strong)UITextView *feedback;
@property (nonatomic,strong)UITextField *contactInfo;
- (void)addDataWithtitle:(NSString *)title;
@end
