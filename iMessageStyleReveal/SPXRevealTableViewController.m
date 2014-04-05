//
//  SPXRevealController.m
//  iMessageStyleReveal
//
//  Created by Shaps Mohsenin on 04/04/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXRevealTableViewController.h"
#import "UITableView+SPXRevealAdditions.h"


@implementation SPXRevealTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView enableRevealableViewForDirection:SPXRevealableViewGestureDirectionLeft];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%zd : %zd", indexPath.section, indexPath.row];
  cell.revealableView = [[UINib nibWithNibName:@"TimestampView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
  return cell;
}

@end
