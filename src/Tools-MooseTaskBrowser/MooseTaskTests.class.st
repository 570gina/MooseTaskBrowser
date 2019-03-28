Class {
	#name : #MooseTaskTests,
	#superclass : #TestCase,
	#instVars : [
		'taskRepo',
		'task'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #running }
MooseTaskTests >> body: v [
	(1 to: 20000000)
		do: [ :i | true ]
		displayingProgress:
			'running task: ' , v description , ' with context '
				, v input asString.
	100 atRandom.
]

{ #category : #running }
MooseTaskTests >> createBlockHandle [
	^ [ :v | (MessageSend receiver: MooseTaskTests new selector: #body:) value: v ]
]

{ #category : #running }
MooseTaskTests >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	taskRepo := MooseTaskRepository new.

	task := MooseCustomTask new
		with: [ :v | v input asInteger + 2 ]
		description: 'First task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | v input asInteger + 2 ]
		description: 'Second task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | v input asInteger + 2 ]
		description: 'Third task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | v input asInteger + 2 ]
		description: 'Last task'
		length: 0.
	taskRepo addTask: task
]
