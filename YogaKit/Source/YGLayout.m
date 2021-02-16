/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "UIView+Yoga.h"
#import "YGLayout+Private.h"

#define YG_PROPERTY(type, lowercased_name, capitalized_name)      \
  -(type)lowercased_name {                                        \
    return YGNodeStyleGet##capitalized_name(self.node);           \
  }                                                               \
                                                                  \
  -(void)set##capitalized_name : (type)lowercased_name {          \
    YGNodeStyleSet##capitalized_name(self.node, lowercased_name); \
  }

#define YG_VALUE_PROPERTY(lowercased_name, capitalized_name)                \
  -(YGValue)lowercased_name {                                               \
    return YGNodeStyleGet##capitalized_name(self.node);                     \
  }                                                                         \
                                                                            \
  -(void)set##capitalized_name : (YGValue)lowercased_name {                 \
    switch (lowercased_name.unit) {                                         \
      case YGUnitUndefined:                                                 \
        YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
        break;                                                              \
      case YGUnitPoint:                                                     \
        YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
        break;                                                              \
      case YGUnitPercent:                                                   \
        YGNodeStyleSet##capitalized_name##Percent(                          \
            self.node, lowercased_name.value);                              \
        break;                                                              \
      default:                                                              \
        NSAssert(NO, @"Not implemented");                                   \
    }                                                                       \
  }

#define YG_AUTO_VALUE_PROPERTY(lowercased_name, capitalized_name)           \
  -(YGValue)lowercased_name {                                               \
    return YGNodeStyleGet##capitalized_name(self.node);                     \
  }                                                                         \
                                                                            \
  -(void)set##capitalized_name : (YGValue)lowercased_name {                 \
    switch (lowercased_name.unit) {                                         \
      case YGUnitPoint:                                                     \
        YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
        break;                                                              \
      case YGUnitPercent:                                                   \
        YGNodeStyleSet##capitalized_name##Percent(                          \
            self.node, lowercased_name.value);                              \
        break;                                                              \
      case YGUnitAuto:                                                      \
        YGNodeStyleSet##capitalized_name##Auto(self.node);                  \
        break;                                                              \
      default:                                                              \
        NSAssert(NO, @"Not implemented");                                   \
    }                                                                       \
  }

#define YG_EDGE_PROPERTY_GETTER(                             \
    type, lowercased_name, capitalized_name, property, edge) \
  -(type)lowercased_name {                                   \
    return YGNodeStyleGet##property(self.node, edge);        \
  }

#define YG_EDGE_PROPERTY_SETTER(                                \
    lowercased_name, capitalized_name, property, edge)          \
  -(void)set##capitalized_name : (CGFloat)lowercased_name {     \
    YGNodeStyleSet##property(self.node, edge, lowercased_name); \
  }

#define YG_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge) \
  YG_EDGE_PROPERTY_GETTER(                                                  \
      CGFloat, lowercased_name, capitalized_name, property, edge)           \
  YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGE_PROPERTY_SETTER(                                       \
    objc_lowercased_name, objc_capitalized_name, c_name, edge)               \
  -(void)set##objc_capitalized_name : (YGValue)objc_lowercased_name {        \
    switch (objc_lowercased_name.unit) {                                     \
      case YGUnitUndefined:                                                  \
        YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value); \
        break;                                                               \
      case YGUnitPoint:                                                      \
        YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value); \
        break;                                                               \
      case YGUnitPercent:                                                    \
        YGNodeStyleSet##c_name##Percent(                                     \
            self.node, edge, objc_lowercased_name.value);                    \
        break;                                                               \
      default:                                                               \
        NSAssert(NO, @"Not implemented");                                    \
    }                                                                        \
  }

