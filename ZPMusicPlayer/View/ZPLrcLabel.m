//
//  ZPLrcLabel.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/13.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPLrcLabel.h"

@implementation ZPLrcLabel

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];

}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
    [[UIColor greenColor]set];
   // UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
