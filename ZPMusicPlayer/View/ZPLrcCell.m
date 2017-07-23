//
//  ZPLrcCell.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPLrcCell.h"
#import "ZPLrcLabel.h"
#import "Masonry.h"

@implementation ZPLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ZPLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZPLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化ZPLrcLabel
        ZPLrcLabel *lrcLabel = [[ZPLrcLabel alloc]init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        
        //添加约束
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return self;
}

@end
