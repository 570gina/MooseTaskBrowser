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
MooseRunnerRunsAccordingError >> runTask: step input: result [
	 [ step run: result ]
		on: MooseTaskError
		do: [ ^ step ] 
]