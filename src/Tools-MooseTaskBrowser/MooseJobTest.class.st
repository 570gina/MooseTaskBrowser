Class {
	#name : #MooseJobTest,
	#superclass : #TestCase,
	#instVars : [
		'job',
		'tasks'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #adding }
MooseJobTest >> addTasksToTheJob [
	1 to: 10 do: [ :i | 
		tasks
			add:
				(MooseCustomTask new
					with: [  ]
					description: 'Just a simple task.'
					length: 0) ].job tasks: tasks.
]

{ #category : #adding }
MooseJobTest >> errorTask [
	^ MooseCustomTask new
		with: [  1 / 0 ]
		description: 'Zero Divide'
		length: 0
]

{ #category : #adding }
MooseJobTest >> minusTen [
	^ MooseCustomTask new
		with: [ :v | v input asInteger - 10 ]
		description: 'Minus 10'
		length: 0
]

{ #category : #adding }
MooseJobTest >> mooseTaskErrorTask [
	^ MooseCustomTask new
		with: [ MooseTaskError signal: ' an error '.
	]
		description: 'MooseTaskError'
		length: 0
]

{ #category : #adding }
MooseJobTest >> plusTwenty [
	^ MooseCustomTask new
		with: [ :v | v input asInteger + 20 ]
		description: 'Plus 20'
		length: 0
]

{ #category : #adding }
MooseJobTest >> returnFifty [
	^ MooseCustomTask new
		with: [ :v | 50 ]
		description: 'Return 50'
		length: 0
]

{ #category : #setup }
MooseJobTest >> setUp [
	job := MooseJob new.
	tasks := OrderedCollection new
]

{ #category : #tests }
MooseJobTest >> testAJobAllowsToReceiveMultipleInput [
	tasks add: self plusTwenty.
	job
		tasks: tasks;
		input: '10 20 30';
		runWithUpdatingBlock: [  ].
	self assert: job runtimeJobs size equals: 3.
	self assert: job runtimeJobs first output equals: 30.
	self assert: job runtimeJobs second output equals: 40.
	self assert: job runtimeJobs third output equals: 50
]

{ #category : #tests }
MooseJobTest >> testCombineTasksAndSeparateTask [
	| size |
	self addTasksToTheJob.
	size := job tasks size.
	self
		assert: (job tasks allSatisfy: [ :t | t isKindOf: MooseCustomTask ]).

	"combining all tasks."
	job combineTasks: job tasks asArray.
	self
		assert: (job tasks allSatisfy: [ :t | t isKindOf: MooseComposedTask ]).
	self assert: job tasks size equals: 1.

	"separating the composed task."
	job separateTask: job tasks first.
	self assert: job tasks size equals: size.
	self
		assert: (job tasks allSatisfy: [ :t | t isKindOf: MooseCustomTask ])
]

{ #category : #tests }
MooseJobTest >> testMoveTheTaskDown [
|task|
	self addTasksToTheJob.
	task := job tasks first.
	job move: 1 theTask: task.
	self assert: job tasks second equals:task
]

{ #category : #tests }
MooseJobTest >> testMoveTheTaskUp [
	| task |
	self addTasksToTheJob.
	task := job tasks second.
	job move: -1 theTask: task.
	self assert: job tasks first equals: task
]
