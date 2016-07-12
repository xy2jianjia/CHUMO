//
//  WXcell.h
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXcell : UITableViewCell {

    
    
}
@property (nonatomic, strong) UILabel *order;   // 订单
@property (nonatomic, strong) UILabel *contents;

+ (CGFloat)wxCellHeight;
@end
