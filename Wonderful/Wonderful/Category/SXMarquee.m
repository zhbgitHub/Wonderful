//
//  SXMarquee.m
//  Wonderful
//
//  Created by dongshangxian on 15/11/5.
//  Copyright © 2015年 Sankuai. All rights reserved.
//

#import "SXMarquee.h"
#import "SXColorGradientView.h"

typedef void(^SXWonderfulAction)();
@interface SXMarquee ()

@property(nonatomic,strong)UIButton *bgBtn;
@property(nonatomic,strong)UILabel *marqueeLbl;
@property(nonatomic,strong)UIColor *bgColor;

@property(nonatomic,copy)NSString *msg;
@property(nonatomic,copy)SXWonderfulAction tapAction;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation SXMarquee

- (instancetype)initWithFrame:(CGRect)frame Msg:(NSString *)msg action:(void(^)())action color:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = color;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.tapAction = action;
        self.bgColor = color;
        self.msg = msg;
        

        [self timerStart];
//        [self addSubview:self.bgBtn];
        [self addSubview:self.marqueeLbl];
        [self addLeftAndRightGradient];
    }
    return self;
}

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        _bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        [_bgBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _bgBtn;
}

- (UILabel *)marqueeLbl
{
    if (!_marqueeLbl) {
//        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        _marqueeLbl = [[UILabel alloc]init];
        _marqueeLbl.text = self.msg;
        
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _marqueeLbl.font = fnt;
        
        CGSize msgSize = [_marqueeLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        _marqueeLbl.frame = CGRectMake(0, 0, msgSize.width, h);
        
        NSLog(@"%f",msgSize.width);
        
        _marqueeLbl.textColor = [UIColor whiteColor];
    }
    return _marqueeLbl;
}

- (void)addLeftAndRightGradient
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    SXColorGradientView *left = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(0, 0, h, h) visible:YES direction:SXColorGradientToRight];
    
    SXColorGradientView *right = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(w - h, 0, h, h) visible:YES direction:SXColorGradientToLeft];
    
    [self addSubview:left];
    [self addSubview:right];
}

- (void)btnClick
{
    if (self.tapAction) {
        self.tapAction();
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tou = [touches anyObject];
    CGPoint now = [tou locationInView:self];
    CGPoint pre = [tou previousLocationInView:self];
    CGFloat offsetX = now.x - pre.x;
    CGRect frame = self.marqueeLbl.frame;
    frame.origin.x = frame.origin.x + offsetX;
    self.marqueeLbl.frame = frame;
}

//-(void)unpauseLabel
//{
//    if (1) {
//        // Unpause sublabel position animation
//        CFTimeInterval labelPausedTime = self.marqueeLbl.layer.timeOffset;
//        self.marqueeLbl.layer.speed = 1.0;
//        self.marqueeLbl.layer.timeOffset = 0.0;
//        self.marqueeLbl.layer.beginTime = 0.0;
//        self.marqueeLbl.layer.beginTime = [self.marqueeLbl.layer convertTime:CACurrentMediaTime() fromLayer:nil] - labelPausedTime;
//        // Unpause gradient fade animation
//        CFTimeInterval gradientPauseTime = self.layer.mask.timeOffset;
//        self.layer.mask.speed = 1.0;
//        self.layer.mask.timeOffset = 0.0;
//        self.layer.mask.beginTime = 0.0;
//        self.layer.mask.beginTime = [self.layer.mask convertTime:CACurrentMediaTime() fromLayer:nil] - gradientPauseTime;
//        
////        self.isPaused = NO;
//    }
//}

- (void)marqueeMove
{
    
    CGRect fr = self.marqueeLbl.frame;
    if (fr.origin.x + fr.size.width < 0) {
        fr.origin.x = self.frame.size.width;
    }else{
        fr.origin.x += -1;
    }
    self.marqueeLbl.frame = fr;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"按下");
    [self timerStop];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"结束");
    [self timerStart];
}

#pragma mark - 计时器关闭和开启
- (void)timerStop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerStart
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(marqueeMove) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}


@end
