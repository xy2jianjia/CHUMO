//
//  PrivilegeTableViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/20.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PrivilegeTableViewCellDelegate <NSObject>
- (void)getPrivilegecode:(NSInteger )code AndTitle:(NSString *)title;
@end
@interface PrivilegeTableViewCell : UITableViewCell
{
    UIView *leftView;
    UIImageView *leftImageV;
    UILabel *leftLabel;
    
    UIView *rightView;
    UIImageView *rightImageV;
    UILabel *rightLabel;
    
    
}
@property (nonatomic,assign)id<PrivilegeTableViewCellDelegate> delegate;
- (void)setPrivilegeInfoByModel:(NSArray *)array;
@end
