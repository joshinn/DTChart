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
#import "DTChartController.h"
#import "DTLineChartController.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, GridCellDelegate>

@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listLineData;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listLineData2;

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

    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6 * 15, 60, 48)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];

    self.collectionView.frame = CGRectMake(8 * 15, 6 * 15, GridCellSize.width * 3, GridCellSize.height * 3);
    [self.view addSubview:self.collectionView];
}


- (void)add {

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

    self.listLineData = [NSMutableArray arrayWithArray:[self simulateListCommonData:3 pointCount:8 mainAxis:YES]];
    [self.listLineData addObjectsFromArray:[self simulateListCommonData:2 pointCount:8 mainAxis:NO]];

    self.listLineData2 = [NSMutableArray arrayWithArray:[self simulateListCommonData:2 pointCount:7 mainAxis:YES]];
    DTListCommonData *listCommonData1 = self.listLineData2[self.listLineData2.count - 1];
    DTListCommonData *listCommonData2 = self.listLineData2[self.listLineData2.count - 2];
    listCommonData2.seriesName = listCommonData1.seriesName;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    return [self simulateCommonData:count baseValue:300];
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue{
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"12-%@", @(i + 1)];
        DTCommonData *data = [DTCommonData commonData:title value:baseValue + arc4random_uniform(160) * 10];
        [list addObject:data];
    }

    return list;
}


- (NSMutableArray<DTListCommonData *> *)simulateListCommonData:(NSUInteger)lineCount pointCount:(NSUInteger)pCount mainAxis:(BOOL)isMain {
    NSMutableArray<DTListCommonData *> *list = [NSMutableArray arrayWithCapacity:lineCount];
    for (NSUInteger i = 0; i < lineCount; ++i) {

        NSString *seriesId = [NSString stringWithFormat:@"%@", @(i)];
        NSString *seriesName = [NSString stringWithFormat:@"20%@", @(i)];
        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:[self simulateCommonData:pCount] mainAxis:isMain];

        [list addObject:listCommonData];
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
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setLineChartData:@"10086" listData:self.listLineData];
        return cell;
    } else if (indexPath.item == 7) {

        LineGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LineGridCellId forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setLineChartData:@"10088" listData:self.listLineData2];
        return cell;

    } else {
        GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellId forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }

}


- (void)gridCellAdd:(GridCell *)cell {
    if(cell.indexPath.item == 7){
        LineGridCell *lineCell = (LineGridCell *) cell;

        NSMutableArray<DTListCommonData *> *array = [self simulateListCommonData:2 pointCount:7 mainAxis:YES];
        DTListCommonData * obj1 = array[0];
        obj1.seriesId = @"601";
        obj1.seriesName = @"jiu";
        obj1.commonDatas[3].ptValue = 3200;

        DTListCommonData * obj2 = array[1];
        obj2.seriesId = @"602";
        obj2.seriesName = @"piu";
        obj2.commonDatas[3].ptValue = 4000;


        [lineCell.lineChartController addItemsListData:array withAnimation:YES];

        [self.listLineData2 addObjectsFromArray:array];
    }
}

- (void)gridCellDel:(GridCell *)cell {

}


@end
