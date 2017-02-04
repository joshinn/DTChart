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
#import "PresentationViewController.h"
#import "TableGridCell.h"
#import "TableChartPresentationViewController.h"
#import "VBarPresentationVC.h"
#import "HBarPresentationVC.h"
#import "PiePresentationVC.h"
#import "DistributionPresentationVC.h"
#import "NSNumber+DTExternal.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, GridCellDelegate>

@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listLineData0;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listLineData7;

@end

@implementation CollectionViewController

static NSString *const GridCellId = @"GridCell";
static NSString *const LineGridCellId = @"LineGridCell";
static NSString *const TableGridCellId = @"TableGridCell";


#define GridCellSize CGSizeMake(25*15, 15*15)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    [self simulateData];

    [self.view addSubview:[self buttonFactory:@"大图" frame:CGRectMake(0, 6 * 15, 80, 48) action:@selector(linePresentation)]];
    [self.view addSubview:[self buttonFactory:@"table大图" frame:CGRectMake(0, 6 * 15 + 50, 80, 48) action:@selector(tableChartPresentation)]];
    [self.view addSubview:[self buttonFactory:@"VBar大图" frame:CGRectMake(0, 6 * 15 + 50 * 2, 80, 48) action:@selector(vBarChartPresentation)]];
    [self.view addSubview:[self buttonFactory:@"HBar大图" frame:CGRectMake(0, 6 * 15 + 50 * 3, 80, 48) action:@selector(hBarChartPresentation)]];
    [self.view addSubview:[self buttonFactory:@"Pie大图" frame:CGRectMake(0, 6 * 15 + 50 * 4, 80, 48) action:@selector(pieChartPresentation)]];
    [self.view addSubview:[self buttonFactory:@"分布大图" frame:CGRectMake(0, 6 * 15 + 50 * 5, 80, 48) action:@selector(disChartPresentation)]];

    self.collectionView.frame = CGRectMake(8 * 15, 6 * 15, GridCellSize.width * 3, GridCellSize.height * 3);
    [self.view addSubview:self.collectionView];
}

- (UIButton *)buttonFactory:(NSString *)title frame:(CGRect)frame action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


- (void)linePresentation {
    PresentationViewController *pVC = [[PresentationViewController alloc] init];
    pVC.chartId = @"10088";
    pVC.listLineData = self.listLineData7;
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)tableChartPresentation {
    TableChartPresentationViewController *tcpVC = [TableChartPresentationViewController new];
    tcpVC.chartId = @"10188";
    tcpVC.listLineData = self.listLineData7;
    [self.navigationController pushViewController:tcpVC animated:YES];
}

- (void)vBarChartPresentation {
    VBarPresentationVC *vBarPresentationVC = [[VBarPresentationVC alloc] init];
    vBarPresentationVC.chartId = @"10288";
    vBarPresentationVC.listBarData = self.listLineData7;
    [self.navigationController pushViewController:vBarPresentationVC animated:YES];
}

- (void)hBarChartPresentation {
    HBarPresentationVC *hBarPresentationVC = [[HBarPresentationVC alloc] init];
    hBarPresentationVC.chartId = @"10388";
    [self.navigationController pushViewController:hBarPresentationVC animated:YES];
}

- (void)pieChartPresentation {
    PiePresentationVC *pieVC = [[PiePresentationVC alloc] init];
    pieVC.chartId = @"10488";
    pieVC.listBarData = self.listLineData7;
    [self.navigationController pushViewController:pieVC animated:YES];
}

-(void)disChartPresentation{
    DistributionPresentationVC *vc = [[DistributionPresentationVC alloc] init];
    vc.chartId = @"10588";
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)simulateData {

    self.listLineData0 = [NSMutableArray arrayWithArray:[self simulateListCommonData:3 pointCount:8 mainAxis:YES]];
    [self.listLineData0 addObjectsFromArray:[self simulateListCommonData:2 pointCount:8 mainAxis:NO]];

    self.listLineData7 = [NSMutableArray arrayWithArray:[self simulateListCommonData:2 pointCount:6 mainAxis:YES]];
//    DTListCommonData *listCommonData1 = self.listLineData7[self.listLineData7.count - 1];
//    DTListCommonData *listCommonData2 = self.listLineData7[self.listLineData7.count - 2];
//    listCommonData2.seriesName = listCommonData1.seriesName;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    return [self simulateCommonData:count baseValue:300];
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"2016-12-%@~2016-12-%@", [self dayString:i + 1], [self dayString:i + 2]];
        DTCommonData *data = [DTCommonData commonData:title value:baseValue + arc4random_uniform(160) * 10];
        [list addObject:data];
    }

    return list;
}

