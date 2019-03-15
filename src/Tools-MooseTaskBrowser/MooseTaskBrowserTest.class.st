Class {
	#name : #MooseTaskBrowserTest,
	#superclass : #MooseTaskTests,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #preparation }
MooseTaskBrowserTest >> addTasks [
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction
]

{ #category : #preparation }
MooseTaskBrowserTest >> setUp [ 
	super setUp.
	ui := MooseTaskBrowser new.
	ui repositoryView setList: taskRepo tasks
	"ui openWithSpec"
]

{ #category : #tests }
MooseTaskBrowserTest >> testAddTasksWhenTasksIsSelectedAndOkButtonIsClicked [
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction.
	self
		assert: ui listPresenter listItems equals:  ui repositoryView listPresenter listItems
]

{ #category : #tests }
MooseTaskBrowserTest >> testNotAddTasksWhenTasksIsSelectedAndCancelButtonIsClicked [
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerCancelAction.
	self
		deny: ui listPresenter listItems
		equals: ui repositoryView listPresenter listItems.
]

{ #category : #tests }
MooseTaskBrowserTest >> testRepositoryIsDisplayedWhenAddButtonIsClicked [
	self assert: ui repositoryView isDisplayed not.
	ui addButton performAction.
	self assert: ui repositoryView isDisplayed.
	ui repositoryView window close.
	self deny: ui repositoryView isDisplayed.
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonEnabledWhenSelectedTask [
	self addTasks.
	ui listPresenter setIndex: 1.
	self assert: ui runButton enabled.
	ui listPresenter setIndex: 2.
	self assert: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonNotEnabledWhenNoSelectedTask [
	self addTasks.
	ui listPresenter resetSelection.
	self deny: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testUpButtonNotEnabledWhenTopItemIsSelected [
	| size |
	self addTasks.
	size := ui listPresenter listSize.
	ui listPresenter setIndex: size.
	self deny: ui downButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveDownWhenDownButtonIsClicked [
	| task |
	self addTasks.
	ui listPresenter setIndex: 1.
	task := ui listPresenter selectedItem.
	ui downButton performAction.
	self assert: 2 equals: ui listPresenter getIndex.
	self assert: task equals: ui listPresenter selectedItem
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveUpWhenUpButtonIsClicked [
	| task |
	self addTasks.
	ui listPresenter setIndex: 2.
	task := ui listPresenter selectedItem.
	ui upButton performAction.
	self assert: 1 equals: ui listPresenter getIndex.
	self assert: task equals: ui listPresenter selectedItem
]
