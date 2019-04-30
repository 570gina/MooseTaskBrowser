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
		'runtimeJobs'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #action }
MooseJob >> addTasks: aCollection [
	"Add a collection of tasks instances of MooseCustomTask (or object with interfaces understanding asRuntimeTask and force"

	tasks addAll: aCollection
]

{ #category : #action }
MooseJob >> combineTasks: aCollection [
	| firstTaskIndex combination |
	firstTaskIndex := tasks indexOf: aCollection first.
	aCollection do: [ :i | self removeTask: i ].
	combination := aCollection allButFirst
		inject: aCollection first
		into: [ :acc :each | acc combineWith: each ].
	tasks add: combination beforeIndex: firstTaskIndex
]

{ #category : #initialization }
MooseJob >> initialize [
	super initialize.
	tasks := OrderedCollection new
]

{ #category : #accessing }
MooseJob >> input [
	^ input 
]

{ #category : #accessing }
MooseJob >> input: aValue [
	input := aValue
]

{ #category : #'organizing steps' }
MooseJob >> move: aModifier theTask: aTask [
	| index |
	index := tasks indexOf: aTask.
	tasks swap: index with: index + aModifier
]

{ #category : #action }
MooseJob >> removeTask: aStep [
	tasks remove: aStep
]

{ #category : #action }
MooseJob >> runWithUpdatingBlock: aBlock [
	runtimeJobs := (input
		ifNil: [ {nil} ]
		ifNotNil: [ input splitOn: ' ' ])
		collect: [ :i | 
			MooseJobRuntime new
				input: i;
				addTasks: tasks ].
	aBlock value.
	runtimeJobs do: [ :job | job runWithUpdatingBlock: aBlock ]
]

{ #category : #accessing }
MooseJob >> runtimeJobs [
	^ runtimeJobs
]

{ #category : #action }
MooseJob >> separateTask: aStep [
	| index |
	index := tasks indexOf: aStep.
	self removeTask: aStep.
	aStep tasks do: [ :i | tasks add: i beforeIndex: index. index := index + 1 ]
]

{ #category : #action }
MooseJob >> separateTasks: aCollection [
	aCollection do: [ :i | self separateTask: i ]
]

{ #category : #accessing }
MooseJob >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseJob >> tasks: aCollection [
	tasks := aCollection
]
