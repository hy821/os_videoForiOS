//
//  SubCommentView.m
//  KSMovie
//
//  Created by young He on 2019/5/10.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "SubCommentView.h"
#import "UIButton+Category.h"
#import "UILabel+Category.h"
#import "SubCommentCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "KeyboardTextView.h"

@interface SubCommentView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,assign) SSNetState isNetError;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray<CommentModel *> *dataArr;
@property (nonatomic,copy) NSString *cursor;
@property (nonatomic,strong) KeyboardTextView *inputView;
@property (nonatomic,strong) CommentModel *replyModel;
@end

@implementation SubCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cursor = @"-1";
        self.isNetError = SSNetNormal_state;
        self.replyModel = self.model;
        [self creatUI];
    }return self;
}

- (void)setModel:(CommentModel *)model {
    _model = model;
    [self loadDateWithAnimation:NO];
}

- (void)creatUI {
    self.backgroundColor = White_Color;
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = White_Color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.sizeH(35));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithImage:Image_Named(@"ic_close") selectedImage:Image_Named(@"ic_close")];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView);
        make.centerY.equalTo(topView);
        make.width.equalTo(self.sizeW(30));
    }];
    
    UILabel *lab1 = [UILabel labelWithTitle:@"评论详情" font:15 textColor:Black_Color textAlignment:1];
    [lab1 setFont:Font_Bold(15)];
    [topView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(0.9f);
    }];
    
    [self addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-45);
    }];
    
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(45);
    }];
}

-(void)loadDateWithAnimation:(BOOL)isAnimation {
    if (!self.model.idForModel || self.model.idForModel.length == 0) {
        self.isNetError = SSNetError_state;
        if(self.dataArr.count>0) { [self.dataArr removeAllObjects]; }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
        return;
    }
    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
    NSDictionary *dic = @{
                          @"pid" : self.model.pid,
                          @"aid" : self.model.idForModel,
                          @"cursor" : self.cursor,
                          @"size" : @(PageCount_Normal)
                          };
    [[SSRequest request]GET:SubCommentListUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        self.isNetError = SSNetNormal_state;
        [self.mainTableView.mj_header endRefreshing];
        
        if([self.cursor isEqualToString:@"-1"] && (self.dataArr.count>0)) {
            [self.dataArr removeAllObjects];
        }
        
        CommentModel *m = [CommentModel mj_objectWithKeyValues:response[@"data"]];
        NSArray *arr = m.commentInfoList;
        [arr enumerateObjectsUsingBlock:^(CommentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj refreshForSubComView];
        }];
        [self.dataArr addObjectsFromArray:arr];
        if (arr.count<PageCount_Normal) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.mainTableView.mj_footer endRefreshing];
        }
        [self.mainTableView reloadData];
    } failure:^(SSRequest *request, NSString *errorMsg) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        SSMBToast(errorMsg, MainWindow);
        self.isNetError = SSNetError_state;
        [self.mainTableView reloadEmptyDataSet];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubCommentCell *cell = [SubCommentCell cellForTableView:tableView];
    if (indexPath.section==0) {
        self.model.isFirstCom = YES;
        cell.model = self.model;
        [cell hideBottomLine];
    }else {
        if (self.dataArr.count>0) {
            cell.model = self.dataArr[indexPath.row];
        }
    }
    WS()
    cell.likeBtnToLoginBlock = ^{
        if (weakSelf.goLoginBlock) {
            weakSelf.goLoginBlock();
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count==0) {return;}
    if(![USER_MANAGER isLogin]) {  //评论先登录
        SSMBToast(@"登录后可评论喔~", MainWindow);
        if (self.goLoginBlock) {
            self.goLoginBlock();
        }
        return;
    }
    
    if (indexPath.section==0) {
        self.replyModel = self.model;
        [self.inputView setPlaceHolder:@"我要来吐槽..."];
    }else {
        self.replyModel = self.dataArr[indexPath.row];
        [self.inputView setPlaceHolder:[NSString stringWithFormat:@"回复%@:",self.replyModel.userBasic.nickName]];
    }
    
    if ([self.replyModel.userBasic.userId isEqualToString:[USER_MANAGER getUserID]]) {
        SSMBToast(@"不能回复自己的评论喔~", MainWindow);
        self.replyModel = self.model;
        [self.inputView setPlaceHolder:@"我要来吐槽..."];
        return;
    }
    self.replyModel.indexReply = indexPath.row;
    [self.inputView becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.dataArr.count>0) ? 2 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArr.count>0) {
        return (section==0) ? 1 : self.dataArr.count;
    }return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataArr.count==0) {return nil;}
    UIView *footer = [[UIView alloc]init];
    UILabel *lab = [UILabel labelWithTitle:@"全部回复" font:15 textColor:Black_Color textAlignment:0];
    [footer addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footer);
        make.left.equalTo(footer).offset(self.sizeW(12));
        make.top.bottom.equalTo(footer);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [footer addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer);
        make.left.equalTo(footer).offset(self.sizeW(12));
        make.right.equalTo(footer).offset(self.sizeW(-12));
        make.height.equalTo(0.9f);
    }];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section==0) ? self.sizeH(50) : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return self.model.headerHeight;
    }else {
        if (self.dataArr.count>0) {
            return self.dataArr[indexPath.row].heightForSubComView;
        }return 0;
    }
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = White_Color;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        WS()
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.cursor = self.dataArr.count>0 ? self.dataArr.lastObject.createTime : @"-1";
            [weakSelf loadDateWithAnimation:NO];
        }];
        
        _mainTableView.estimatedRowHeight = 0.f;
        _mainTableView.estimatedSectionFooterHeight = 0.f;
        _mainTableView.estimatedSectionHeaderHeight = 0.f;
        _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }return _mainTableView;
}

