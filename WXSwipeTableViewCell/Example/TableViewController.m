//
//  TableViewController.m
//  WXSwipeTableViewCell
//
//  Created by Charlie Wu on 23/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "WXReorderTableView.h"

@interface TableViewController () <WXSwipeCellDelegate, WXReorderTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *task;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
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

- (UITableViewCell *)tableView:(WXReorderTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (tableView.indexPathOfReorderingCell != nil && indexPath.row == tableView.indexPathOfReorderingCell.row) {
        cell.textLabel.text = nil;
        return cell;
    }

    cell.label.text = self.task[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (void)swapObjectAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *list = [self.task mutableCopy];
    [list exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    self.task = list;
}

- (void)tableViewCell:(UITableViewCell *)cell didChangeSwiepState:(WXSwipeState)state withDrection:(WXSwipeDirection)direction
{
    switch (state) {
        case WXSwipeStateNone:
            cell.backgroundColor = [UIColor whiteColor];
            break;
        case WXSwipeStateShort:
            cell.backgroundColor = direction == WXSwipeDirectionLeft ? [UIColor colorWithRed:0.443 green:0.457 blue:1.000 alpha:1.000] : [UIColor colorWithRed:1.000 green:0.431 blue:0.453 alpha:1.000];
            break;
        case WXSwipeStateLong:
            cell.backgroundColor =  direction == WXSwipeDirectionLeft ? [UIColor blueColor] : [UIColor redColor];
            break;
        default:
            break;
    }
}

- (void)tableViewCell:(WXSwipeCell *)cell didEndSwipeAtState:(WXSwipeState)state withDirection:(WXSwipeDirection)direction
{
    switch (state) {
        case WXSwipeStateNone:
            self.stateLabel.text = @"swipe ended no none state";
            break;
        case WXSwipeStateShort:
            self.stateLabel.text = @"swipe ended on short swipe";
            break;
        case WXSwipeStateLong:
            self.stateLabel.text = @"swipe ended on short long";
            break;
        default:
            break;
    }

    [cell animateSwipeWithDirection:direction onComplete:^{
        [cell moveContentViewToOffset:0 animated:YES completion:nil];
    }];

}

@end
