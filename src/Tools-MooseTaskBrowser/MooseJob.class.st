"
I'm a job that manages the execution of tasks. 
I'm managed of list of tasks, usually instances of MooseTaskRuntime.
I'm a model of MooseTaskBrowser. 

See MooseTaskbrowser >> #example2 for an example.


"
Class {
	#name : #MooseJob,
	#superclass : #Object,
	#instVars : [
		'input',
		'tasks',
		'runtimeJobs',
		'runner',
		'stream',
		'logger'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #adding }
MooseJob >> addTasks: aCollectionOfTasks [
	tasks addAll: aCollectionOfTasks
]

{ #category : #action }
MooseJob >> combineTasks: aCollectionOfTasks [
	| firstTaskIndex combination |
	firstTaskIndex := tasks indexOf: aCollectionOfTasks first.
	aCollectionOfTasks do: [ :t | self removeTask: t ].
	combination := aCollectionOfTasks allButFirst
		inject: aCollectionOfTasks first
		into: [ :acc :each | acc combineWith: each ].
	tasks add: combination beforeIndex: firstTaskIndex
]

{ #category : #initialization }
MooseJob >> initialize [
	super initialize.
	tasks := OrderedCollection new.
	logger := MooseLogger new text: ''
]

{ #category : #accessing }
MooseJob >> input [
	^ input 
]

{ #category : #accessing }
MooseJob >> input: aString [
	input := aString
]

{ #category : #accessing }
MooseJob >> logger [ ^logger
]

{ #category : #action }
MooseJob >> move: aModifier theTask: aMooseTask [
	| index |
	index := tasks indexOf: aMooseTask.
	tasks swap: index with: index + aModifier.
	^index + aModifier
]

{ #category : #action }
MooseJob >> removeTask: aMooseTask [
	tasks remove: aMooseTask
]

{ #category : #running }
MooseJob >> runWithUpdatingBlock: aBlock [
		logger text: ''.
	runtimeJobs := (input
		ifNil: [ {nil} ]
		ifNotNil: [ input splitOn: ' ' ])
		collect: [ :i | 
			MooseJobRuntime new
				input: i;
				runner: runner;
				logger: logger;
				addTasks: tasks ].
	runtimeJobs do: [ :job | job runWithUpdatingBlock: aBlock ]
]

{ #category : #accessing }
MooseJob >> runner [ 
	^runner 
]

{ #category : #accessing }
MooseJob >> runner: aRunner [
	runner := aRunner
]

{ #category : #accessing }
MooseJob >> runtimeJobs [
	^ runtimeJobs
]

{ #category : #action }
MooseJob >> separateTask: aMooseTask [
	| index |
	index := tasks indexOf: aMooseTask.
	self removeTask: aMooseTask.
	aMooseTask tasks
		do: [ :i | 
			tasks add: i beforeIndex: index.
			index := index + 1 ]
]

{ #category : #action }
MooseJob >> separateTasks: aCollectionOfTasks [
	aCollectionOfTasks do: [ :i | self separateTask: i ]
]

{ #category : #accessing }
MooseJob >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseJob >> tasks: aCollectionOfTasks [
	tasks := aCollectionOfTasks
]
