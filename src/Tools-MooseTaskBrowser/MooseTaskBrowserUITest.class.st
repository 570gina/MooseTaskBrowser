Class {
	#name : #MooseTaskBrowserUITest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'job'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #adding }
MooseTaskBrowserUITest >> addTasks [
	presenter mooseJobPresenter addButton performAction.
	presenter taskAdditionPresenter list selectAll.
	presenter taskAdditionPresenter window triggerOkAction
]

{ #category : #adding }
MooseTaskBrowserUITest >> runCurrentJob [
	self addTasks.
	presenter run
]

{ #category : #setup }
MooseTaskBrowserUITest >> setUp [
	| tasks |
	job := MooseJob new.
	presenter := MooseTaskBrowser on: job.
	tasks := OrderedCollection new.
	1 to: 2
		do: [ :i | 
			tasks
				add:
					(MooseCustomTask new
						with: [ :v | v input asInteger + 2 ]
						description: '+2 Task'
						length: 0) ].
	presenter taskAdditionPresenter list items: tasks
]

{ #category : #tests }
MooseTaskBrowserUITest >> testLogView [
	presenter logView text isEmpty.
	self runCurrentJob.
	self assert: presenter logView text isNotEmpty.
	self
		assert: (presenter logView text includesSubstring: 'Begin: [Job]').
			self
		assert: (presenter logView text includesSubstring: 'End: [Job]')
]
