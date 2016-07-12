//
//  DHShareCodeIPhone4ViewController.h
//  CHUMO
//
//  Created by xy2 on 16/6/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHShareCodeIPhone4ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hasOwnedLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (nonatomic,strong) NSDictionary *infoDict;

@end
