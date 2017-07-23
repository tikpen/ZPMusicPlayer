//
//  ZPMusic.h
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/9.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPMusic : NSObject
@property(nonatomic, copy) NSString *name;  //歌曲名
@property(nonatomic, copy) NSString *filename;  //文件名
@property(nonatomic, copy) NSString *lrcname;   //lrc名
@property(nonatomic, copy) NSString *singer;    //歌手名
@property(nonatomic, copy) NSString *singerIcon;    //歌手图
@property(nonatomic, copy) NSString *icon;  //专辑图
@end
