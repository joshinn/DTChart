//
//  CollectionViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "CollectionViewController.h"
#import "GridCell.h"
#import "LineGridCell.h"
#import "DTCommonData.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) NSMutableArray<DTCommonData *> *listLineData;

@end

@implementation CollectionViewController

static NSString *const GridCellId = @"GridCell";
static NSString *const LineGridCellId = @"LineGridCell";


#define GridCellSize CGSizeMake(25*15, 15*15)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    [self simulateData];

    self.collectionView.frame = CGRectMake(8 * 15, 6 * 15, GridCellSize.width * 3, GridCellSize.height * 3);
    [self.view addSubview:self.collectionView];
}

- (void)simulateData {
//    NSMutableArray<DTCommonData *> *listLineData = [NSMutableArray array];
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-10" value:1310];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-11" value:1200];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-12" value:1220];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-13" value:1020];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-14" value:1890];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-15" value:1210];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-16" value:1299];
//        [listLineData addObject:data];
//    }
//    {
//        DTCommonData *data = [DTCommonData commonData:@"12-17" value:1799];
//        [listLineData addObject:data];
//    }

    self.listLineData = [self simulateCommonData:10];
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"12-%@", @(i + 1)];
        DTCommonData *data = [DTCommonData commonData:title value:1000 + arc4random_uniform(100) * 10];
        [list addObject:data];
    }

    return list;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.itemSize = GridCellSize;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:GridCellId];
        [_collectionView registerClass:[LineGridCell class] forCellWithReuseIdentifier:LineGridCellId];

    }

    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        LineGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LineGridCellId forIndexPath:indexPath];
        [cell setLineChartData:@"105" data:self.listLineData];
        return cell;
    } else {
        GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellId forIndexPath:indexPath];
        return cell;
    }

}


@end
