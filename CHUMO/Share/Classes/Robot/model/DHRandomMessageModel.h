//
//  DHRandomMessageModel.h
//  DHRequestServer
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHBaseModel.h"

@interface DHRandomMessageModel : NSObject
/**
 *  记录id
 */
@property (nonatomic,strong) NSString *b34;
/**
 *  消息类型1:打招呼2：联系方式3：常规 4:独白
 */
@property (nonatomic,strong) NSString *b78;
/**
 *  消息内容
 */
@property (nonatomic,strong) NSString *b14;
@end
