//
//  TableViewCell.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()

@end

@implementation TableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.iconLeftShort = [[UIImage imageNamed:@"tick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconLeftLong = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconRightShort = [[UIImage imageNamed:@"list-outline"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconRightLong = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tintColor = [UIColor whiteColor];

    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
