//
//  TableViewCell.h
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXSwipeCell.h"

@protocol TableViewCellDelegate <NSObject>

- (void)removeCell:(UITableViewCell *)cell;

@end

@interface TableViewCell : WXSwipeCell
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) id<TableViewCellDelegate> delegate;

@end
