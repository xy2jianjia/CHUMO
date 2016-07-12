//
//  ViewController+Recommend.h
//  CHUMO
//
//  Created by xy2 on 16/3/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Recommend)<DHCityRecommendDelegate>
- (void)asyncLoadRecommendIsEmpty:(BOOL)isEmpty;
@end
