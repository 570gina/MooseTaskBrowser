Class {
	#name : #MooseTaskRunningTest,
	#superclass : #MooseTaskTests,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #preparation }
MooseTaskRunningTest >> addTasks [
	ui addButton performAction.
	ui repositoryView listPresenter selectAll.
	ui repositoryView window triggerOkAction
]

{ #category : #preparation }
MooseTaskRunningTest >> setUp [
	super setUp.
	ui := MooseTaskBrowser on: MooseJob new.
	ui repositoryView setList: taskRepo tasks.
	"ui openWithSpec"
]

{ #category : #tests }
MooseTaskRunningTest >> testAJobAllowToReceiveArgument [
	self addTasks.
	ui model input: 1.
	ui runButton performAction.
	self
		assert: ui model steps last output
		equals: ui model input asInteger + 8
]
