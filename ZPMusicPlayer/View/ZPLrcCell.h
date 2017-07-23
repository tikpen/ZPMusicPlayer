//
//  ZPLrcCell.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPLrcLabel;
@interface ZPLrcCell : UITableViewCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@property(nonatomic, weak) ZPLrcLabel *lrcLabel;
@end
