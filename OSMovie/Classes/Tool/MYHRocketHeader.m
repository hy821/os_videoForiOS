//
//  MJChiBaoZiHeader.m
//  MJRefreshExample
//

#import "MYHRocketHeader.h"

@implementation MYHRocketHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
 
    UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"cat_1"]];
    [idleImages addObject:image];

    [self setImages:idleImages forState:MJRefreshStateIdle];
    [self setImages:idleImages forState:MJRefreshStatePulling];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    
    for (NSUInteger i = 1; i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_%zd", i]];
        [refreshingImages addObject:image];
    }
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setImages: refreshingImages duration:refreshingImages.count*0.1 forState:MJRefreshStateRefreshing];
}
@end
