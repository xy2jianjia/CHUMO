//
//  DHLayout.h
//  Collection
//
//  Created by xy2 on 16/3/15.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHLayout;
@protocol DHLayoutDelegate <NSObject>

- (CGSize)dh_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface DHLayout : UICollectionViewFlowLayout
@property (nonatomic,weak)id <DHLayoutDelegate> delegate;
@end
