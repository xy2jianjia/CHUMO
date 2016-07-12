//
//  DHLoginViewController.h
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHLoginViewController : UIViewController
@property (nonatomic,copy) NSString *phoneNum;// 手机号
@property (nonatomic,copy) NSString *passWord;// 密码
@property (weak, nonatomic) IBOutlet UIButton *oldloginButton;//历史记录
@property (nonatomic,copy) NSString *whoVC;// 判断那个页面过来的
@property (nonatomic,assign)BOOL isthird;
@end
