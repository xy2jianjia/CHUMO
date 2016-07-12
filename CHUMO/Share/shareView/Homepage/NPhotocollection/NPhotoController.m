//
//  NPhotoController.m
//  StrangerChat
//
//  Created by zxs on 15/11/26.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPhotoController.h"
#import "NPhotoCell.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"
#import "DHUserAlbumModel.h"
@interface NPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;

@end
static NSString *kcellIdentifier = @"collectionCellID";
@implementation NPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupDataSource];
    [self setupUI];
}
/**
 *  处理数据
 */
- (void)setupDataSource{
    
//    for (DHUserAlbumModel *item in _albumArr) {
//        
//    }
    
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

#pragma mark setup UI
- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(([[UIScreen mainScreen] bounds].size.width-30)/4, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 80) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = true;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[NPhotoCell class] forCellWithReuseIdentifier:kcellIdentifier];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return [self.assets count];
    return self.albumArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    DHUserAlbumModel *item = self.albumArr[indexPath.item];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isblur) {
            [cell.simage sd_setImageWithURL:[NSURL URLWithString:[item.b59 length] == 0?item.b58:item.b59] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                image =[self gaussBlur:0.2 andImage:image];
                cell.simage.image=image;
                
            }];
        }else{
            [cell.simage sd_setImageWithURL:[NSURL URLWithString:[item.b59 length] == 0?item.b58:item.b59] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
        }
        
        
    });
    
    return cell;
    
}

- ( UIImage *)gaussBlur:( CGFloat )blurLevel andImage:( UIImage *)originImage

{
    
    blurLevel = MIN ( 1.0 , MAX ( 0.0 , blurLevel));
    
    //int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    
    int boxSize = 50 ; // 模糊度。
    
    boxSize = boxSize - (boxSize % 2 ) + 1 ;
    
    NSData *imageData = UIImageJPEGRepresentation (originImage, 1 );
    
    UIImage *tmpImage = [ UIImage imageWithData :imageData];
    
    CGImageRef img = tmpImage. CGImage ;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider (img);
    
    CFDataRef inBitmapData = CGDataProviderCopyData (inProvider);
    
    inBuffer. width = CGImageGetWidth (img);
    
    inBuffer. height = CGImageGetHeight (img);
    
    inBuffer. rowBytes = CGImageGetBytesPerRow (img);
    
    inBuffer. data = ( void *) CFDataGetBytePtr (inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc ( CGImageGetBytesPerRow (img) * CGImageGetHeight (img));
    
    outBuffer. data = pixelBuffer;
    
    outBuffer. width = CGImageGetWidth (img);
    
    outBuffer. height = CGImageGetHeight (img);
    
    outBuffer. rowBytes = CGImageGetBytesPerRow (img);
    
    NSInteger windowR = boxSize/ 2 ;
    
    CGFloat sig2 = windowR / 3.0 ;
    
    if (windowR> 0 ){ sig2 = - 1 /( 2 *sig2*sig2); }
    
    int16_t *kernel = ( int16_t *) malloc (boxSize* sizeof ( int16_t ));
    
    int32_t   sum = 0 ;
    
    for ( NSInteger i= 0 ; i<boxSize; ++i){
        
        kernel[i] = 255 * exp (sig2*(i-windowR)*(i-windowR));
        
        sum += kernel[i];
        
    }
    
    free (kernel);
    
    // convolution
    
    error = vImageConvolve_ARGB8888 (&inBuffer, &outBuffer, NULL , 0 , 0 , kernel, boxSize, 1 , sum, NULL , kvImageEdgeExtend );
    
    error = vImageConvolve_ARGB8888 (&outBuffer, &inBuffer, NULL , 0 , 0 , kernel, 1 , boxSize, sum, NULL , kvImageEdgeExtend );
    
    outBuffer = inBuffer;
    
    if (error) {
        
        //NSLog(@"error from convolution %ld", error);
        
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
    
    CGContextRef ctx = CGBitmapContextCreate (outBuffer. data ,
                                              
                                              outBuffer. width ,
                                              
                                              outBuffer. height ,
                                              
                                              8 ,
                                              
                                              outBuffer. rowBytes ,
                                              
                                              colorSpace,
                                              
                                              kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast );
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [ UIImage imageWithCGImage :imageRef];
    
    //clean up
    
    CGContextRelease (ctx);
    
    CGColorSpaceRelease (colorSpace);
    
    free (pixelBuffer);
    
    CFRelease (inBitmapData);
    
    CGImageRelease (imageRef);
    
    return returnImage;
    
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = false;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    //判断是否是用户自己
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    if ([userId isEqualToString:self.userId]) {
        // 是否可以删除照片
        pickerBrowser.editing = YES;
    }
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.albumArr count]) {
//        [self.albumArr removeAllObjects];
        return;
    }
    DHUserAlbumModel *item = [self.albumArr objectAtIndex:indexPath.item];
    [self removePhotoWithAlbumItem:item];
    //    [self.imageArr removeObject:item];
    //    [self.collectionView reloadData];
}

- (void)removePhotoWithAlbumItem:(DHUserAlbumModel *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSString stringWithFormat:@"%@",[NSGetTools getUserSessionId]];
    NSString *url = [NSString stringWithFormat:@"%@f_111_12_3.service?a34=%@&p1=%@&p2=%@",kServerAddressTest3,item.b34,sessionId,userId];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.albumArr removeObject:item];
                if (self.albumArr.count==0) {
                    [Mynotification postNotificationName:@"refurbishUserInfo" object:nil];
                }
                [self.collectionView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:[NSString stringWithFormat:@"删除失败:code->%@",infoDic[@"code"]]];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.albumArr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
//    id imageObj = [self.assets objectAtIndex:indexPath.item];
    DHUserAlbumModel *item = self.albumArr[indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:item.b58];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    NPhotoCell *cell = (NPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
//    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
//        photo.asset = imageObj;
//    }
    photo.toView = cell.simage;
    photo.thumbImage = cell.simage.image;
    photo.b34 = item.b34;
    photo.b17 = item.b17;
    photo.b52 = self.nickName;
    photo.b58 = item.b58;
    photo.b59 = item.b59;
    photo.b60 = item.b60;
    photo.b73 = item.b73;
    photo.b75 = item.b75;
    photo.b78 = item.b78;
    photo.b80 = item.b80;
    photo.b108 = item.b108;
    photo.b109 = item.b109;
    return photo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
