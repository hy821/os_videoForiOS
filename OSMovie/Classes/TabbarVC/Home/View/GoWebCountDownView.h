//
//  GoWebCountDownView.h
//


#import <UIKit/UIKit.h>

@interface GoWebCountDownView : UIView

- (instancetype)initWithFrame:(CGRect)frame TitleName:(NSString*)title AndCount:(NSInteger)count;

@property (nonatomic,copy) void(^closeBlock)(void);

@property (nonatomic,copy) void(^goWebBlock)(void);

@end
