//
//  WXSwipeCell.h
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _WXDirection {
    DirectionNone = 0,
    DirectionLeft = 1,
    DirectionRight = 2,
} WXDirection;

typedef enum _WXScrollState {
    WXScrollStateShort = 0,
    WXScrollStateLong = 1,
    WXScrollStateNone = 2,
} WXScrollState;

@protocol WXSwipeCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didScrollPassOffset:(BOOL)passedOffset withDirection:(WXDirection)direction andScrollState:(WXScrollState)scrollState;

- (void)tableViewCell:(UITableViewCell *)cell didEndDragPassOffset:(WXDirection)direction andScrollState:(WXScrollState)scrollState;

@optional

- (CGFloat)scrollLeftShortOffset;

- (CGFloat)scrollRightShortOffset;

- (CGFloat)scrollLeftLongOffset;

- (CGFloat)scrollRightLongOffset;

@end

@interface WXSwipeCell : UITableViewCell

@property (nonatomic) BOOL disableLeftSwipe;

@property (nonatomic) BOOL disableRightSwipe;

@property (weak, nonatomic) id<WXSwipeCellDelegate> scrollDelegate;

- (void)animateCellToPoint:(CGPoint)point onComplete:(void(^)(void))completion;

@end
