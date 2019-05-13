Class {
	#name : #MooseRunnerRunsAccordingError,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseRunnerRunsAccordingError >> printOn: aStream [
	aStream nextPutAll: 'Run According Error'
]

{ #category : #running }
MooseRunnerRunsAccordingError >> runJob: aJob withUpdatingBlock: aBlock [
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			self runTask: step input: result.
			step hasRun: true.
			"aJob errorState: step."
			aBlock value.
			aJob output: step output.
			step output ]
]

{ #category : #running }
MooseRunnerRunsAccordingError >> runTask: step input: result [
	[ step run: result ]
		on: MooseTaskError
		do: [ ^ step ]
]
