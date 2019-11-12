//
//  UITabBar+badge.h
//

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
