Class {
	#name : #MooseTaskBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #running }
MooseTaskBrowserTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	| task tasks |
	tasks := OrderedCollection new.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 1'
		length: 0.
	tasks add: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 2'
		length: 0.
	tasks add: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 3'
		length: 0.
	tasks add: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 60000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: 'a description 4'
		length: 0.
	tasks add: task.
		ui := MooseTaskBrowser new.
	ui setTasks: tasks
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonEnabledWhenSelectedTask [
	ui listPresenter setIndex: 1.
	self assert: ui runButton enabled.
	ui listPresenter setIndex: 2.
	self assert: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonNotEnabledWhenNoSelectedTask [
	ui listPresenter resetSelection.
	self deny: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveDownWhenDownButtonClicked [
	| task |
	ui listPresenter setIndex: 1.
	task := ui selectedTask.
	ui downButton performAction.
	self assert: 2 equals: ui listPresenter getIndex.
	self assert: task equals: ui listPresenter selectedItem
]

{ #category : #tests }
MooseTaskBrowserTest >> testselectedTaskMoveUpWhenUpButtonClicked [
	| task |
	ui listPresenter setIndex: 2.
	task := ui selectedTask.
	ui upButton performAction.
	self assert: 1 equals: ui listPresenter getIndex.
	self assert: task equals: ui listPresenter selectedItem
]
