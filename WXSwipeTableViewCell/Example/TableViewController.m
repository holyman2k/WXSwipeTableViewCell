//
//  TableViewController.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController () <TableViewCellDelegate>
@property (strong, nonatomic) NSMutableArray *task;
@end

@implementation TableViewController


- (NSMutableArray *)task
{
    if (!_task){
        _task = @[@"clean window",
                  @"buy milk",
                  @"buy bread",
                  @"check mail",
                  @"take out garbage",
                  @"phone shop",
                  @"buy fruit",
                  @"clean kitchen"
                  ].mutableCopy;
    }
    return _task;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.task.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.label.text = self.task[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (void)removeCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.task removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
