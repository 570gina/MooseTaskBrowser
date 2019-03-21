Class {
	#name : #MooseTaskBrowserTest,
	#superclass : #MooseTaskTests,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
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
	ui := MooseTaskBrowser  on: MooseJob new.
	ui repositoryView setList: taskRepo tasks
	"ui openWithSpec"
]

{ #category : #tests }
MooseTaskBrowserTest >> testAddTasksWhenTasksIsSelectedAndOkButtonIsClicked [
	| oldSize |
	oldSize := ui taskTreePresenter roots size.
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction.
	self
		assert: (ui taskTreePresenter roots size + oldSize)
		equals: ui repositoryView listPresenter listItems size
]

{ #category : #tests }
MooseTaskBrowserTest >> testNotAddTasksWhenTasksIsSelectedAndCancelButtonIsClicked [
	| oldSize |
	oldSize := ui taskTreePresenter roots size.
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerCancelAction.
	self assert: ui taskTreePresenter roots size equals: oldSize.
	self
		deny: ui taskTreePresenter roots
		equals: ui repositoryView listPresenter listItems
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
MooseTaskBrowserTest >> testRunButtonEnabledWhenTaskListIsNotEmpty [
	self addTasks.

	self assert: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonNotEnabledWhenTaskListIsEmpty [
	self deny: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testUpButtonNotEnabledWhenTopItemIsSelected [
	| size |
	self addTasks.
	size := ui treePresenter listSize.
	ui treePresenter setIndex: size.
	self deny: ui downButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveDownWhenDownButtonIsClicked [
	| temp |
	ui taskTreePresenter setIndex: 1.
	temp := ui selectedTask.
	ui downButton performAction.
	self assert: 2 equals: ui taskTreePresenter getIndex.
	self assert: task equals: ui taskTreePresenter selectedItem
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveUpWhenUpButtonIsClicked [
	| temp |
	self addTasks.
	ui taskTreePresenter setIndex: 2.
	temp := ui taskTreePresenter selectedItem.
	ui upButton performAction.
	self assert: 1 equals: ui taskTreePresenter getIndex.
	self assert: task equals: ui taskTreePresenter selectedItem
]
