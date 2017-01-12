//
//  GridCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridCell;

@protocol GridCellDelegate <NSObject>

- (void)gridCellAdd:(GridCell *)cell;

- (void)gridCellDel:(GridCell *)cell;

@end

@interface GridCell : UICollectionViewCell

@property(nonatomic, weak) id <GridCellDelegate> delegate;

@property (nonatomic) NSIndexPath *indexPath;

@end
