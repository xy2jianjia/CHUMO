//
//  TouchmeCell.h
//  StrangerChat
//
//  Created by zxs on 15/12/3.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchmeCell : UITableViewCell{
    
    UIImageView *portrait;
    UILabel *height;
    UILabel *address;
    UILabel *line;
    UILabel *secondLine;
    
}
@property (nonatomic,strong)UILabel *topLine;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *age;
@property (nonatomic,strong)UIImageView *VipImage;
+ (CGFloat)touchmeCellHeight;
- (void)addDataWithheight:(NSString *)aheight address:(NSString *)aAddress;

// 头像
- (void)cellLoadWithurlStr:(NSURL *)url;


@end
