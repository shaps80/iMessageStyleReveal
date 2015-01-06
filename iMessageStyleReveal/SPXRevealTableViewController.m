//
//  SPXRevealController.m
//  iMessageStyleReveal
//
//  Created by Shaps Mohsenin on 04/04/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXRevealTableViewController.h"
#import "UITableView+SPXRevealAdditions.h"
#import "LoremIpsum.h"

@implementation SPXRevealTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView enableRevealableViewForDirection:SPXRevealableViewGestureDirectionLeft];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = [LoremIpsum name];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  
  UIView *backgroundView = [UIView new];
  backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
  
  cell.backgroundView = backgroundView;
  
  backgroundView = [UIView new];
  backgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
  cell.selectedBackgroundView = backgroundView;
  
  if (indexPath.row == 0 || indexPath.row == 1) {
    cell.revealableView = [[UINib nibWithNibName:@"TimestampView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    
    if (indexPath.row == 0) {
      cell.revealableView.width = 100;
    } else {
      cell.revealableView.width = 60;
    }
    
    
    backgroundView = [UIView new];
    backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    cell.revealableView.backgroundView = backgroundView;
    
    backgroundView = [UIView new];
    backgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    cell.revealableView.selectedBackgroundView = backgroundView;
  } else {
    // it would be better to put this in -prepareForReuse in your cell subclass ;)
    cell.revealableView = nil;
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 40;
}

@end
