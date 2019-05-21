Class {
	#name : #MooseRunnerRunsAll,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #accessing }
MooseRunnerRunsAll >> order [
	^ 1
]

{ #category : #printing }
MooseRunnerRunsAll >> printOn: aStream [
	aStream nextPutAll: 'Run All'
]
