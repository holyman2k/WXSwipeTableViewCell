//
//  WXSwipeCell.h
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _WXSwipeDirection {
    WXSwipeDirectionNone = 0,
    WXSwipeDirectionLeft = 1,
    WXSwipeDirectionRight = 2,
} WXSwipeDirection;

typedef enum _WXSwipeState {
    WXSwipeStateShort = 0,
    WXSwipeStateLong = 1,
    WXSwipeStateNone = 2,
} WXSwipeState;

@class WXSwipeCell;

@protocol WXSwipeCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didChangeSwiepState:(WXSwipeState)state withDrection:(WXSwipeDirection)direction;

- (void)tableViewCell:(UITableViewCell *)cell didEndSwipeAtState:(WXSwipeState)state withDirection:(WXSwipeDirection)direction;
@end

@interface WXSwipeCell : UITableViewCell

@property (nonatomic) BOOL disableLeftSwipe;
@property (nonatomic) BOOL disableRightSwipe;

@property (nonatomic) CGFloat shortSwipeOffset;
@property (nonatomic) CGFloat longSwipeOffset;

@property (nonatomic, strong) UIImage *iconLeftShort;
@property (nonatomic, strong) UIImage *iconLeftLong;
@property (nonatomic, strong) UIImage *iconRightShort;
@property (nonatomic, strong) UIImage *iconRightLong;


@property (nonatomic, readonly) UIImageView *imageViewLeft;
@property (nonatomic, readonly) UIImageView *imageViewRight;

@property (weak, nonatomic) id<WXSwipeCellDelegate> delegate;

- (void)animateSwipeWithDirection:(WXSwipeDirection)direction onComplete:(void(^)(void))completion;

- (void)moveContentViewToOffset:(CGFloat)offset animated:(BOOL)aniamted completion:(void(^)(void))completion;

@end
