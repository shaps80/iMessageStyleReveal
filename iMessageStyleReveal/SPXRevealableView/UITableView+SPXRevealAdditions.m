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
static void * SPXPanGestureDirection = &SPXPanGestureDirection;
static void * SPXContext = &SPXContext;

@interface UITableViewCell (SPXRevealAdditionsPrivate)
- (void)updateRevealableViewFrameForDirection:(SPXRevealableViewGestureDirection)direction;
@end

@interface UITableView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *spx_panGestureRecognizer;
@property (nonatomic, assign) SPXRevealableViewGestureDirection spx_gestureDirection;
@end

@implementation UITableView (SPXRevealAdditions)

#pragma mark - Gestures

- (SPXRevealableViewGestureDirection)spx_gestureDirection
{
  return [objc_getAssociatedObject(self, SPXPanGestureDirection) intValue];
}

- (void)setSpx_gestureDirection:(SPXRevealableViewGestureDirection)spx_gestureDirection
{
  objc_setAssociatedObject(self, SPXPanGestureDirection, @(spx_gestureDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)spx_panGestureRecognizer
{
  UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, SPXPanGestureRecognizer);
  
  if (!gesture) {
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    gesture.delegate = self;
    self.panGestureRecognizer.enabled = NO;
    objc_setAssociatedObject(self, SPXPanGestureRecognizer, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return gesture;
}

- (void)enableRevealableViewForDirection:(SPXRevealableViewGestureDirection)direction
{
  [self removeGestureRecognizer:self.spx_panGestureRecognizer];
  [self setSpx_gestureDirection:direction];
  [self addGestureRecognizer:self.spx_panGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  // This ensure we can scroll the tableView while our revealable views are visisble
  return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gesture
{
  [super gestureRecognizerShouldBegin:gesture];
  
  if (self.spx_panGestureRecognizer != gesture) {
    return YES;
  }
  
  CGPoint translation = [gesture translationInView:gesture.view];
  BOOL horizontalScrollingWithSPXGesture = (fabsf(translation.x) > fabsf(translation.y)) && (gesture == self.spx_panGestureRecognizer);
  
  return horizontalScrollingWithSPXGesture;
}

#pragma mark - Layout

static CGFloat translationX;
static CGFloat currentOffset;

- (void)updateFramesForCells
{
  for (UITableViewCell *cell in self.visibleCells) {
    CGRect rect = cell.frame;
    CGFloat x = currentOffset;
    
    if (self.spx_gestureDirection == SPXRevealableViewGestureDirectionLeft) {
      x = MAX(x, -CGRectGetWidth(cell.revealableView.bounds));
      x = MIN(x, 0);
    } else {
      x = MAX(x, 0);
      x = MIN(x, CGRectGetWidth(cell.revealableView.bounds));
    }
    
    rect.origin.x = x;
    cell.frame = rect;
    
    [cell updateRevealableViewFrameForDirection:self.spx_gestureDirection];
  }
}

#pragma mark - Observers and gesture handling

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == SPXContext) {
    if ([keyPath isEqualToString:@"contentOffset"]) {
      [self updateFramesForCells];
      return;
    }
  }
  
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan:
      [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:SPXContext];
      break;
    case UIGestureRecognizerStateChanged:
    {
      translationX = [gesture translationInView:gesture.view].x;
      currentOffset += translationX;
      
      [gesture setTranslation:CGPointZero inView:gesture.view];
      [self updateFramesForCells];
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
      
      [self removeObserver:self forKeyPath:@"contentOffset"];
    }
      break;
  }
}

@end


/**
 *  The following implementation just ensures we have a revealable view and that its layed out correctly
 */

@implementation UITableViewCell (SPXRevealAdditions)

- (void)updateRevealableViewFrameForDirection:(SPXRevealableViewGestureDirection)direction
{
  CGRect rect = self.revealableView.bounds;
  
  if (direction == SPXRevealableViewGestureDirectionLeft) {
    rect.origin.x = CGRectGetMaxX(self.bounds);
    self.revealableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
  } else {
    rect.origin.x = CGRectGetMinX(self.bounds) - CGRectGetWidth(self.revealableView.bounds);
    self.revealableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
  }
  
  rect.origin.y = CGRectGetMinY(rect);
  rect.size.height = CGRectGetHeight(self.bounds);
  self.revealableView.frame = rect;
}

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
  
  [_revealableView removeFromSuperview];
  objc_setAssociatedObject(self, SPXRevealableView, revealableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  [self.contentView addSubview:revealableView];
  [self updateRevealableViewFrameForDirection:SPXRevealableViewGestureDirectionLeft];
}

@end








