"
I'm a runner.
When the first error occurs, I will
-record the error
-stop running
"
Class {
	#name : #MooseRunnerRunsUpToFirstFailure,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #accessing }
MooseRunnerRunsUpToFirstFailure >> order [
	^ 3
]

{ #category : #printing }
MooseRunnerRunsUpToFirstFailure >> printOn: aStream [
	aStream nextPutAll: 'Run Up To First Failure'
]

{ #category : #running }
MooseRunnerRunsUpToFirstFailure >> runJob: aJob withUpdatingBlock: aBlock withErrorLogger: aLogger [
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			self runTask: step input: result.
						step hasRun: true.
			aLogger addText: step printState.
			aBlock value.
			step isError
				ifTrue: [ ^ self ].
			aJob output: step output.
			step output ]
]
