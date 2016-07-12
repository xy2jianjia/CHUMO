//
//  DHMediaCenter.m
//  CHUMO
//
//  Created by xy2 on 16/5/13.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHMediaCenter.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
@implementation DHMediaCenter



#pragma mark - 拍照
- (void)openCamera{
    NSUInteger sourceType = 0;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    // 拍照
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.sourceType = sourceType;
    [_viewController presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    picker.allowsEditing = NO;
    self.photoImage = image;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [_viewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 本地相册
- (void)openLocalPhotoCallBacked:(void(^)(NSArray *imageArr))callBacked{
    NSMutableArray *imageArr = [NSMutableArray array];
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    pickerVc.maxCount = 9;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:_viewController];
    
//    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        for (int i = 0;i <assets.count; i ++) {
            if ([assets[i] isKindOfClass:[UIImage class]]) {
            }else{
                UIImage *originImage= [assets[i] originImage];
            }
            [imageArr addObject:assets[i]];
        }
        callBacked(imageArr);
    };
}
@end
