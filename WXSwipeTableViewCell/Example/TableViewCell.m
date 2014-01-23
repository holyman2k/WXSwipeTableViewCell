//
//  TableViewCell.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell() <WXSwipeCellDelegate>

@end

@implementation TableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollDelegate = self;
    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.disableLeftSwipe = YES;
}


- (void)tableViewCell:(UITableViewCell *)cell didScrollPassOffset:(BOOL)passedOffset withDirection:(WXDirection)direction andScrollState:(WXScrollState)scrollState
{
    switch (direction) {
        case DirectionLeft:
            self.backgroundColor = passedOffset ? scrollState ? [UIColor colorWithRed:0.008 green:0.518 blue:0.51 alpha:1] : [UIColor colorWithRed:0.205 green:0.689 blue:1.000 alpha:1.000] : [UIColor clearColor];
            break;
        case DirectionRight:
            self.backgroundColor = passedOffset ? scrollState ? [UIColor colorWithRed:1.000 green:0.939 blue:0.325 alpha:1.000] : [UIColor colorWithRed:1.000 green:0.282 blue:0.289 alpha:1.000] : [UIColor clearColor];
            break;
        default:
            break;
    }
}

- (void)tableViewCell:(UITableViewCell *)cell didEndDragPassOffset:(WXDirection)direction andScrollState:(WXScrollState)scrollState
{
    if (direction == DirectionRight) {
        CGPoint point = CGPointMake(self.contentView.frame.size.width, 0);
        [self animateCellToPoint:point onComplete:^{
            [self.delegate removeCell:self];
            self.backgroundColor = [UIColor clearColor];
        }];
    } else if (direction == DirectionLeft) {
        CGPoint point = CGPointMake(-self.contentView.frame.size.width, 0);
        [self animateCellToPoint:point onComplete:^{
            [self.delegate removeCell:self];
            self.backgroundColor = [UIColor clearColor];
        }];
    }
}

//- (CGFloat)scrollLeftShortOffset
//{
//    return 80;
//}

//- (CGFloat)scrollRightShortOffset
//{
//    return 80;
//}

- (CGFloat)scrollLeftLongOffset
{
    return 160;
}

- (CGFloat)scrollRightLongOffset
{
    return 160;
}

@end
