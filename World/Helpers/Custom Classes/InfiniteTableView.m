#import "InfiniteTableView.h"

static CGFloat DefaultWidth = 150;
static CGFloat DefaultHeight = 50;
static CGFloat DefaultGap = 0;

@interface InfiniteTableView ()

@property (nonatomic, strong)  NSMutableArray *visibleLabels;
@property (nonatomic, strong)  UIView *labelContainerView;
@property (assign, nonatomic) BOOL currentScrolable;


@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger gap;
@property (assign, nonatomic) NSInteger height;

@end

@implementation InfiniteTableView

@synthesize dataSource;

- (void)defaultSettings {
    self.contentSize = CGSizeMake(5000, self.frame.size.height);
    [self setShowsHorizontalScrollIndicator:NO];
    self.delegate  = self;
    self.scrollEnabled = NO;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSettings];
    }
    
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    
    return self;
}


- (NSMutableArray *)visibleLabels {
    if (!_visibleLabels) {
        _visibleLabels = [[NSMutableArray alloc] init];
    }
    
    return _visibleLabels;
}


- (UIView *)labelContainerView {
    if (!_labelContainerView) {
        _labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.contentSize.width,
                                                                       self.frame.size.height)];
        _labelContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelContainerView];
    }
    
    return _labelContainerView;
}


- (NSInteger)numberOfColoumns {
    return [self.dataSource numberOfColumnsInInfiniteTableView:self];
}


- (NSInteger)width {
    if ([self.dataSource respondsToSelector:@selector(columnWidthInInfiniteTableView:)]) {
        return [self.dataSource columnWidthInInfiniteTableView:self];
    }
    
    return DefaultWidth;
}


- (NSInteger)height {
    if ([self.dataSource respondsToSelector:@selector(columnHeightInInfiniteTableView:)]) {
        return [self.dataSource columnHeightInInfiniteTableView:self];
    }
    
    return DefaultHeight;
}


- (NSInteger)gap {
    if ([self.dataSource respondsToSelector:@selector(columnGapInInfiniteTableView:)]) {
        return [self.dataSource columnGapInInfiniteTableView:self];
    }
    
    return DefaultGap;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setContentOffset:self.contentOffset animated:NO];
    self.currentScrolable = NO;
    [self layoutSubviews];
}


- (void)showNextView {
    if (self.currentScrolable) return;
    self.currentScrolable = YES;
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    visibleBounds.origin.x += self.gap + self.width;
    [self scrollRectToVisible:visibleBounds animated:YES];
}


- (void)showPreviousView {
    if (self.currentScrolable) return;
    self.currentScrolable = YES;
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    visibleBounds.origin.x -= self.gap + self.width;
    [self scrollRectToVisible:visibleBounds animated:YES];
    
}


- (void)reloadData {
    for (UIView *view in self.visibleLabels) {
        [view removeFromSuperview];
    }
    
    [self.visibleLabels removeAllObjects];
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    [self tileLabelsFromMinX:minimumVisibleX  toMaxX:maximumVisibleX];
}


#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileLabelsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}


- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter <= (contentWidth / 4.0)) return;
    
    self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
    CGFloat offset = centerOffsetX - currentOffset.x;
    [self moveAllVisibleVIewWithOffset:offset];
}


- (void)moveAllVisibleVIewWithOffset:(CGFloat)offset {
    for (UIView *label in self.visibleLabels) {
        CGPoint center = [self.labelContainerView convertPoint:label.center toView:self];
        center.x += offset;
        label.center = [self convertPoint:center toView:self.labelContainerView];
    }
}


- (UIView *)newView:(CGFloat)edge index:(CGFloat)index {
    CGRect frame = CGRectMake(edge,
                              (self.labelContainerView.frame.size.height  - self.height) / 2,
                              self.width,
                              self.height);
    
    UIView *view = [self.dataSource infiniteTableView:self viewForIndex:index widthRect:frame];
    [self.labelContainerView addSubview:view];
    view.frame = frame;
    view.tag = index;
    
    return view;
}


- (void)addViewFromLeftEdgeWithX:(CGFloat)x {
    NSInteger index = [self leftIndex];
    CGFloat edge = x - self.width - self.gap;
    UIView *view = [self newView:edge index:index];
    [self.visibleLabels insertObject:view atIndex:0];
}


- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    if ([self.visibleLabels count] == 0) {
        [self addViewFromLeftEdgeWithX:minimumVisibleX];
    }
    
    while ([self rightEdge] < maximumVisibleX) {
        NSInteger index = [self rightIndex];
        CGFloat edge = [self rightEdge] + self.gap;
        UIView *view = [self newView:edge index:index];
        [self.visibleLabels addObject:view];
    }
    
    while ([self leftEdge] > minimumVisibleX) {
        [self addViewFromLeftEdgeWithX:[self leftEdge]];
    }
    
    UIView *lastLabel = [self.visibleLabels lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX) {
        [lastLabel removeFromSuperview];
        [self.visibleLabels removeLastObject];
        lastLabel = [self.visibleLabels lastObject];
    }
    
    UIView *firstLabel = [self.visibleLabels firstObject];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX) {
        [firstLabel removeFromSuperview];
        [self.visibleLabels removeObjectAtIndex:0];
        firstLabel = [self.visibleLabels firstObject];
    }
}


- (CGFloat)leftEdge {
    UIView *firstLabel = [self.visibleLabels firstObject];
    return CGRectGetMinX([firstLabel frame]);
}


- (CGFloat)rightEdge {
    UIView *lastLabel = [self.visibleLabels lastObject];
    return CGRectGetMaxX([lastLabel frame]);
}


- (NSInteger)rightIndex {
    NSInteger numberOfColumns = [self numberOfColoumns];
    UIView *labelRight = [self.visibleLabels lastObject];
    NSInteger rightIndex = labelRight.tag;
    rightIndex++;
    if (rightIndex >= numberOfColumns) {
        rightIndex = 0;
    }
    
    return rightIndex;
}


- (NSInteger)leftIndex {
    NSInteger numberOfColumns = [self numberOfColoumns];
    UIView *labelLeft = [self.visibleLabels firstObject];
    NSInteger leftIndex = labelLeft.tag;
    leftIndex--;
    if (leftIndex < 0) {
        leftIndex = numberOfColumns - 1;
    }
    
    return leftIndex;
}

@end
