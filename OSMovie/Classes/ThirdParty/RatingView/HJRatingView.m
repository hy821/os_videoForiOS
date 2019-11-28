//
//  HJRatingView.m
//  HJRatingViewDemo
//
//  Created by WHJ on 2017/11/10.
//  Copyright © 2017年 WHJ. All rights reserved.
//

#import "HJRatingView.h"
@class HJBaseItemView;

@interface HJRatingView()

@property (nonatomic, strong) HJBaseItemView *bgItemView;

@property (nonatomic, strong) HJBaseItemView *topItemView;

@property (nonatomic, assign) CGFloat currentScore;

@end

@implementation HJRatingView

- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin {
    if(self = [super init]) {
        //设置默认评分
        self.maxScore = 10;
        //初始化视图
        __weak HJRatingView *weakSelf = self;
        self.bgItemView = [[HJBaseItemView alloc] initWithItemWidth:width margin:margin];
        [self addSubview:self.bgItemView];
        [self setFrame:self.bgItemView.frame];

        self.topItemView = [[HJBaseItemView alloc] initWithItemWidth:width margin:margin];
        [self addSubview:self.topItemView];
        [self.topItemView setFrame:CGRectMake(0, 0, 0, width)];
        //评分改变回调
        [self.topItemView setScoreChangedBlock:^(CGFloat score) {
            if (weakSelf.scoreChangedBlock) {
                weakSelf.scoreChangedBlock(score * weakSelf.maxScore);
            }
        }];
        
        //默认支持点击和拖拽整数
        [self setOperationTypes:(HJRatingViewOperationType_click|HJRatingViewOperationType_dragInteger)];
    }
    return self;
}


- (void)setBgImageName:(NSString *)bgImageName andTopImageName:(NSString *)topImageName;{
    
    [self.bgItemView setImageName:bgImageName];
    [self.topItemView setImageName:topImageName];
}

- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setMaxScore:(CGFloat)maxScore{
    _maxScore = maxScore;
    self.topItemView.maxScore = maxScore;
}

#pragma mark - Life Circle

#pragma mark - About UI

#pragma mark - Event response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.topItemView changeFrameWithPoint:point];
}
#pragma mark - Pravite Method

#pragma mark - Public Method
- (void)setOperationTypes:(HJRatingViewOperationType)operationTypes{
    
    _operationTypes = operationTypes;
    self.topItemView.operationTypes = operationTypes;
}

- (void)setItemBGColor:(UIColor *)itemBGColor{
    _itemBGColor = itemBGColor;
    self.bgItemView.itemBGColor = itemBGColor;
    self.topItemView.itemBGColor = itemBGColor;
}
#pragma mark - Getters/Setters/Lazy
- (void)setShowScore:(CGFloat)showScore{
   
    if (showScore>=self.maxScore){
        showScore = _maxScore;
    }
    
    _showScore = showScore;
    
    self.userInteractionEnabled = NO;
   
    [self.topItemView changeFrameWithScore:_showScore];
    
}
#pragma mark - Delegate methods

@end

@implementation HJBaseItemView

#pragma mark - Life Circle
- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin
{
    _itemW = width;
    _margin = margin;
    
    self = [super init];
    
    if(self){
        [self setupUI];
    }
    return self;
}

#pragma mark - About UI
- (void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    //创建按钮并布局
    for (int i = 0; i < 5; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        [self addSubview:imgV];
        [self.imgVs addObject:imgV];
        
        imgV.frame = CGRectMake(i*(_itemW+_margin), 0, _itemW, _itemW);
        imgV.userInteractionEnabled = YES;
    }
    
    //设置自己的frame
    UIImageView *lastImgV = [self.imgVs lastObject];
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(lastImgV.frame), _itemW);
    
    
}
#pragma mark - Event response

#pragma mark - Pravite Method

#pragma mark - Public Method
- (void)setImageName:(NSString *)imageName{
    
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = obj;
        imgV.image = [UIImage imageNamed:imageName];
    }];
}
//根据点击的点 进行frame调整
- (void)changeFrameWithPoint:(CGPoint)point{
    
    __block NSInteger selectIndex = 0;
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV= obj;
        if(CGRectContainsPoint(imgV.frame, point)){
            CGFloat score = 0;
            selectIndex = idx;
            if (self.operationTypes & HJRatingViewOperationType_dragFloat) {//如果支持小数
                if(self.scoreChangedBlock){
                    score = point.x/self.superview.frame.size.width;
                    self.scoreChangedBlock(score);
                    NSLog(@"%.2f",score);
                }
                self.frame = CGRectMake(0, 0, point.x,_itemW);
            }else{
                CGFloat offsetX = CGRectGetMaxX(imgV.frame);
                if(idx == 0 && point.x<(offsetX*2/5)){
                    offsetX = 0;
                    score = 0;
                }else{
                    score = (idx+1)/5.f;
                }
                
                if(self.scoreChangedBlock){
                    self.scoreChangedBlock(score);
                }
                self.frame = CGRectMake(0, 0, offsetX,_itemW);
            }
        }
    }];
}

- (void)changeFrameWithScore:(CGFloat)score{
    
    CGFloat length = self.imgVs.count*_itemW;
    CGFloat scale = score/self.maxScore;
    CGFloat itemLength = scale*length;
    CGFloat topItemCount = itemLength/_itemW;
    BOOL isInteger = (topItemCount - floor(topItemCount))==0;
    CGFloat marginLength = isInteger?(topItemCount-1)*_margin:topItemCount*_margin-0.5*_margin;
    CGFloat topW = itemLength+marginLength;
    self.frame = CGRectMake(0, 0, topW,_itemW);
}

#pragma mark - Getters/Setters/Lazy
- (NSMutableArray *)imgVs{
    if (!_imgVs) {
        _imgVs = [NSMutableArray arrayWithCapacity:5];
    }
    return _imgVs;
}

- (void)setItemBGColor:(UIColor *)itemBGColor{
    _itemBGColor = itemBGColor;
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageV = obj;
        imageV.backgroundColor = itemBGColor;
    }];
}


#pragma mark - Delegate methods

@end



