//
//  MeTouchCell.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MeTouchCell.h"
static unsigned char kPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
static NSData *kPNGSignatureData = nil;
@implementation MeTouchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self n_layOuts];
    }
    return self;
}



//图片黑白化
- (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
    
}
- (void)changeReportCellWithurlStr:(NSURL *)url{
    
    self.title.textColor = kUIColorFromRGB(0xd0d0d0);
    self.age.textColor = kUIColorFromRGB(0xd0d0d0);
    height.textColor = kUIColorFromRGB(0xd0d0d0);
    address.textColor = kUIColorFromRGB(0xd0d0d0);
    line.backgroundColor = kUIColorFromRGB(0xd0d0d0);
    secondLine.backgroundColor = kUIColorFromRGB(0xd0d0d0);
    _reportLabel.textColor = kUIColorFromRGB(0xc3c2c2);
    _reportLabel.backgroundColor = kUIColorFromRGB(0xDFDFDF);
    _reportLabel.layer.cornerRadius=2;
    _reportLabel.layer.masksToBounds=YES;
    _reportLabel.text=@"已注销";
    [self.contentView addSubview:_reportLabel];
    [portrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image!=nil) {
            NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
            BOOL result = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
            NSString* imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
            NSData* newData = [NSData dataWithContentsOfFile:imagePath];
            if (!result || !newData) {
                BOOL imageIsPng = [self ImageDataHasPNGPreffixWithData:newData];
                NSData* imageData = nil;
                if (imageIsPng) {
                    imageData = UIImagePNGRepresentation(image);
                }
                else {
                    imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                }
                NSFileManager* _fileManager = [NSFileManager defaultManager];
                if (imageData) {
                    [_fileManager removeItemAtPath:imagePath error:nil];
                    [_fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                }
            }
            newData = [NSData dataWithContentsOfFile:imagePath];
            UIImage* grayImage = nil;
            UIImage* newImage = [UIImage imageWithData:newData];
            
            grayImage = [self grayscale:newImage type:1];
            portrait.image = grayImage;
        }else{
            image=[UIImage imageNamed:@"list_item_icon.png"];
            image=[self grayscale:image type:1];
            portrait.image=image;
        }
        
        
        
    }];
}
- (BOOL)ImageDataHasPNGPreffixWithData:(NSData *)data{
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }
    
    return NO;
}
- (void)n_layOuts {
    
    
    portrait = [[UIImageView alloc] init];
    [self.contentView addSubview:portrait];
    
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:15.0f];
    self.title.textColor = kUIColorFromRGB(0x000000);
    [self.contentView addSubview:self.title];
    
    self.VipImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_VipImage];
    
    _reportLabel = [[UILabel alloc] init];
    _reportLabel.font = [UIFont systemFontOfSize:10.0f];
    _reportLabel.textAlignment=NSTextAlignmentCenter;
    
    self.age = [[UILabel alloc] init];
    self.age.font = [UIFont systemFontOfSize:12.0f];
    self.age.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:self.age];
    
    line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor]; //
    [self.contentView addSubview:line];
    
    height = [[UILabel alloc] init];
    height.font = [UIFont systemFontOfSize:12.0f];
    height.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:height];
    
    secondLine = [[UILabel alloc] init];
    secondLine.backgroundColor = [UIColor lightGrayColor]; //kUIColorFromRGB(0x999999)
    [self.contentView addSubview:secondLine];
    
    address = [[UILabel alloc] init];
    address.font = [UIFont systemFontOfSize:12.0f];
    address.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:address];
    
    self.topLine = [[UILabel alloc] init];
    self.topLine.backgroundColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_topLine];
    
    self.downLine = [[UILabel alloc] init];
    self.downLine.backgroundColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_downLine];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    portrait.frame = CGRectMake(15, 10, 60, 60);
    portrait.layer.cornerRadius = 5; // 圆角
    portrait.clipsToBounds = YES;  // 剪切
    
    CGFloat width = [self stringWidth:self.title.text];
    self.title.frame    = CGRectMake(CGRectGetMaxX(portrait.frame)+10, 15, width, 25);
//    self.title.backgroundColor = [UIColor yellowColor];
    self.VipImage.frame = CGRectMake(CGRectGetMaxX(_title.frame)+5, CGRectGetMinY(_title.frame)+5, 17, 14);
    _reportLabel.frame = CGRectMake(CGRectGetMaxX(_title.frame)+5, CGRectGetMinY(_title.frame)+5, 34, 14);
    
    CGFloat agewidth = [self minstringWidth:self.age.text];
    self.age.frame = CGRectMake(CGRectGetMaxX(portrait.frame)+10, CGRectGetMaxY(self.title.frame)+10, agewidth, 20);
    line.frame = CGRectMake(CGRectGetMaxX(self.age.frame)+5, CGRectGetMinY(_age.frame)+5, 1, 11);
    
    
    CGFloat heightwidth = [self minstringWidth:height.text];
    height.frame = CGRectMake(CGRectGetMaxX(line.frame)+5, CGRectGetMinY(_age.frame), heightwidth, 20);
    secondLine.frame = CGRectMake(CGRectGetMaxX(height.frame)+5, CGRectGetMinY(line.frame), 1, 11);
    address.frame = CGRectMake(CGRectGetMaxX(secondLine.frame)+5, CGRectGetMinY(height.frame), 150, 20);
    
}

- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
    return r.size.width;
}

- (CGFloat)minstringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(375, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    return r.size.width;
}

+ (CGFloat)meTouchCellHeight {
    
    return 80;
}
- (void)addDataWithheight:(NSString *)aheight address:(NSString *)aAddress{
    
    
    height.text = aheight;
    address.text = aAddress;
}

// 头像
- (void)cellLoadWithurlStr:(NSURL *)url {
    [_reportLabel removeFromSuperview];
    
    [portrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"333");
    }];
    
}

@end
