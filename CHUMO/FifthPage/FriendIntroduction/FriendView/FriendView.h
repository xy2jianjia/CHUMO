//
//  FriendView.h
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendView : UIView {

    UILabel *line;
    UILabel *nextLine;
    UILabel *textLabel;

}
@property (nonatomic,strong)UITextView *contentView;
- (void)addWithText:(NSString *)text;
@end
