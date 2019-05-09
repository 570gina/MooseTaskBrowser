Class {
	#name : #MooseJobRunnerRunUpToFirstFailure,
	#superclass : #MooseJobAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #printing }
MooseJobRunnerRunUpToFirstFailure >> printOn: aStream [
	aStream nextPutAll: 'Run Up To First Failure'
]
