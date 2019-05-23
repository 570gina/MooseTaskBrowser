Class {
	#name : #MooseJobRunTimeTest,
	#superclass : #MooseJobTest,
	#instVars : [
		'jobRuntime'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #setup }
MooseJobRunTimeTest >> setUp [
	super setUp.
	jobRuntime := MooseJobRuntime new
			runner: job runner;
		logger: job logger
]

{ #category : #tests }
MooseJobRunTimeTest >> testEachTaskAllowsToReceiveTheOutputOfPreviousTaskAsInput [
	tasks
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	jobRuntime
		addTasks: tasks;

		runWithUpdatingBlock: [  ].
	self assert: jobRuntime output equals: 60
]

{ #category : #tests }
MooseJobRunTimeTest >> testInputAndOutputOfAllTasksAreNilIfTheRunTimeNeverRun [
	tasks
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	jobRuntime
		addTasks: tasks.
	jobRuntime tasks
		do: [ :item | 
			self assert: item input isNil.
			self assert: item output isNil ]
]
