Class {
	#name : #MooseTaskBrowserWidgetsTest,
	#superclass : #MooseTaskTests,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #preparation }
MooseTaskBrowserWidgetsTest >> addTasks [
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction
]

{ #category : #preparation }
MooseTaskBrowserWidgetsTest >> setUp [
	super setUp.
	ui := MooseTaskBrowser on: MooseJob new.
	ui repositoryView setList: taskRepo tasks.
	".ui openWithSpec"
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testAddTasksWhenTasksIsSelectedAndOkButtonIsClicked [
	| oldSize |
	oldSize := ui stepsDatasource elements size.
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction.
	self
		assert: ui stepsDatasource elements size + oldSize
		equals: ui repositoryView listPresenter listItems size.
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testCheckBoxEnabledWhenTaskListIsNotEmpty [
	self addTasks.
	self assert: ui checkBox enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testCheckBoxNotEnabledWhenTaskListIsNotEmpty [
	self deny: ui checkBox enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testDownButtonNotEnabledWhenBottomItemIsSelected [
	self addTasks.
	ui stepsDatasource
		setSelectedItems: (Array with: ui model steps first).
	self deny: ui upButton enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testNotAddTasksWhenTasksIsSelectedAndCancelButtonIsClicked [
	| oldSize |
	oldSize := ui stepsDatasource elements size.
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerCancelAction.
	self assert: ui stepsDatasource elements size equals: oldSize.

]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testRepositoryIsDisplayedWhenAddButtonIsClicked [
	self assert: ui repositoryView isDisplayed not.
	ui addButton performAction.
	self assert: ui repositoryView isDisplayed.
	ui repositoryView window close.
	self deny: ui repositoryView isDisplayed.
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testRunButtonEnabledWhenTaskListIsNotEmpty [
	self addTasks.

	self assert: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testRunButtonNotEnabledWhenTaskListIsEmpty [
	self deny: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testUpButtonNotEnabledWhenTopItemIsSelected [
	self addTasks.
	ui stepsDatasource
		setSelectedItems: (Array with: ui model steps last).
	self deny: ui downButton enabled
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testselectedTaskMoveDownWhenDownButtonIsClicked [
	| temp |
	self addTasks.
	ui stepsDatasource
		setSelectedItems: (Array with: ui model steps first).
	temp := ui stepsDatasource selectedItems.
	ui downButton performAction.
	self assert: temp equals: (Array with: ui model steps second).
	self assert: temp equals: ui stepsDatasource selectedItems.
]

{ #category : #tests }
MooseTaskBrowserWidgetsTest >> testselectedTaskMoveUpWhenUpButtonIsClicked [
	| temp |
	self addTasks.
	ui stepsDatasource
		setSelectedItems: (Array with: ui model steps second).
	temp := ui stepsDatasource selectedItems.
	ui upButton performAction.
	self assert: temp equals: (Array with: ui model steps first).
	self assert: temp equals: ui stepsDatasource selectedItems
]