- (void)closeAction {
    if (self.closeBlock) { self.closeBlock(); }
}

- (NSMutableArray<CommentModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }return _dataArr;
}

-(KeyboardTextView *)inputView {
    if (!_inputView) {
        _inputView = [[KeyboardTextView alloc] initWithTextViewFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        WS()
        [_inputView setSendMesButtonClickedBlock:^(NSString *text) {
            [weakSelf replyActionWithDetails:text];
        }];
        _inputView.keyboardWillHideShow = ^(CGFloat height, CGFloat dur) {
            [weakSelf remakeInputViewWithHeight:height andDu:dur];
        };
    }return _inputView;
}

//评论成功, 重置回复对象为空
- (void)resetReplyModel {
    if (self.replyModel) {
        self.replyModel = self.model;
    }
    if(self.inputView) {
        [self.inputView setPlaceHolder:@"我要来吐槽..."];
    }
}

- (void)remakeInputViewWithHeight:(CGFloat)h andDu:(CGFloat)du{
    if (self.keyBoardShowHideBlock && h>0) {
        self.keyBoardShowHideBlock(h);
    }
    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(45);
        make.bottom.equalTo(self).offset(-h);
    }];
    [UIView animateWithDuration:du animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)replyActionWithDetails:(NSString*)details {
    [self endEditing:YES];
    if(![USER_MANAGER isLogin]) {  //评论先登录
        SSMBToast(@"登录后可评论喔~", MainWindow);
        if(self.goLoginBlock) {
            self.goLoginBlock();
        }
        return;
    }
    if ([self.replyModel.userBasic.userId isEqualToString:[USER_MANAGER getUserID]]) {
        SSMBToast(@"不能回复自己的评论喔~", MainWindow);
        return;
    }
    SSGifShow(MainWindow, @"加载中");
    NSDictionary *dic = @{@"ownerId" : self.model.ownerId,
                          @"details" : details,
                          @"assetType" : @(self.model.videoType),
                          @"associateId" : self.replyModel ? self.replyModel.idForModel : @"",
                          @"rootId" : self.replyModel ? self.replyModel.rootId : @"",
                          @"machine" : [USER_MANAGER getDeviceName]
                          };
    [[SSRequest request]POST:ReplyCommentUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        SSDissMissAllGifHud(MainWindow, YES);
        
        //都是子评论, 分两种
        CommentModel *m = [[CommentModel alloc]init];
        m.details = details;
        m.timeString = @"刚刚";
        UserBasicModel *uModel = [[UserBasicModel alloc]init];
        uModel.nickName = [USER_MANAGER getUserNickName];
        uModel.portrait = [USER_MANAGER getUserIcon];
        uModel.userId = [USER_MANAGER getUserID];
        m.userBasic = uModel;
        if ([self.replyModel.idForModel isEqualToString:self.model.idForModel]) {  //回复一级评论
            
        }else {  //回复一级评论的子评论
            m.rootDetails = self.replyModel.details;
            m.rootId = self.replyModel.userBasic.userId;
            m.rootUserName = self.replyModel.userBasic.nickName;
        }
        [m refreshForSubComView];
        [self.dataArr insertObject:m atIndex:0];
        [self.mainTableView reloadData];
        
        [self resetReplyModel];
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        SSDissMissAllGifHud(MainWindow, YES);
        SSMBToast(errorMsg, MainWindow);
    }];
}

@end
