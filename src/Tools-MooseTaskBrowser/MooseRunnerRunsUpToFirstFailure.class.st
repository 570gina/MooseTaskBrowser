Class {
	#name : #MooseRunnerRunsUpToFirstFailure,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

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
				ifTrue: [
					^ self ].
			aJob output: step output.
			step output ]
]
