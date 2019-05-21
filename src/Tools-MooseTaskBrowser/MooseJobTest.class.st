Class {
	#name : #MooseJobTest,
	#superclass : #TestCase,
	#instVars : [
		'job',
		'tasks'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #addMooseTasks }
MooseJobTest >> errorTask [
	^ MooseCustomTask new
		with: [ :v | 1 / 0 ]
		description: 'Zero Divide'
		length: 0
]

{ #category : #addMooseTasks }
MooseJobTest >> minusTen [
	^ MooseCustomTask new
		with: [ :v | v input asInteger - 10 ]
		description: 'Minus 10'
		length: 0
]

{ #category : #addMooseTasks }
MooseJobTest >> plusTwenty [
	^ MooseCustomTask new
		with: [ :v | v input asInteger + 20 ]
		description: 'Plus 20'
		length: 0
]

{ #category : #addMooseTasks }
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
MooseJobTest >> testSeparatingAComposedTaskProducesSomeNewSingleTasks [
	tasks
		add: self minusTen;
		add: self plusTwenty.
	job tasks: tasks.
	self assert: (job tasks first isKindOf: MooseCustomTask).
	job combineTasks: tasks asArray.
	self assert: (job tasks first isKindOf: MooseComposedTask).
	job separateTask: job tasks first.
	self deny: (job tasks first isKindOf: MooseComposedTask).
	self assert: (job tasks first isKindOf: MooseCustomTask)
]
