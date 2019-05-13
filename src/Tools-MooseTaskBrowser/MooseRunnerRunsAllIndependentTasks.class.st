Class {
	#name : #MooseRunnerRunsAllIndependentTasks,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #printing }
MooseRunnerRunsAllIndependentTasks >> printOn: aStream [
	aStream nextPutAll: 'Run All Independent Tasks'
]

{ #category : #running }
MooseRunnerRunsAllIndependentTasks >> runJob: aJob withUpdatingBlock: aBlock [
	| last |
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			(step requiresInput and: [ last isNotNil and: [ last isError ] ])
				ifFalse: [ self runTask: step input: result.
					step hasRun: true.
					last:= step  ].
			aBlock value.
			aJob output: step output.
			step output ]
]
