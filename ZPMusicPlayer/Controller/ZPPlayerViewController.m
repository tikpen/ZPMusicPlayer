//
//  ZPPlayerViewController.m
//  ZPMusicPlayer
//
//  Created by Cass on 2017/7/8.
//  Copyright © 2017年 周鹏. All rights reserved.
//

#import "ZPPlayerViewController.h"
#import "Masonry.h"

#import "ZPMusicTool.h"
#import "ZPAudioTool.h"
#import "CALayer+PauseAimate.h"
#import "ZPLrcView.h"
#import "ZPLrcLabel.h"
#import "ZPPlayer.h"

@interface ZPPlayerViewController () <UITableViewDelegate,AVAudioPlayerDelegate>
/** 歌手背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
/** 进度条*/
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 歌手图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 当前播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 播放总时长 */
@property (weak, nonatomic) IBOutlet UILabel *allTimeLabel;
/** 进度条时间 */
@property(strong, nonatomic) NSTimer *progressTimer;
/** 播放器 */
//@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
/** 歌词 */
@property (weak, nonatomic) IBOutlet ZPLrcView *lrcView;
/** 歌词label */
@property (weak, nonatomic) IBOutlet ZPLrcLabel *lrcLabel;
/**歌词定时器*/
@property(nonatomic, strong) CADisplayLink *lrcTimer;
@end

@implementation ZPPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置滑块图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb@2x"] forState:UIControlStateNormal];
    
    //设置歌词View ContentSize
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width*2, 0);
    
    //设置毛玻璃效果
    [self setupBlur];
    
    //将lrcView中的lrcLabel设置为主控制器的lrcLabel
    //self.lrcView.lrcLabel = self.lrcLabel;
    
    //隐藏UIScrollView水平滑动条
    [_lrcView setShowsHorizontalScrollIndicator:NO];
    //隐藏UIScrollView垂直滑动条
    [_lrcView setShowsVerticalScrollIndicator:NO];
    
    self.songLabel.textColor = [UIColor whiteColor];
    self.singerLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.allTimeLabel.textColor = [UIColor whiteColor];
    self.lrcLabel.textColor = [UIColor whiteColor];
    
}

#pragma mark - 添加毛玻璃效果 -
- (void)setupBlur{
    //1.初始化toolBar
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.albumView addSubview:toolBar];
    toolBar.barStyle = UIBarStyleBlack;
    
    //2.添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self startPlayingMusic];
}

- (void)startPlayingMusic{
    //清除主界面上一首歌词
    self.lrcLabel.text = nil;
    
    //将lrcView中的lrcLabel设置为主控制器的lrcLabel
    self.lrcView.lrcLabel = self.lrcLabel;
    
    //1.获取当前歌曲
    ZPMusic *playingMusic = [ZPMusicTool playingMusic];
    
    //2.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    //3.播放音乐
//    AVAudioPlayer *currentPlayer = [ZPAudioTool playMusic:playingMusic.filename];
    //currentPlayer.delegate = self;
//    [[ZPPlayer shareSingleton] initWithContentsOfURL:[NSURL URLWithString:playingMusic.filename] error:nil];
//    [[ZPPlayer shareSingleton] initWithContentsOfURL:[NSURL fileURLWithPath:playingMusic.filename] error:nil];
    [ZPAudioTool playMusic:playingMusic.filename];
    [ZPPlayer shareSingleton].delegate = self;
    self.currentTimeLabel.text = [self stringWithTime:[ZPPlayer shareSingleton].currentTime];
    self.allTimeLabel.text = [self stringWithTime:[ZPPlayer shareSingleton].duration];
    //self.currentPlayer = currentPlayer;
    
    //设置播放按钮
    //设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    
    
    //4.设置定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    
    //5.添加动画
    //[self addIconViewAnimate];
    
//    [[ZPPlayer shareSingleton] prepareToPlay];
    
}

#pragma mark -  添加动画-
-(void)addIconViewAnimate{
    CABasicAnimation    *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;//无限循环
    rotateAnimate.duration = 30;//旋转一圈的时间
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
    
}


