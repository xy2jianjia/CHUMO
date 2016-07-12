//
//  DHLoginUserForListModel.h
//  CHUMO
//
//  Created by xy2 on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLoginUserForListModel : NSObject
/**
 *  用户id
 */
@property (nonatomic,strong)NSString *userId;
/**
 *  用户名
 */
@property (nonatomic,strong)NSString *userName;
/**
 *  密码
 */
@property (nonatomic,strong)NSString *passWord;
/**
 *  状态id
 */
@property (nonatomic,strong)NSString *sessionId;


@end
