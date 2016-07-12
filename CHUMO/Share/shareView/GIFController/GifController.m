//
//  GifController.m
//  CHUMO
//
//  Created by zxs on 16/3/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "GifController.h"
#import "GifView.h"
#import "SearchSetViewController.h"
@interface GifController ()<gifDelegates>
@property (nonatomic, strong) GifView *gif;
@end

@implementation GifController
- (void)loadView {
    self.gif = [[GifView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.gif.gifdelegates = self;
    self.gif.backgroundColor=[UIColor whiteColor];
    self.view = self.gif;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}
- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setImageGif:(GifView *)imageGIf tagInte:(NSInteger)tagInte {
    if (tagInte == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


@end
