//
//  EVTabSearchWindowController.h
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class EJVFilterListWindowController;

@protocol EJVFilterListWindowControllerDelegate <NSObject>

- (void)filterListWindowControllerDidDismiss:(EJVFilterListWindowController *)dialog;
    
@optional
    
// By default, the filter dialog does not respond to the close action (⌘-W). However, implementing this method gives the
// delegate the opportunity to perform a custom action in response to the close command (e.g. actually closing the dialog)
- (void)filterListWindowControllerHandleCloseAction:(EJVFilterListWindowController *)controller;

@end

@interface EJVFilterListWindowController : NSWindowController

- (instancetype)initWithArrayController:(NSArrayController *)controller
                   filterPredicateBlock:(NSPredicate *(^)(NSString * searchText))filterPredicateBlock
                          cellViewBlock:(NSTableCellView *(^)(EJVFilterListWindowController * dialog, NSTableCellView * _Nullable reusingView, id object))cellViewBlock;

// Optional delegate that will be notified when the dialog is dismissed
@property (nonatomic, weak) id <EJVFilterListWindowControllerDelegate> delegate;

// Default value: 44.0
@property (nonatomic) CGFloat rowHeight;

// If set, the search text will be cleared whenever the dialog is dismissed (whether by committing a selection, or not)
// Defaults to NO
@property (nonatomic) BOOL clearsSearchTextOnDismiss;

// KVO observable
@property (nonatomic, readonly) NSString *searchText;

@property (nullable, weak) id target;
@property (nullable) SEL selectionCommittedAction;
    
// Dismisses the dialog
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
