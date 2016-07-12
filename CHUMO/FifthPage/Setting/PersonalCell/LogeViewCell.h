//
//  LogeViewCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogeViewCell : UITableViewCell {

    UILabel *signOut;
    UILabel *upLine;
    UILabel *downLine;
}

- (void)addWithSign:(NSString *)sign;
@end
