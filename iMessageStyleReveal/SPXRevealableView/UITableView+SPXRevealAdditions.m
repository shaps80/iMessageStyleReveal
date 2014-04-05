/*
   Copyright (c) 2014 Snippex. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UITableView+SPXRevealAdditions.h"
#import <objc/runtime.h>

static void * SPXRevealableView = &SPXRevealableView;
static void * SPXPanGestureRecognizer = &SPXPanGestureRecognizer;

@interface UITableView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *spx_panGestureRecognizer;
@end

@implementation UITableView (SPXRevealAdditions)

#pragma mark - Gestures

- (UIPanGestureRecognizer *)spx_panGestureRecognizer
{
  UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, SPXPanGestureRecognizer);
  
  if (!gesture) {
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    gesture.delegate = self;
    objc_setAssociatedObject(self, SPXPanGestureRecognizer, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return gesture;
}

- (void)enableRevealableViewForDirection:(SPXRevealableViewGestureDirection)direction
{
  [self addGestureRecognizer:self.spx_panGestureRecognizer];
  [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  // This ensure we can scroll the tableView while our revealable view are visisble
  return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gesture
{
  // if its a gestureRecognizer other than ours, ignore it
  if (gesture != self.spx_panGestureRecognizer) {
    return YES;
  }
  
  CGPoint velocity = [gesture velocityInView:gesture.view];

  // if the gesture is a vertical one it will interfere with existing UITableView, so ignore it
  if (velocity.y != 0) {
    return NO;
  }
  
  return YES;
}

#pragma mark - Cell Frame Updates

static CGFloat translationX;
static CGFloat currentOffset;

- (void)updateCells
{
  for (UITableViewCell *cell in self.visibleCells) {
    CGRect rect = cell.frame;
    CGFloat x = currentOffset;
    
    x = MAX(x, -CGRectGetWidth(cell.revealableView.bounds));
    x = MIN(x, 0);
    
    rect.origin.x = x;
    cell.frame = rect;
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == self && [keyPath isEqualToString:@"contentOffset"]) {
    [self updateCells];
    return;
  }
  
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged:
    {
      translationX = [gesture translationInView:gesture.view].x;
      currentOffset += translationX;
      
      [gesture setTranslation:CGPointZero inView:gesture.view];
      [self updateCells];
    }
      break;
    default:
    {
      [UIView animateWithDuration:0.3 animations:^{
        for (UITableViewCell *cell in self.visibleCells) {
          currentOffset = 0;
          
          CGRect rect = cell.frame;
          rect.origin.x = 0;
          cell.frame = rect;
        }
      } completion:^(BOOL finished) {
        translationX = 0;
      }];
    }
      break;
  }
}

@end


/**
 *  The following implementation just ensures we have a revealable view
 */

@implementation UITableViewCell (SPXRevealAdditions)

- (UIView *)revealableView
{
  return objc_getAssociatedObject(self, SPXRevealableView);
}

- (void)setRevealableView:(UIView *)revealableView
{
  UIView *_revealableView = [self revealableView];

  if (_revealableView == revealableView) {
    return;
  }
  
  objc_setAssociatedObject(self, SPXRevealableView, revealableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  CGRect rect = revealableView.bounds;
  
  rect.origin.x = CGRectGetMaxX(self.bounds);
  rect.origin.y = CGRectGetMinY(rect);
  rect.size.height = CGRectGetHeight(self.bounds);
  
  revealableView.frame = rect;
  revealableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
  
  [self addSubview:revealableView];
}

@end








