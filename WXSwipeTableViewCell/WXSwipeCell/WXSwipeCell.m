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
        if (direction == DirectionRight && contentXOffset> self.scrollDelegate.scrollRightOffset) {
            // dragging towards right
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction];
        } else if (direction == DirectionLeft && contentXOffset < -self.scrollDelegate.scrollLeftOffset ) {
            // dragging towards left
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:YES withDirection:direction];
        } else {
            // dragging back between left and right offset
            [self.scrollDelegate tableViewCell:self didScrollPassOffset:NO withDirection:direction];
        }
    } else {
        // drag ended
        if (contentXOffset < self.scrollDelegate.scrollRightOffset && contentXOffset > -self.scrollDelegate.scrollLeftOffset) {
            // content view between left and right offset, scroll content view back with scroll view deccleration
            [self scrollContentViewWithScrollView:scrollView];
        }
    }
}

- (void)scrollContentViewWithScrollView:(UIScrollView *)scrollView
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = -scrollView.contentOffset.x;
    self.contentView.frame = frame;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![self scrollView:scrollView enabledForOffset:scrollView.contentOffset]) return;
    WXDirection direction = scrollView.contentOffset.x < 0 ? DirectionRight : DirectionLeft;

    if (scrollView.contentOffset.x <= -self.scrollDelegate.scrollRightOffset && direction == DirectionRight) {
        // drag toward right ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction];
    } else if (scrollView.contentOffset.x > self.scrollDelegate.scrollLeftOffset && direction == DirectionLeft) {
        // drag toward left ended pass offset
        [self.scrollDelegate tableViewCell:self didEndDragPassOffset:direction];
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
    WXDirection direction = scrollView.contentOffset.x < 0 ? DirectionRight : DirectionLeft;
    if (self.disableLeftSwipe && direction == DirectionLeft) return NO;
    if (self.disableRightSwipe && direction == DirectionRight) return NO;

    return YES;
}

@end
