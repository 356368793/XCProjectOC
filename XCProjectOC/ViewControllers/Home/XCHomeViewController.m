//
//  XCHomeViewController.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/19.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCHomeViewController.h"

#define kHomeCollectionViewCellIdentifier @"kHomeCollectionViewCellIdentifier"

@interface XCHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSInteger currentCount;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation XCHomeViewController

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(APP_WIDTH, APP_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHomeCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    _currentCount = 10;
    
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"ADD" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton.layer setCornerRadius:5];
    [addButton.layer setBorderWidth:1];
    [addButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(APP_SCALE_W(100)));
        make.height.equalTo(@(APP_SCALE_H(40)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-APP_SCALE_H(80));
    }];
}

- (void)addButtonClick {
    NSInteger add = arc4random() % 20;
    self.currentCount += add;
    NSLog(@"add %ld data", add);
    
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}



#pragma mark - UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor randomColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    label.text = [NSString stringWithFormat:@"%ld", _currentIndex];
    label.font = [UIFont boldSystemFontOfSize:50];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Collection Click index = %ld", indexPath.row);
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _currentIndex = offsetX / APP_WIDTH;
    NSLog(@"currentIndex = %ld", _currentIndex);
}


@end