#pragma mark - 子控件设置 -
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    // 添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width*0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0].CGColor;
    self.iconView.layer.borderWidth = 3;
}

#pragma mark - 对进度条时间的处理 -
-(void)addProgressTimer{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

-(void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
}

-(void)updateProgressInfo {
    self.currentTimeLabel.text = [self stringWithTime:[ZPPlayer shareSingleton].currentTime];
//    int value = (int)self.currentPlayer.currentTime / (int)self.currentPlayer.duration;
    self.progressSlider.value = [ZPPlayer shareSingleton].currentTime / [ZPPlayer shareSingleton].duration;
    

}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //        ZPMusic *nextMusic = [ZPMusicTool nextMusic];
    //        [self playMUsic:nextMusic];
    [self nextMusic];
}

#pragma mark - 对歌词定时器的处理 -
- (void)addLrcTimer{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

- (void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;

}

- (void)updateLrcInfo{
    self.lrcView.currentTime = [ZPPlayer shareSingleton].currentTime;

}

#pragma mark - 对进度条的处理 -
- (IBAction)start {
    [self removeProgressTimer];
}
- (IBAction)end {
    [ZPPlayer shareSingleton].currentTime = self.progressSlider.value*[ZPPlayer shareSingleton].duration;
    
    [self addProgressTimer];
    
}
- (IBAction)progressValueChange {
    self.currentTimeLabel.text = [self stringWithTime:self.progressSlider.value*[ZPPlayer shareSingleton].duration];
}
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    //获取点
    CGPoint point = [sender locationInView:sender.view];
    
    //获取点的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    //获取播放时间
    [ZPPlayer shareSingleton].currentTime = ratio * [ZPPlayer shareSingleton].duration;
    
    //更新时间和滑块的位置
    [self updateProgressInfo];
}

#pragma mark - 播放操作 -

- (IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)startOrPause:(UIButton *)sender {
    
    if ([ZPPlayer shareSingleton].playing) {
        
        [[ZPPlayer shareSingleton] pause];
        
        [sender setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        
        [self removeProgressTimer];
        
        [self.iconView.layer pauseAnimate];
        
        
    }else{
        [[ZPPlayer shareSingleton] play];
        
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        [self addProgressTimer];
        
        [self.iconView.layer resumeAnimate];
    
    }

    
}


- (IBAction)aboveMusic {
    //获取下一首歌曲
    ZPMusic *aboveMusic = [ZPMusicTool aboveMusic];
    [self playMUsic:aboveMusic];
}

- (IBAction)nextMusic {
        //获取下一首歌曲
    ZPMusic *nextMusic = [ZPMusicTool nextMusic];
    [self playMUsic:nextMusic];
}

-(void)playMUsic:(ZPMusic *)music{
    if (! (music == nil)) {
        //获取当前歌曲
        ZPMusic *currentMusic = [ZPMusicTool playingMusic];
        //停止播放当前歌曲
        [ZPAudioTool stopMusic:currentMusic.filename];
        //设置为默认播放歌曲
        [ZPMusicTool setupPlayingMusic:music];
        //播放歌曲并更新界面
        [self startPlayingMusic];
        
        [self addIconViewAnimate];
        
        [[ZPPlayer shareSingleton] play];

    }
    [self.playOrPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
   
}

- (void)automaticPlay{
    if ([ZPPlayer shareSingleton].currentTime == [ZPPlayer shareSingleton].duration) {
        ZPMusic *nextMusic = [ZPMusicTool nextMusic];
        [self playMUsic:nextMusic];
    }

}

#pragma mark - UIScroView Delegate-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //1.获取滑动偏移量
    CGPoint point = scrollView.contentOffset;
    
    //2.获取偏移比例
    CGFloat alpha = 1 - point.x / scrollView.bounds.size.width;
    
    //3.设置alpha
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;

}


- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger min = time / 60;
    NSInteger sec = (int)time % 60;
    return [NSString stringWithFormat:@"%02lu:%02lu",min,sec];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
