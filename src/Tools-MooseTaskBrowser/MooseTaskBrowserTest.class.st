Class {
	#name : #MooseTaskBrowserTest,
	#superclass : #TestCase,
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

{ #category : #running }
MooseTaskBrowserTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	| task taskRepo |
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 4'
		length: 0.
	ui := MooseTaskBrowser new.
	taskRepo addTask: task.
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
