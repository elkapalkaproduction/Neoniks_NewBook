#import <UIKit/UIKit.h>

@class InfiniteTableView;

@protocol InfiniteTableViewDatasource <NSObject>

- (UIView *)infiniteTableView:(InfiniteTableView *)tableView viewForIndex:(NSInteger)index widthRect:(CGRect)rect;
- (CGFloat)numberOfColumnsInInfiniteTableView:(InfiniteTableView *)tableView;

@optional

- (CGFloat)columnGapInInfiniteTableView:(InfiniteTableView *)tableView;
- (CGFloat)columnHeightInInfiniteTableView:(InfiniteTableView *)tableView;
- (CGFloat)columnWidthInInfiniteTableView:(InfiniteTableView *)tableView;

@end

@interface InfiniteTableView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<InfiniteTableViewDatasource> dataSource;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)showNextView;
- (void)showPreviousView;

- (void)reloadData;

@end
