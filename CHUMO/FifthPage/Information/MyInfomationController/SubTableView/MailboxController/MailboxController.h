//
//  MailboxController.h
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock) (NSString *s);

@interface MailboxController : UIViewController
@property (nonatomic,strong)NSString *email;
@property (nonatomic,copy)MyBlock mb;
@end
