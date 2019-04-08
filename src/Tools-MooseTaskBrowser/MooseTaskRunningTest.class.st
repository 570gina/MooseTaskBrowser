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
MooseTaskRunningTest >> errorTask [
	task := MooseCustomTask new
		with: [ :v | 1/0. ]
		description: 'Error task'
		length: 0.
	taskRepo addTask: task.
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
	ui model run.
	self
		assert: ui model steps last output
		equals: ui model input asInteger + 8.
	ui model input: 2.
	ui model run.
	self
		assert: ui model steps last output
		equals: ui model input asInteger + 8
]
