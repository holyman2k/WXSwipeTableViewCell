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

@protocol WXSwipeCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell didScrollPassOffset:(BOOL)passedOffset withDirection:(WXDirection)direction;

- (void)tableViewCell:(UITableViewCell *)cell didEndDragPassOffset:(WXDirection)direction;

- (CGFloat)scrollLeftOffset;

- (CGFloat)scrollRightOffset;

@end

@interface WXSwipeCell : UITableViewCell

@property (nonatomic) BOOL disableLeftSwipe;

@property (nonatomic) BOOL disableRightSwipe;

@property (weak, nonatomic) id<WXSwipeCellDelegate> scrollDelegate;

- (void)animateCellToPoint:(CGPoint)point onComplete:(void(^)(void))completion;

@end
