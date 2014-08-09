//
//  WXSwipeCell.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXSwipeCell.h"

@interface WXSwipeCell() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIImageView *imageViewLeft;
@property (nonatomic, strong) UIImageView *imageViewRight;
@end

@implementation WXSwipeCell

- (void)layoutSubviews
{
    [super layoutSubviews];

    static CGFloat iconSize = 20.0f;
    static CGFloat iconPadding = 18.0f;

    CGFloat posY = (self.frame.size.height - iconSize) / 2;

    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
        self.panGesture.delegate = self;
        [self.contentView addGestureRecognizer:self.panGesture];


        self.imageViewLeft = [[UIImageView alloc] init];
        self.imageViewLeft.backgroundColor = [UIColor clearColor];

        self.imageViewRight = [[UIImageView alloc] init];
        self.imageViewRight.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.imageViewLeft];
        [self.contentView addSubview:self.imageViewRight];

        self.shortSwipeOffset = self.frame.size.width * .25;
        self.longSwipeOffset = self.frame.size.width * .6;
    }

    self.imageViewLeft.frame = CGRectMake(-iconSize - iconPadding, posY, iconSize, iconSize);
    self.imageViewRight.frame = CGRectMake(self.frame.size.width + iconPadding, posY, iconSize, iconSize);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self moveContentViewToOffset:0 animated:false completion:nil];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)animateSwipeWithDirection:(WXSwipeDirection)direction onComplete:(void(^)(void))completion
{
    switch (direction) {
        case WXSwipeDirectionNone:
            [self moveContentViewToOffset:0 animated:YES completion:completion];
            break;
        case WXSwipeDirectionLeft:
            [self moveContentViewToOffset:-self.contentView.frame.size.width - IconSize - IconPadding animated:YES completion:completion];
            break;
        case WXSwipeDirectionRight:
            [self moveContentViewToOffset:self.contentView.frame.size.width + IconSize + IconPadding animated:YES completion:completion];
            break;
        default:
            break;
    }
}

- (void)moveContentViewToOffset:(CGFloat)offset animated:(BOOL)aniamted completion:(void(^)(void))completion
{
    void(^block)() = ^void() {
        CGRect frame = self.contentView.frame;
        frame.origin.x = offset;
        self.contentView.frame = frame;
    };

    if (aniamted) {
        [UIView animateWithDuration:.5 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            block();
        } completion:^(BOOL finished) {
            if (finished && completion) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }];
    } else {
        block();
        if (completion) completion();
    }
}

- (void)gestureHandler:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.contentView];

    if (point.x > 0 && self.disableRightSwipe) return;
    if (point.x < 0 && self.disableLeftSwipe) return;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:{
            [self moveContentViewToOffset:point.x animated:YES completion:nil];
            WXSwipeState state = [self swipeStateFromOffset:point.x];
            WXSwipeDirection direction = [self swipeDirectionFromOffset:point.x];
            [self triggerSwipeDelegateWithSwipeState:state andDirection:direction swipeEnded:NO];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            WXSwipeState state = [self swipeStateFromOffset:point.x];
            WXSwipeDirection direction = [self swipeDirectionFromOffset:point.x];
            [self triggerSwipeDelegateWithSwipeState:state andDirection:direction swipeEnded:YES];
            break;
        }
        default:
            break;
    }
}

- (void)triggerSwipeDelegateWithSwipeState:(WXSwipeState)state andDirection:(WXSwipeDirection)direction swipeEnded:(BOOL)ended
{

    if (!ended) {
        UIImageView *imageView = direction == WXSwipeDirectionLeft ? self.imageViewRight : self.imageViewLeft;
        switch (state) {
            case WXSwipeStateNone: {
                self.imageViewLeft.image = nil;
                self.imageViewRight.image = nil;
                break;
            }
            case WXSwipeStateShort: {
                imageView.image = direction == WXSwipeDirectionLeft ? self.iconRightShort : self.iconLeftShort;
                break;
            }
            case WXSwipeStateLong: {
                imageView.image = direction == WXSwipeDirectionLeft ? self.iconRightLong : self.iconLeftLong;
                break;
            }
            default:
                break;
        }
    }

    if (self.delegate) {
        if (ended) {
            [self.delegate tableViewCell:self didEndSwipeAtState:state withDirection:direction];
        } else {
            [self.delegate tableViewCell:self didChangeSwiepState:state withDrection:direction];
        }
    }

    if (ended && state == WXSwipeStateNone) {
        [self moveContentViewToOffset:0 animated:YES completion:nil];
    }
}

- (WXSwipeDirection)swipeDirectionFromOffset:(CGFloat)offset
{
    if (offset < 0) return WXSwipeDirectionLeft;
    if (offset > 0) return WXSwipeDirectionRight;
    return WXSwipeDirectionNone;
}

- (WXSwipeState)swipeStateFromOffset:(CGFloat)offset
{
    CGFloat aOffset = fabs(offset);
    if (aOffset > self.longSwipeOffset) return WXSwipeStateLong;
    if (aOffset > self.shortSwipeOffset) return WXSwipeStateShort;

    return WXSwipeStateNone;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];
    return fabs(translation.y) < fabs(translation.x);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return self.panGesture.state == UIGestureRecognizerStatePossible;
}


@end
