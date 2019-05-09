Class {
	#name : #MooseJobRunnerRunAll,
	#superclass : #MooseJobAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #printing }
MooseJobRunnerRunAll >> printOn: aStream [
	aStream nextPutAll: 'Run All'
]
