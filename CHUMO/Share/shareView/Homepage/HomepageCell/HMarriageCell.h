//
//  HMarriageCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMarriageCell : UITableViewCell{
    
    UILabel *makeFriend;
    UILabel *upLine;
    
    NSInteger *indeInter;
}
@property (nonatomic,strong)UILabel *contents;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,assign)CGFloat marrheiht;
- (void)addDataWithtitle:(NSString *)title;
+ (CGFloat)HMarriagecellHeight;
@end
