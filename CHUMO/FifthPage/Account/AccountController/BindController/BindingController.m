//
//  BindingController.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BindingController.h"

#import "AccountController.h"
#import "BindView.h"
#import "NResetController.h"
@interface BindingController ()
@property (nonatomic,strong)BindView *bv;
@end

@implementation BindingController


- (void)loadView {
    
    self.bv = [[BindView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.bv;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    [self.bv addDataWithphotoImage:@"icon-phone" bindNum:[NSString stringWithFormat:@"绑定的手机号 :%@",userName ]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self buttonRequest];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonRequest {
//    NSString *bindPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPhone"];
    
    [self.bv.replacement setTitle:@"更换手机号码" forState:(UIControlStateNormal)];
    [self.bv.replacement addTarget:self action:@selector(replacementAction:) forControlEvents:(UIControlEventTouchUpInside)];

}
- (void)replacementAction:(UIButton *)sender {

//    ReplaceNumController *replace = [[ReplaceNumController alloc] init];
//    replace.title = @"更换手机号";
//    [self.navigationController pushViewController:replace animated:YES];
    NResetController *reset = [[NResetController alloc] init];
    reset.msgType = @"3";
    reset.title = @"绑定手机号";
    [self.navigationController pushViewController:reset animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
