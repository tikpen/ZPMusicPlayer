//
//  ZPLrcView.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/12.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPLrcView.h"
#import "Masonry.h"
#import "ZPLrcTool.h"
#import "ZPLrcLine.h"
#import "ZPLrcLabel.h"
#import "ZPLrcCell.h"
@interface ZPLrcView ()<UITableViewDataSource>

@property(nonatomic, weak) UITableView *tableView;
/** 歌词数组 */
@property(nonatomic, strong) NSArray *lrcList;
/** 记录当前刷新的某行 */
@property(nonatomic, assign) NSInteger currentIndex;


@end

@implementation ZPLrcView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //初始化TableView
        [self  setupTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView{
    //初始化
    UITableView *tableView = [[UITableView alloc]init];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
    }];
    //改变TableView属性
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
};

#pragma mark - UITableView数据源 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZPLrcCell *cell = [ZPLrcCell lrcCellWithTableView:tableView];
    
    //设置当前播放歌词的大小
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:17];
    }else{
        cell.lrcLabel.font = [UIFont systemFontOfSize:13];
        cell.lrcLabel.progress = 0; 
    }

    
    //取出数据模型
    ZPLrcLine *lrcLine = self.lrcList[indexPath.row];
    //设置数据
    cell.lrcLabel.text = lrcLine.text;
    
    
    return cell;
}

#pragma mark - 重写lrcName -
- (void)setLrcName:(NSString *)lrcName{
    //让TableView滚到中间
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height * 0.5) animated:NO];
    
    
    //将currentIndex设置为0
    self.currentIndex = 0;
    
    //1.记录歌词名
    _lrcName = [lrcName copy];
    
    //2.解析歌词
    self.lrcList = [ZPLrcTool lrcToolWithLrcName:lrcName];
    //设置第一句歌词
    ZPLrcLine *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    
    //3.刷新表格
    [self.tableView reloadData];

}

#pragma mark - 重写currentTime -
-(void)setCurrentTime:(NSTimeInterval)currentTime{
        //记录当前播放时间
    _currentTime = currentTime;
    
    //判断显示哪句歌词
    NSInteger count = self.lrcList.count;
    
    for (NSInteger i = 0; i < count; i++) {
        //取出当前歌词
        ZPLrcLine *currentLrcLine = self.lrcList[i];
        
        //取出下一句歌词
        NSInteger nextIndex = i + 1;
        ZPLrcLine *nextLrcLine = nil;
        if (nextIndex < self.lrcList.count) {
            nextLrcLine = self.lrcList[nextIndex];
        }
        
        //用当前播放器的时间，用当前这句歌词的时间和下一句歌词的时间做对比
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            //将当前歌词滚动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *aboveIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            
            NSLog(@"%ld",self.currentIndex);
            //记录当前刷新的某行
            self.currentIndex = i;
            
            //刷新当前歌词并刷新上一句歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,aboveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //设置主界面歌词的文字
            self.lrcLabel.text = currentLrcLine.text;
            self.lrcLabel.textColor = [UIColor whiteColor];
            
            
        }
        
        if (self.currentIndex == i) {//当前这句歌词
            
//            //获取当前歌词
//            ZPLrcLine *currentLrcLine = self.lrcList[self.currentIndex];
//            
//            //取出下一句歌词
//            NSInteger nextIndex = self.currentIndex + 1;
//            ZPLrcLine *nextLrcLine = nil;
//            if (nextIndex < self.lrcList.count) {
//                nextLrcLine = self.lrcList[nextIndex];
//            }
//            
            
            // 用当前播放器的时间减去当前歌词的时间除以(下一句歌词的时间-当前歌词的时间)
            CGFloat value = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            
            //设置当前播放歌词的进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            ZPLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrcCell.lrcLabel.progress = value;
            self.lrcLabel.progress = value;
            
        }
    }
    
}


@end
