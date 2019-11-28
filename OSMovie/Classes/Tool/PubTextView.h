//
//  PubTextView.h
//  Osss

#import <UIKit/UIKit.h>

@interface PubTextView : UITextView
@property (nonatomic,copy) NSString * placeText;
@property (nonatomic,strong) UIColor * placeTextColor;
@property (nonatomic,strong) UIFont * placeTextFont;
@property (nonatomic,copy) void(^finishEditBlock)(NSString *content);
@end
