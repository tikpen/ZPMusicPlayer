//
//  ZPLrcView.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/12.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPLrcLabel;

@interface ZPLrcView : UIScrollView
/** 歌词名 */
@property(nonatomic, copy) NSString *lrcName;
/** 播放器当前播放时间 */
@property(nonatomic, assign) NSTimeInterval currentTime;

/** 主界面的歌词Label */
@property(nonatomic, weak) ZPLrcLabel *lrcLabel;
@end
