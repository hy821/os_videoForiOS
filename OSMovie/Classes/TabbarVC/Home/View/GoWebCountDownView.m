//
//  GoWebCountDownView.m
//


#import "GoWebCountDownView.h"
#import "UIButton+Category.h"
#import "UILabel+Category.h"

@interface GoWebCountDownView ()
@property (nonatomic,assign) NSInteger timeInterval;
@property (nonatomic,weak) UILabel *lab;
@property (nonatomic,weak) NSTimer *timer;
@end

@implementation GoWebCountDownView

- (instancetype)initWithFrame:(CGRect)frame TitleName:(NSString*)title AndCount:(NSInteger)count {
    if (self = [super initWithFrame:frame]) {
        self.timeInterval = count;
        [self creatUIWithTitle:title];
    }return self;
}

- (void)creatUIWithTitle:(NSString *)showTitle {
    
    self.backgroundColor = White_Color;
    UIButton *closeBtn = [UIButton buttonWithImage:Image_Named(@"ic_popup_cancel") selectedImage:Image_Named(@"ic_popup_cancel")];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:Image_Named(@"ic_popup_film")];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-self.sizeH(15));
    }];
    
    UIImageView *imgAnimation = [[UIImageView alloc]initWithImage:Image_Named(@"ic_popup_animationfilm")];
    [self addSubview:imgAnimation];
    [imgAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(img);
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
    animation.duration = 3;
    animation.calculationMode = kCAAnimationCubic;
    [imgAnimation.layer addAnimation:animation forKey:@"playRotaionAnimation"];
    
    UILabel *lab1 = [UILabel labelWithTitle:showTitle font:13 textColor:LightGray_Color textAlignment:1];
    [self addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgAnimation.mas_bottom).offset(self.sizeH(10));
        make.centerX.equalTo(self).offset(self.sizeH(10));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:String_Integer(self.timeInterval) font:13 textColor:Red_Color textAlignment:1];
    [self addSubview:lab];
    self.lab = lab;
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1);
        make.right.equalTo(lab1.mas_left).offset(0);
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)updateAction {
    if (self.timeInterval>1) {
        self.timeInterval -= 1;
        self.lab.text = String_Integer(self.timeInterval);
    }else {
        [_timer invalidate];
        _timer = nil;
        if (self.goWebBlock) {
            self.goWebBlock();
        }
    }
}

- (void)closeAction {
    [_timer invalidate];
    _timer = nil;
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
