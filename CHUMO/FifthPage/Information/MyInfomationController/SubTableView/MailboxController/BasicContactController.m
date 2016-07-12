//
//  BasicContactController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/2/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "BasicContactController.h"

@interface BasicContactController ()

@end

@implementation BasicContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationItem.title=self.titleItem;
    self.contactTextField.text=self.contactText;
    if ([self.openFlag integerValue]==2) {
        self.openSwitch.selected=NO;
        self.openSwitch.on=NO;
    }else{
        self.openSwitch.selected=YES;
        self.openSwitch.on=YES;
        self.openFlag=@"1";
    }
    [self.openSwitch addTarget:self action:@selector(openSwitchAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.contactTextField.placeholder=[NSString stringWithFormat:@"请输入%@",self.titleItem];
}
- (void)openSwitchAction:(id)sender{
    if ([self.openSwitch isOn]) {
        self.openFlag=@"1";
    }else{
        self.openFlag=@"2";
    }
}
- (void)leftAction{
    self.CBlock(self.contactTextField.text,self.openFlag);
    [self.navigationController popViewControllerAnimated:YES];
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
