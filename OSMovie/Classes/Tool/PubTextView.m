//
//  PubTextView.m
//  Osss
//
//  Copyright © 2019年    asdfghjkl. All rights reserved.
//

#define MAX_LIMIT_NUMS 50  // 来限制最大输入只能50个字符

#import "PubTextView.h"
@interface PubTextView()<UITextViewDelegate>
@property (nonatomic,weak) UILabel * placeLable;
@end
@implementation PubTextView

- (instancetype)init {
  if(self = [super init]) {
      self.delegate = self;
      UILabel * placeLable = [[UILabel alloc]init];
      [self addSubview:placeLable];
      self.placeLable = placeLable;
      self.placeLable.numberOfLines = 0;
      [self.placeLable mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self).offset(8.f);
          make.left.equalTo(self).offset(5.f);
          make.right.equalTo(self).offset(-5.f);
      }];
      
      UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
      [topView setBarStyle:0];
      topView.backgroundColor = [UIColor whiteColor];
      UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      btn.frame = CGRectMake(2, 5, 50, 25);
      [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
      [btn setTitleColor:Black_Color forState:UIControlStateNormal];
      [btn setTitle:@"完成"forState:UIControlStateNormal];
      UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
      NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
      [topView setItems:buttonsArray];
      [self setInputAccessoryView:topView];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noti:) name:UITextViewTextDidChangeNotification object:nil];
  }return self;
}

-(void)dismissKeyBoard {
    [self resignFirstResponder];
    
    if (self.finishEditBlock) {
        self.finishEditBlock(self.text);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.finishEditBlock) {
        self.finishEditBlock(self.text);
    }
}

-(void)noti:(NSNotification*)noti {
    self.placeLable.hidden = self.text.length>0?YES:NO;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setPlaceText:(NSString *)placeText {
    _placeText = placeText;
    self.placeLable.text = placeText;
    [self layoutIfNeeded];
}

-(void)setPlaceTextFont:(UIFont *)placeTextFont {
    _placeTextFont = placeTextFont;
    self.placeLable.font = placeTextFont;
}

-(void)setPlaceTextColor:(UIColor *)placeTextColor {
    _placeTextColor = placeTextColor;
    self.placeLable.textColor = placeTextColor;
}

@end
