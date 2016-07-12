//
//  LiveMessageModel.h
//  CHUMO
//
//  Created by xy2 on 16/7/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveMessageModel : NSObject

@property (nonatomic,strong) NSString *targetId;
@property (nonatomic,strong) NSString *targetName;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *messageId;
@property (nonatomic,strong) NSString *timeStamp;

@end
