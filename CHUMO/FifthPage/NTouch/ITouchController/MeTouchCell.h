//
//  MeTouchCell.h
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
// meTouchCellHeight
@interface MeTouchCell : UITableViewCell {
    
    UIImageView *portrait;
    UILabel *height;
    UILabel *address;
    UILabel *line;
    UILabel *secondLine;
    UILabel *_reportLabel;
    
}
@property (nonatomic,strong)UILabel *topLine;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *age;
@property (nonatomic,strong)UIImageView *VipImage;
+ (CGFloat)meTouchCellHeight;
- (void)addDataWithheight:(NSString *)aheight address:(NSString *)aAddress;
- (void)changeReportCellWithurlStr:(NSURL *)url;
// 头像
- (void)cellLoadWithurlStr:(NSURL *)url;
@end
