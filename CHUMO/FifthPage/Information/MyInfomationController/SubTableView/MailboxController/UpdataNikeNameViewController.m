//
//  UpdataNikeNameViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "UpdataNikeNameViewController.h"

@interface UpdataNikeNameViewController ()

@end

@implementation UpdataNikeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"修改昵称";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveNickNameAction:)];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem=rightItem;
    self.updateNameText.text=self.currentName;
}
- (void)saveNickNameAction:(id)sender{
    
    //由中文英文数字组成,纯数字和特殊字符不允许
    NSString *regex = @"(?!\\d+)[a-zA-Z0-9\\u4e00-\\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    NSString *str = self.updateNameText.text;
    BOOL isValid = [predicate evaluateWithObject:str];
    
    
    if (!isValid||nil==str|| NULL==str || [str isKindOfClass:[NSNull class]] ||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        if (!isValid) {
            if (MyJudgeNull(str)) {
                UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称不允许为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertV show];
            }else{
                UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称不允许纯数字和特殊字符组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertV show];
            }
            
        }else{
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的昵称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertV show];
        }
        
    }else{
        
        //计算字符串的字符长度
        NSUInteger asciiLength = 0;
        for (NSUInteger i = 0; i < str.length; i++) {
            unichar uc = [str characterAtIndex: i];
            asciiLength += isascii(uc) ? 1 : 2;
        }
        if (asciiLength<=16&& asciiLength>=4) {
            self.UB(self.updateNameText.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称长度为4~16个字符之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertV show];
        }
        
    }
    
    
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