#define YG_VALUE_EDGE_PROPERTY(                                   \
    lowercased_name, capitalized_name, property, edge)            \
  YG_EDGE_PROPERTY_GETTER(                                        \
      YGValue, lowercased_name, capitalized_name, property, edge) \
  YG_VALUE_EDGE_PROPERTY_SETTER(                                  \
      lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name) \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Left,                                         \
      capitalized_name##Left,                                        \
      capitalized_name,                                              \
      YGEdgeLeft)                                                    \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Top,                                          \
      capitalized_name##Top,                                         \
      capitalized_name,                                              \
      YGEdgeTop)                                                     \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Right,                                        \
      capitalized_name##Right,                                       \
      capitalized_name,                                              \
      YGEdgeRight)                                                   \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Bottom,                                       \
      capitalized_name##Bottom,                                      \
      capitalized_name,                                              \
      YGEdgeBottom)                                                  \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Start,                                        \
      capitalized_name##Start,                                       \
      capitalized_name,                                              \
      YGEdgeStart)                                                   \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##End,                                          \
      capitalized_name##End,                                         \
      capitalized_name,                                              \
      YGEdgeEnd)                                                     \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Horizontal,                                   \
      capitalized_name##Horizontal,                                  \
      capitalized_name,                                              \
      YGEdgeHorizontal)                                              \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name##Vertical,                                     \
      capitalized_name##Vertical,                                    \
      capitalized_name,                                              \
      YGEdgeVertical)                                                \
  YG_VALUE_EDGE_PROPERTY(                                            \
      lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

YGValue YGPointValue(CGFloat value) {
  return (YGValue){.value = value, .unit = YGUnitPoint};
}

YGValue YGPercentValue(CGFloat value) {
  return (YGValue){.value = value, .unit = YGUnitPercent};
}

static YGConfigRef globalConfig;

@interface __YGNodeContext: NSObject <NSCopying>

@property(nonatomic, readwrite, weak) UIView* view;
@property(nonatomic, readwrite, copy) YGLayoutMeasureFunc measure;

@end

@implementation __YGNodeContext

- (id)copyWithZone:(NSZone *)zone {
  __YGNodeContext* copy = [[__YGNodeContext allocWithZone: zone] init];
  copy.measure = self.measure;
  return copy;
}

@end

@interface YGLayout ()

@property(nonatomic, assign, readonly) BOOL isUIView;
@property(nonatomic, retain, readwrite) __YGNodeContext* ctx;
@property(nonatomic, retain, readwrite) NSMutableSet<YGLayout *>* childrenSet;

@end

@implementation YGLayout

@synthesize node = _node;

+ (void)initialize {
  globalConfig = YGConfigNew();
  YGConfigSetExperimentalFeatureEnabled(
      globalConfig, YGExperimentalFeatureWebFlexBasis, true);
  YGConfigSetPointScaleFactor(globalConfig, [UIScreen mainScreen].scale);
}

- (instancetype)init {
  if (self = [super init]) {
    _ctx = [[__YGNodeContext alloc] init];
    _childrenSet = [[NSMutableSet alloc] init];
    _node = YGNodeNewWithConfig(globalConfig);
    YGNodeSetContext(_node, (__bridge void*)_ctx);
    YGNodeSetMeasureFunc(self.node, YGMeasure);
  }
    
  return self;
}

- (instancetype)initWithView:(UIView*)view {
  if (self = [super init]) {
    _ctx = [[__YGNodeContext alloc] init];
    _ctx.view = view;
    _childrenSet = [[NSMutableSet alloc] init];
    _node = YGNodeNewWithConfig(globalConfig);
    YGNodeSetContext(_node, (__bridge void*)_ctx);
    YGNodeSetMeasureFunc(self.node, YGMeasure);
    _isUIView = [_ctx.view isMemberOfClass:[UIView class]];
  }

  return self;
}

- (UIView *)view {
  return _ctx.view;
}

- (void)setView:(UIView *)view {
  _ctx.view = view;
  _isUIView = [_ctx.view isMemberOfClass:[UIView class]];
}

- (void)dealloc {
  YGNodeFree(self.node);
}

- (BOOL)isDirty {
  return YGNodeIsDirty(self.node);
}

- (void)markDirty {
  if (self.isDirty || !self.isLeaf) {
    return;
  }

  // Yoga is not happy if we try to mark a node as "dirty" before we have set
  // the measure function. Since we already know that this is a leaf,
  // this *should* be fine. Forgive me Hack Gods.
  const YGNodeRef node = self.node;
  if (!YGNodeHasMeasureFunc(node)) {
    YGNodeSetMeasureFunc(node, YGMeasure);
  }

  YGNodeMarkDirty(node);
}

- (NSUInteger)numberOfChildren {
  return self.childrenSet.count;
}

- (BOOL)isLeaf {
  NSAssert(
      [NSThread isMainThread],
      @"This method must be called on the main thread.");
//  if (self.isEnabled) {
    // Maybe unnecessary??
//    if (self.view != nil) {
//      for (UIView* subview in self.view.subviews) {
//        YGLayout* const yoga = subview.yoga;
//        if (yoga.isEnabled && yoga.isIncludedInLayout) {
//          return NO;
//        }
//      }
//    } else {
  return YGNodeGetChildCount(self.node) == 0;
//    }
//  }

  return YES;
}

#pragma mark - Style

- (YGPositionType)position {
  return YGNodeStyleGetPositionType(self.node);
}

- (void)setPosition:(YGPositionType)position {
  YGNodeStyleSetPositionType(self.node, position);
}

YG_PROPERTY(YGDirection, direction, Direction)
YG_PROPERTY(YGFlexDirection, flexDirection, FlexDirection)
YG_PROPERTY(YGJustify, justifyContent, JustifyContent)
YG_PROPERTY(YGAlign, alignContent, AlignContent)
YG_PROPERTY(YGAlign, alignItems, AlignItems)
YG_PROPERTY(YGAlign, alignSelf, AlignSelf)
YG_PROPERTY(YGWrap, flexWrap, FlexWrap)
YG_PROPERTY(YGOverflow, overflow, Overflow)
YG_PROPERTY(YGDisplay, display, Display)

YG_PROPERTY(CGFloat, flex, Flex)
YG_PROPERTY(CGFloat, flexGrow, FlexGrow)
YG_PROPERTY(CGFloat, flexShrink, FlexShrink)
YG_AUTO_VALUE_PROPERTY(flexBasis, FlexBasis)

YG_VALUE_EDGE_PROPERTY(left, Left, Position, YGEdgeLeft)
YG_VALUE_EDGE_PROPERTY(top, Top, Position, YGEdgeTop)
YG_VALUE_EDGE_PROPERTY(right, Right, Position, YGEdgeRight)
YG_VALUE_EDGE_PROPERTY(bottom, Bottom, Position, YGEdgeBottom)
YG_VALUE_EDGE_PROPERTY(start, Start, Position, YGEdgeStart)
YG_VALUE_EDGE_PROPERTY(end, End, Position, YGEdgeEnd)
YG_VALUE_EDGES_PROPERTIES(margin, Margin)
YG_VALUE_EDGES_PROPERTIES(padding, Padding)

YG_EDGE_PROPERTY(borderLeftWidth, BorderLeftWidth, Border, YGEdgeLeft)
YG_EDGE_PROPERTY(borderTopWidth, BorderTopWidth, Border, YGEdgeTop)
YG_EDGE_PROPERTY(borderRightWidth, BorderRightWidth, Border, YGEdgeRight)
YG_EDGE_PROPERTY(borderBottomWidth, BorderBottomWidth, Border, YGEdgeBottom)
YG_EDGE_PROPERTY(borderStartWidth, BorderStartWidth, Border, YGEdgeStart)
YG_EDGE_PROPERTY(borderEndWidth, BorderEndWidth, Border, YGEdgeEnd)
YG_EDGE_PROPERTY(borderWidth, BorderWidth, Border, YGEdgeAll)

YG_AUTO_VALUE_PROPERTY(width, Width)
YG_AUTO_VALUE_PROPERTY(height, Height)
YG_VALUE_PROPERTY(minWidth, MinWidth)
YG_VALUE_PROPERTY(minHeight, MinHeight)
YG_VALUE_PROPERTY(maxWidth, MaxWidth)
YG_VALUE_PROPERTY(maxHeight, MaxHeight)
YG_PROPERTY(CGFloat, aspectRatio, AspectRatio)

#pragma mark - Layout and Sizing

- (YGDirection)resolvedDirection {
  return YGNodeLayoutGetDirection(self.node);
}

- (void)applyLayout {
  [self calculateLayoutWithSize:self.view.bounds.size];
  YGApplyLayoutToViewHierarchy(self.node, (CGPoint){.x = 0, .y = 0}, NO);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin {
  [self calculateLayoutWithSize:self.view.bounds.size];
  YGApplyLayoutToViewHierarchy(self.node, (CGPoint){.x = 0, .y = 0}, preserveOrigin);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
               dimensionFlexibility:
                   (YGDimensionFlexibility)dimensionFlexibility {
  CGSize size = self.view.bounds.size;
  if (dimensionFlexibility & YGDimensionFlexibilityFlexibleWidth) {
    size.width = YGUndefined;
  }
  if (dimensionFlexibility & YGDimensionFlexibilityFlexibleHeight) {
    size.height = YGUndefined;
  }
  [self calculateLayoutWithSize:size];
  YGApplyLayoutToViewHierarchy(self.node, (CGPoint){.x = 0, .y = 0}, preserveOrigin);
}

- (CGSize)intrinsicSize {
  const CGSize constrainedSize = {
      .width = YGUndefined,
      .height = YGUndefined,
  };
  return [self calculateLayoutWithSize:constrainedSize];
}

- (CGSize)calculateLayoutWithSize:(CGSize)size {
  NSAssert([NSThread isMainThread], @"Yoga calculation must be done on main.");
//  NSAssert(self.isEnabled, @"Yoga is not enabled for this view.");

  // If we don't have a view then we should have set children on the node already.
//  if (self.view != nil) {
//    YGAttachNodesFromViewHierachy(self.view);
//  }

  const YGNodeRef node = self.node;
  YGNodeCalculateLayout(
      node, size.width, size.height, YGNodeStyleGetDirection(node));

  return (CGSize){
      .width = YGNodeLayoutGetWidth(node),
      .height = YGNodeLayoutGetHeight(node),
  };
}

#pragma mark - Private

static YGSize YGMeasure(
    YGNodeRef node,
    float width,
    YGMeasureMode widthMode,
    float height,
    YGMeasureMode heightMode) {
  const CGFloat constrainedWidth =
      (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
  const CGFloat constrainedHeight =
      (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : height;

  __YGNodeContext* ctx = (__bridge __YGNodeContext*)YGNodeGetContext(node);
  CGSize sizeThatFits = CGSizeZero;

  if (ctx.view != nil) {
    // The default implementation of sizeThatFits: returns the existing size of
    // the view. That means that if we want to layout an empty UIView, which
    // already has got a frame set, its measured size should be CGSizeZero, but
    // UIKit returns the existing size.
    //
    // See https://github.com/facebook/yoga/issues/606 for more information.
    if (!ctx.view.yoga.isUIView || [ctx.view.subviews count] > 0) {
      sizeThatFits = [ctx.view sizeThatFits:(CGSize){
                                            .width = constrainedWidth,
                                            .height = constrainedHeight,
                                        }];
    }
  } else if (ctx.measure != nil) {
    sizeThatFits = ctx.measure((CGSize){
      .width = constrainedWidth,
      .height = constrainedHeight
    });
  }
  

  return (YGSize){
      .width = YGSanitizeMeasurement(
          constrainedWidth, sizeThatFits.width, widthMode),
      .height = YGSanitizeMeasurement(
          constrainedHeight, sizeThatFits.height, heightMode),
  };
}

static CGFloat YGSanitizeMeasurement(
    CGFloat constrainedSize,
    CGFloat measuredSize,
    YGMeasureMode measureMode) {
  CGFloat result;
  if (measureMode == YGMeasureModeExactly) {
    result = constrainedSize;
  } else if (measureMode == YGMeasureModeAtMost) {
    result = MIN(constrainedSize, measuredSize);
  } else {
    result = measuredSize;
  }

  return result;
}

static BOOL YGNodeHasExactSameChildren(
    const YGNodeRef node,
    NSArray<UIView*>* subviews) {
  if (YGNodeGetChildCount(node) != subviews.count) {
    return NO;
  }

  for (int i = 0; i < subviews.count; i++) {
    if (YGNodeGetChild(node, i) != subviews[i].yoga.node) {
      return NO;
    }
  }

  return YES;
}

static void YGRemoveAllChildren(const YGNodeRef node) {
  if (node == NULL) {
    return;
  }

  YGNodeRemoveAllChildren(node);
}

static CGFloat YGRoundPixelValue(CGFloat value) {
  static CGFloat scale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^() {
    scale = [UIScreen mainScreen].scale;
  });

  return roundf(value * scale) / scale;
}

// TODO - need to update this to pass down frames from non-view nodes
static void YGApplyLayoutToViewHierarchy(YGNodeRef node, CGPoint offset, BOOL preserveOrigin) {
  NSCAssert(
      [NSThread isMainThread],
      @"Framesetting should only be done on the main thread.");

  const UIView* view = ((__bridge __YGNodeContext*)YGNodeGetContext(node)).view;

  const CGPoint topLeft = {
      YGNodeLayoutGetLeft(node),
      YGNodeLayoutGetTop(node),
  };

  const CGPoint bottomRight = {
      topLeft.x + YGNodeLayoutGetWidth(node),
      topLeft.y + YGNodeLayoutGetHeight(node),
  };
  
  CGPoint nodeOffset = (CGPoint){
    .x = YGRoundPixelValue(topLeft.x + offset.x),
    .y = YGRoundPixelValue(topLeft.y + offset.y),
  };

  if (view != nil) {
    const CGPoint origin = preserveOrigin ? view.frame.origin : CGPointZero;
    view.frame = (CGRect){
        .origin =
            {
                .x = YGRoundPixelValue(nodeOffset.x + origin.x),
                .y = YGRoundPixelValue(nodeOffset.y + origin.y),
            },
        .size =
            {
                .width = YGRoundPixelValue(bottomRight.x) -
              YGRoundPixelValue(topLeft.x),
                .height = YGRoundPixelValue(bottomRight.y) -
              YGRoundPixelValue(topLeft.y),
            },
    };
    nodeOffset = CGPointZero;
  }
  

  int childCount = YGNodeGetChildCount(node);
  if (childCount > 0) {
    for (UInt32 i = 0; i < childCount; i++) {
      YGApplyLayoutToViewHierarchy(YGNodeGetChild(node, i), nodeOffset, NO);
    }
  }
}

- (void)setMeasure:(YGLayoutMeasureFunc)measure {
  _ctx.measure = measure;
}

- (YGLayoutMeasureFunc)measure {
  return _ctx.measure;
}

- (void)insertChildLayout:(YGLayout *)child atIndex:(NSInteger)index {
  if (YGNodeGetParent(child.node) == self.node) {
    return;
  }
  
  // Apparently UIKit removes the view from the parent w/o calling
  // removeFromSuperview.
  YGNodeRef maybeParent = YGNodeGetParent(child.node);
  if (maybeParent) {
    YGNodeRemoveChild(maybeParent, child.node);
    if (YGNodeGetChildCount(maybeParent) == 0) {
      YGNodeSetMeasureFunc(maybeParent, YGMeasure);
    }
  }
  
  if (YGNodeHasMeasureFunc(self.node)) {
    YGNodeSetMeasureFunc(self.node, NULL);
  }
  
  [self.childrenSet addObject:child];
  YGNodeInsertChild(self.node, child.node, (int)index);
}

- (void)exchangeChildLayoutAtIndex:(NSInteger)indexA withLayoutAtIndex:(NSInteger)indexB {
  YGNodeRef childA = YGNodeGetChild(self.node, (int)indexA);
  YGNodeRef childB = YGNodeGetChild(self.node, (int)indexB);
  
  YGNodeSwapChild(self.node, childA, (int)indexB);
  YGNodeSwapChild(self.node, childB, (int)indexA);
}

- (void)removeChildLayout:(YGLayout*) child {
  if (YGNodeGetParent(child.node) != self.node) {
    return;
  }
  
  [self.childrenSet removeObject:child];
  YGNodeRemoveChild(self.node, child.node);
  if (YGNodeGetChildCount(self.node) == 0) {
    YGNodeSetMeasureFunc(self.node, YGMeasure);
  }
}

- (void)reparentChildrenToNewParent:(YGLayout *)newParent {
  int childCount = YGNodeGetChildCount(self.node);
  if (childCount > 0) {
    YGNodeSetMeasureFunc(newParent.node, NULL);
    
    for (int i = 0; i < childCount; i++) {
      YGNodeRef child = YGNodeGetChild(self.node, 0);
      YGNodeRemoveChild(self.node, child);
      YGNodeInsertChild(newParent.node, child, i);
    }
    
    newParent.childrenSet = self.childrenSet;
    self.childrenSet = [[NSMutableSet alloc] init];
    
    YGNodeSetMeasureFunc(self.node, YGMeasure);
  }
}

- (id)copyWithZone:(NSZone *)zone {
  YGLayout* copy = [[YGLayout allocWithZone:zone] init];
  copy.ctx = [self.ctx copy];
  copy.node = YGNodeClone(self.node);
  copy.childrenSet = [[NSMutableSet alloc] init];
  // Children aren't deep copied, removing them avoids
  // any chance of accidentally updating the initial tree.
  YGNodeRemoveAllChildren(copy.node);
  return copy;
}

- (NSSet<YGLayout *> *)children {
  return [NSSet setWithSet:self.childrenSet];
}

@end