- (NSString *)dayString:(NSUInteger)value {
    if (value >= 10) {
        return [NSString stringWithFormat:@"%@", @(value)];
    } else {
        return [NSString stringWithFormat:@"0%@", @(value)];
    }

}


- (NSMutableArray<DTListCommonData *> *)simulateListCommonData:(NSUInteger)lineCount pointCount:(NSUInteger)pCount mainAxis:(BOOL)isMain {
    NSMutableArray<DTListCommonData *> *list = [NSMutableArray arrayWithCapacity:lineCount];
    for (NSUInteger i = 0; i < lineCount; ++i) {

        NSString *seriesId = [NSString stringWithFormat:@"%@", @(i)];
        NSString *seriesName = [NSString stringWithFormat:@"No.20%@", @(i)];
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
        [_collectionView registerClass:[TableGridCell class] forCellWithReuseIdentifier:TableGridCellId];
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
        [cell setLineChartData:@"10086" listData:self.listLineData0];
        return cell;

    } else if (indexPath.item == 2) {
        TableGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TableGridCellId forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    } else if (indexPath.item == 7) {

        LineGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LineGridCellId forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setLineChartData:@"10088" listData:self.listLineData7];
        return cell;

    } else {
        GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellId forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }

}


- (void)gridCellAdd:(GridCell *)cell {
    if (cell.indexPath.item == 7) {
        LineGridCell *lineCell = (LineGridCell *) cell;

        NSMutableArray<DTListCommonData *> *array = [self simulateListCommonData:2 pointCount:6 mainAxis:YES];
        DTListCommonData *obj1 = array[0];
        obj1.seriesId = @"601";
        obj1.seriesName = @"jiu";
        obj1.commonDatas[3].ptValue = 3200;

        DTListCommonData *obj2 = array[1];
        obj2.seriesId = @"602";
        obj2.seriesName = @"piu";
        obj2.mainAxis = NO;
        obj2.commonDatas[4].ptValue = 4000;


        [lineCell.lineChartController addItemsListData:array withAnimation:YES];

        [self.listLineData7 addObjectsFromArray:array];
    }
}

- (void)gridCellDel:(GridCell *)cell {
    if (cell.indexPath.item == 7) {
        LineGridCell *lineCell = (LineGridCell *) cell;


        NSMutableArray<NSString *> *sIds = [NSMutableArray array];
        NSUInteger count = lineCell.lineChartController.mainYAxisDataCount;
        if (count > 0) {

            for (NSInteger i = self.listLineData7.count - 1; i >= 0; --i) {
                DTListCommonData *listCommonData = self.listLineData7[i];
                if (listCommonData.isMainAxis) {
                    [sIds addObject:listCommonData.seriesId];
                    [self.listLineData7 removeObject:listCommonData];
                    break;
                }
            }
        }

        count = lineCell.lineChartController.secondYAxisDataCount;
        if (count > 0) {

            for (NSInteger i = self.listLineData7.count - 1; i >= 0; --i) {
                DTListCommonData *listCommonData = self.listLineData7[i];
                if (!listCommonData.isMainAxis) {
                    [sIds addObject:listCommonData.seriesId];
                    [self.listLineData7 removeObject:listCommonData];
                    break;
                }
            }
        }

        [lineCell.lineChartController deleteItems:sIds withAnimation:YES];


        DTLog(@"main axis data count = %@ \nsecond axis count = %@", @(lineCell.lineChartController.mainYAxisDataCount), @(lineCell.lineChartController.secondYAxisDataCount));

    }
}


@end
