//
//  GuessLikeActionSheetView.h
//


#import <UIKit/UIKit.h>

@interface GuessLikeActionSheetView : UIView

- (instancetype)initWithFrame:(CGRect)frame AndData:(NSArray*)arr;

@property (nonatomic,copy) void(^closeBlock)(void);

@property (nonatomic,copy) void(^selectBlock)(ProgramResultListModel*model);

@end

