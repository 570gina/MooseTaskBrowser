Class {
	#name : #MooseRunnerRunsAll,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #printing }
MooseRunnerRunsAll >> printOn: aStream [
	aStream nextPutAll: 'Run All'
]

{ #category : #running }
MooseRunnerRunsAll >> runJob: aJob withUpdatingBlock: aBlock [
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			self runTask: step input: result.
			step hasRun: true.
			"	aJob errorState: step."
			aBlock value.
			aJob output: step output.
			step output ]
]
