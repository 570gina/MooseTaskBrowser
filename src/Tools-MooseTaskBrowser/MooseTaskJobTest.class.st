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
		steps: steps;
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
		steps: steps;
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
	job steps: steps.
	self assert: (job steps first isKindOf: MooseTaskRuntime).
	job combineSteps: steps asArray.
	self assert: (job steps first isKindOf: MooseTaskComposedRuntime).
	job separateStep:  job steps first.
	self deny: (job steps first isKindOf: MooseTaskComposedRuntime).
	self assert: (job steps first isKindOf: MooseTaskRuntime)
]
