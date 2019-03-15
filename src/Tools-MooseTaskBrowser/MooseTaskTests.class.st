Class {
	#name : #MooseTaskTests,
	#superclass : #TestCase,
	#instVars : [
		'taskRepo',
		'task'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #running }
MooseTaskTests >> body: v [
	v context: 100 atRandom.
	(1 to: 20000000)
		do: [ :i | true ]
		displayingProgress:
			'running task: ' , v description , ' with context '
				, v context asString.
	v context + 1
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
	task := MooseCustomTaskWithContext new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTaskWithContext new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTaskWithContext new
		with: self createBlockHandle
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTaskWithContext new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 4'
		length: 0.
	task := MooseCustomTaskWithContext new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress:
					'running task: ' , v description , ' with context '
						, v context asString.
			v context + 1 ]
		description: 'a description 5'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTaskWithContext new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress:
					'running task: ' , v description , ' with context '
						, v context asString.
			v context + 1 ]
		description: 'a description 6'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTaskWithContext new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress:
					'running task: ' , v description , ' with context '
						, v context asString.
			v context + 1 ]
		description: 'a description 7'
		length: 0.
	taskRepo addTask: task
]
