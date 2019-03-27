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
	"task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: self createBlockHandle
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 4'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 5'.
			v input + 2 ]
		description: 'a description 5'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 6'.
			v input + 2 ]
		description: 'a description 6'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 7'.
			v input + 2 ]
		description: 'a description 7'
		length: 0.	
	taskRepo addTask: task."
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: v description , ' is running.'.
			v input asInteger + 2 ]
		description: 'First task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: v description , ' is running.'.
			v input asInteger + 2 ]
		description: 'Second task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: v description , ' is running.'.
			v input asInteger + 2 ]
		description: 'Third task'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: v description , ' is running.'.
			v input asInteger + 2 ]
		description: 'Last task'
		length: 0.
	taskRepo addTask: task
]
