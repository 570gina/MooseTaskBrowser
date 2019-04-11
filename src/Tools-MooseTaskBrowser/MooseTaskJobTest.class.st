Class {
	#name : #MooseTaskJobTest,
	#superclass : #TestCase,
	#instVars : [
		'job',
		'steps'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #addMooseTasks }
MooseTaskJobTest >> minusTen [
	^ (MooseCustomTask new
		with: [ :v | v input asInteger - 10 ]
		description: 'Minus 10'
		length: 0) asTaskRuntime
]

{ #category : #addMooseTasks }
MooseTaskJobTest >> plusTwenty [
	^ (MooseCustomTask new
		with: [ :v | v input asInteger + 20 ]
		description: 'Plus 20'
		length: 0) asTaskRuntime
]

{ #category : #addMooseTasks }
MooseTaskJobTest >> returnFifty [
	^ (MooseCustomTask new with: [ :v | 50 ] description: 'Return 50' length: 0)
		asTaskRuntime
]

{ #category : #setup }
MooseTaskJobTest >> setUp [
	job := MooseJob new.
	steps := OrderedCollection new
]

{ #category : #tests }
MooseTaskJobTest >> testAJobAllowsToReceiveInput [
	steps
		add:
			self plusTwenty.
	(job
		tasks: steps;
		input: 10;
		runWithUpdatingBlock: [  ])
		addSuccessCallback: [ :result | self assert: result equals: 30 ]
]

{ #category : #tests }
MooseTaskJobTest >> testEachTaskOfAJobAllowsToReceiveTheOutputOfPreviousTaskAsInput [
	steps
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	(job
		tasks: steps;
		runWithUpdatingBlock: [  ])
		addSuccessCallback: [ :result | 
			self assert: result equals: 60.
			 ]
]

{ #category : #tests }
MooseTaskJobTest >> testInputAndOutputOfTheTasksAreNilIfTheTasksNeverRun [
	steps
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	steps
		do: [ :item | 
			self assert: item input isNil.
			self assert: item output isNil ]
]

{ #category : #tests }
MooseTaskJobTest >> testSeparatingAComposedTaskProducesSomeNewSingleTasks [
	steps
		add: self minusTen;
		add: self plusTwenty.
	job tasks: steps.
	self assert: (job tasks first isKindOf: MooseTaskRuntime).
	job combineTasks: steps asArray.
	self assert: (job tasks first isKindOf: MooseTaskComposedRuntime).
	job separateTask:  job tasks first.
	self deny: (job tasks first isKindOf: MooseTaskComposedRuntime).
	self assert: (job tasks first isKindOf: MooseTaskRuntime)
]
