Class {
	#name : #MooseRunnerTest,
	#superclass : #MooseJobRunTimeTest,
	#instVars : [
		'debug',
		'lastRunning'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #running }
MooseRunnerTest >> run [
	[ jobRuntime runWithUpdatingBlock: [  ] ]
		on: Error
		do: [
			debug := true ]
]

{ #category : #setup }
MooseRunnerTest >> setUp [
	super setUp.
	debug := false.
]

{ #category : #tests }
MooseRunnerTest >> testRunAccordingError [
	jobRuntime runner: MooseRunnerRunsAccordingError new.
	jobRuntime addTasks: {self mooseTaskErrorTask}.
	self run.
	self deny: debug.
	jobRuntime runner: MooseRunnerRunsAccordingError new.
	jobRuntime addTasks: {self errorTask}.
	self run.
	self assert: debug.	
]

{ #category : #tests }
MooseRunnerTest >> testRunAll [
	jobRuntime runner: MooseRunnerRunsAll new.
		tasks
		add: self returnFifty;
		add: self mooseTaskErrorTask;
		add: self errorTask.
	jobRuntime
		addTasks: tasks.
	self run.
	self deny: debug.
	self assert: (jobRuntime tasks allSatisfy: #hasRun)
]

{ #category : #tests }
MooseRunnerTest >> testRunUpToFirstFailure [
	jobRuntime runner: MooseRunnerRunsUpToFirstFailure new.
	tasks
		add: self returnFifty;
		add: self mooseTaskErrorTask;
		add: self errorTask.
	jobRuntime addTasks: tasks.
	self run.
	self deny: debug.
	lastRunning := (jobRuntime tasks reject: [ :task | task hasRun not ])
		last.
	self assert: (lastRunning error isKindOf: MooseTaskError)
]
