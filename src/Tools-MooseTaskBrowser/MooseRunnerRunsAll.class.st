Class {
	#name : #MooseRunnerRunsAll,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #printing }
MooseRunnerRunsAll >> printOn: aStream [
	aStream nextPutAll: 'Run All'
]
