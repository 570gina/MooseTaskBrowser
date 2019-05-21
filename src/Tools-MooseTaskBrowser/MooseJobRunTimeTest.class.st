Class {
	#name : #MooseJobRunTimeTest,
	#superclass : #MooseJobTest,
	#instVars : [
		'file'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #tests }
MooseJobRunTimeTest >> testEachTaskOfAJobAllowsToReceiveTheOutputOfPreviousTaskAsInput [
	steps
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	(job
		tasks: steps;
		runWithUpdatingBlock: [  ])
		addSuccessCallback: [ :result | self assert: result equals: 60 ]
]

{ #category : #tests }
MooseJobRunTimeTest >> testInputAndOutputOfTheTasksAreNilIfTheTasksNeverRun [
	steps
		add: self returnFifty;
		add: self minusTen;
		add: self plusTwenty.
	steps
		do: [ :item | 
			self assert: item input isNil.
			self assert: item output isNil ]
]
