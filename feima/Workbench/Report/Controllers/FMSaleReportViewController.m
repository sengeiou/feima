//
//  FMSaleReportViewController.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSaleReportViewController.h"
#import "FMReportHeadView.h"
#import "FMSalesModel.h"
#import "FMTimeDataModel.h"
#import "FMSalesDataModel.h"

@interface FMSaleReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FMReportHeadView *headView;
@property (nonatomic, strong) UITableView      *salesTableView;

@property (nonatomic, strong) NSMutableArray *reportArray;

@end

@implementation FMSaleReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"销售报表";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    [self setupUI];
    [self loadSalesData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kReportWidth, 30)];
    titleLab.text = self.type == 1 ? @"部门": @"业务员";
    titleLab.font = [UIFont mediumFontWithSize:14];
    titleLab.textColor = [UIColor textBlackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [aView addSubview:titleLab];
    
    NSArray *arr = @[@"上月销量",@"本月销量",@"完成进度"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(titleLab.right+kReportWidth*i, 10, kReportWidth, 30)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [aView addSubview:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreen_Width-16, 1)];
    line.backgroundColor = [UIColor lineColor];
    [aView addSubview:line];
    
    [aView setCircleCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:4.0];
    
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell-identifer" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMSalesModel *model = self.reportArray[indexPath.row];
    NSArray *values = @[model.employeeName,[NSString stringWithFormat:@"%.3f", model.lastSales/10000.0],[NSString stringWithFormat:@"%.3f", model.thisSales/10000.0],[NSString stringWithFormat:@"%ld%%",model.progress]];
    for (NSInteger i=0; i<values.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kReportWidth*i, 10, kReportWidth, 24)];
        lab.font = [UIFont mediumFontWithSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = values[i];
        [cell.contentView addSubview:lab];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadSalesData {
    NSArray *arr = @[@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<arr.count; i++) {
        FMSalesModel *model = [[FMSalesModel alloc] init];
        model.employeeName = arr[i];
        model.lastSales = (i+1)*10445.0;
        model.thisSales = (i+1)*24445.0;
        model.progress = (i+1)*12;
        [tempArr addObject:model];
    }
    self.reportArray = tempArr;
    [self.salesTableView reloadData];
    
    FMTimeDataModel *timeData = [[FMTimeDataModel alloc] init];
    timeData.day = 10;
    timeData.daySum = 31;
    timeData.progress = 10.0/31.0;
    
    FMSalesDataModel *salesData = [[FMSalesDataModel alloc] init];
    salesData.lastSalesSum = 0.34;
    salesData.thisSalesSum = 0.22;
    salesData.progress = 0.22/0.34;
    
    [self.headView displayViewWithTimeData:timeData salesData:salesData];
    
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.salesTableView];
    [self.salesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, kScreen_Height-kNavBar_Height));
    }];
}


#pragma mark -- Getters
#pragma mark 头部视图
- (FMReportHeadView *)headView {
    if (!_headView) {
        _headView = [[FMReportHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 200)];
    }
    return _headView;
}

#pragma mark 销售报表
- (UITableView *)salesTableView {
    if (!_salesTableView) {
        _salesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _salesTableView.delegate = self;
        _salesTableView.dataSource = self;
        _salesTableView.showsVerticalScrollIndicator = NO;
        _salesTableView.tableFooterView = [[UIView alloc] init];
        _salesTableView.backgroundColor = [UIColor whiteColor];
        _salesTableView.layer.cornerRadius = 4;
        _salesTableView.clipsToBounds = YES;
        _salesTableView.separatorInset = UIEdgeInsetsZero;
        [_salesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell-identifer"];
        _salesTableView.tableHeaderView = self.headView;
    }
    return _salesTableView;
}

- (NSMutableArray *)reportArray {
    if (!_reportArray) {
        _reportArray = [[NSMutableArray alloc] init];
    }
    return _reportArray;
}

@end
