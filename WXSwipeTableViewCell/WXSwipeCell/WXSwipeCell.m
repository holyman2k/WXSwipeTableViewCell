//
//  WXSwipeCell.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXSwipeCell.h"
@interface WXSwipeCell() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation WXSwipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (void)setup
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.frame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = NO;
    [self.contentView addSubview:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self scrollView:scrollView enabledForOffset:scrollView.contentOffset]) return;
    WXDirection direction = scrollView.contentOffset.x < 0 ? DirectionRight : DirectionLeft;
    CGFloat contentXOffset = self.contentView.frame.origin.x;
    if (!scrollView.decelerating) {
        // dragging
        [self scrollContentViewWithScrollView:scrollView];
        if (direction == DirectionRight && contentXOffset > self._scrollRightShortOffset && contentXOffset < self._scrollRightLongOffset) {
            // dragging towards right short
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction andScrollState:WXScrollStateShort];
        } else if (direction == DirectionRight && contentXOffset > self._scrollRightLongOffset ) {
            // dragging towards right long
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction andScrollState:WXScrollStateLong];
        } else if (direction == DirectionLeft && contentXOffset < -self._scrollLeftShortOffset  && contentXOffset > -self._scrollLeftLongOffset) {
            // dragging towards left short
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction andScrollState:WXScrollStateShort];
        } else if (direction == DirectionLeft && contentXOffset < -self._scrollLeftShortOffset ) {
            // dragging towards left long
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction andScrollState:WXScrollStateLong];
        } else {
            // dragging back between left and right offset
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:NO withDirection:direction andScrollState:WXScrollStateNone];
        }
    } else {
        // drag ended
        if (contentXOffset < self._scrollRightShortOffset && contentXOffset > -self._scrollLeftShortOffset) {
            // content view between left and right offset, scroll content view back with scroll view deccleration
            [self scrollContentViewWithScrollView:scrollView];
        }
    }
}

- (void)scrollContentViewWithScrollView:(UIScrollView *)scrollView
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = -scrollView.contentOffset.x * 2.5;
    self.contentView.frame = frame;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![self scrollView:scrollView enabledForOffset:scrollView.contentOffset]) return;
    WXDirection direction = scrollView.contentOffset.x < 0 ? DirectionRight : DirectionLeft;

    CGFloat contentXOffset = self.contentView.frame.origin.x;

    if (direction == DirectionRight && contentXOffset > self._scrollRightShortOffset && contentXOffset < self._scrollRightLongOffset) {
        // drag toward short right ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction andScrollState:WXScrollStateShort];
    } else if (direction == DirectionRight && contentXOffset > self._scrollRightLongOffset) {
        // drag toward long right ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction andScrollState:WXScrollStateLong];
    } else if (direction == DirectionLeft && contentXOffset < -self._scrollLeftShortOffset && contentXOffset > -self._scrollLeftLongOffset) {
        // drag toward short left ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction andScrollState:WXScrollStateShort];
    } else if (direction == DirectionLeft && contentXOffset < -self._scrollLeftLongOffset) {
        // drag toward long left ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction andScrollState:WXScrollStateLong];
    }
}

- (void)animateCellToPoint:(CGPoint)point onComplete:(void(^)(void))completion
{
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin = point;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (BOOL)scrollView:(UIScrollView *)scrollView enabledForOffset:(CGPoint)offset
{
    if (!self.scrollDelegate) return NO;
    if (self._scrollLeftShortOffset == CGFLOAT_MAX && self._scrollRightShortOffset == CGFLOAT_MAX) return NO;
    WXDirection direction = scrollView.contentOffset.x < 0 ? DirectionRight : DirectionLeft;
    if (self.disableLeftSwipe && direction == DirectionLeft) return NO;
    if (self.disableRightSwipe && direction == DirectionRight) return NO;

    return YES;
}

- (CGFloat)_scrollLeftShortOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollLeftShortOffset)]){
        return self.scrollDelegate.scrollLeftShortOffset;
    }
    return CGFLOAT_MAX;
}

- (CGFloat)_scrollRightShortOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollRightShortOffset)]){
        return self.scrollDelegate.scrollRightShortOffset;
    }
    return CGFLOAT_MAX;

}

- (CGFloat)_scrollLeftLongOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollLeftLongOffset)]){
        return self.scrollDelegate.scrollLeftLongOffset > self._scrollLeftShortOffset ? self.scrollDelegate.scrollLeftLongOffset : CGFLOAT_MAX;
    }
    return CGFLOAT_MAX;
}

- (CGFloat)_scrollRightLongOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollRightLongOffset)]){
        return self.scrollDelegate.scrollRightLongOffset > self._scrollRightShortOffset ? self.scrollDelegate.scrollRightLongOffset : CGFLOAT_MAX;
    }
    return CGFLOAT_MAX;
}


@end
