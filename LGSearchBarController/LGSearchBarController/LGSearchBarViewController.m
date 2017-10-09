//
//  LGSearchBarViewController.m
//  LGSearchBarController
//
//  Created by 李礼光 on 2017/10/9.
//  Copyright © 2017年 LG. All rights reserved.
//

#import "LGSearchBarViewController.h"

@interface LGSearchBarViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

//-----------------搜索前------------------------------
//内容
@property (nonatomic, strong) NSMutableArray *dataSource;
//内容展示TableView
@property (nonatomic, strong) UITableView *searchTableView;

//-----------------搜索栏------------------------------
//搜索栏
@property (nonatomic, strong) UISearchController *searchController;
//结果控制器
@property (nonatomic, strong) UITableViewController *resultTVC;

//-----------------搜索后------------------------------
//结果集
@property (nonatomic, strong) NSMutableArray *resultArr;
@end

@implementation LGSearchBarViewController

#pragma mark - lazy loading
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i<88; i++) {
            NSString *str = [NSString stringWithFormat:@"UISearchBarControllerTest%zd",i];
            [_dataSource addObject:str];
        }
    }
    return _dataSource;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20) style:UITableViewStylePlain];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
    }
    return _searchTableView;
}

- (UITableViewController *)resultTVC {
    if (!_resultTVC) {
        _resultTVC  = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
        _resultTVC.tableView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20);
        _resultTVC.tableView.dataSource = self;
        _resultTVC.tableView.delegate = self;
    }
    return _resultTVC;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        /// 创建搜索界面,把表格视图控制器跟搜索界面相关联
        _searchController = [[UISearchController alloc]initWithSearchResultsController:self.resultTVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        _searchController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        _searchController.searchResultsUpdater = self;
    }
    return _searchController;
}

#pragma mark - system Method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.tableHeaderView = self.searchController.searchBar;
}


#pragma mark - TableView delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        return self.dataSource.count;
    }else if (tableView == self.resultTVC.tableView) {
        return self.resultArr.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dataCellID"];
    }
    if (tableView == self.searchTableView) {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else {
        cell.textLabel.text = self.resultArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        NSLog(@"点击内容项目");
    }else if (tableView == self.resultTVC.tableView) {
        NSLog(@"得到的结果集");
    }
}


#pragma mark - UISearchResultsUpdating
//在点击搜索时会调用一次，点击取消按钮又调用一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // 让取消按钮提前显示出来
    [_searchController.searchBar setShowsCancelButton:YES animated:NO];
    // 修改默认取消按钮
    [_searchController.searchBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UIButton")]) {
                UIButton *button = obj;
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }
        }];
    }];
    
    //判断当前搜索是否在搜索状态还是取消状态
    if (searchController.isActive) {
        if (!self.resultArr) {
            self.resultArr = [[NSMutableArray alloc]init];
        }else {
            [self.resultArr removeAllObjects];
            for (NSString  *str in self.dataSource) {
                NSRange range = [str rangeOfString:searchController.searchBar.text];
                if (range.location != NSNotFound) {
                    [_resultArr addObject:str];
                }
            }
        }
        //刷新搜索界面的tableview
        [self.resultTVC.tableView reloadData];
    }
}

@end
