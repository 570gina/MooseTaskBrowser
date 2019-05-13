Class {
	#name : #MooseAbstractRunner,
	#superclass : #Object,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseAbstractRunner >> runJob: aJob withUpdatingBlock: aBlock [
	self subclassResponsibility
]

{ #category : #running }
MooseAbstractRunner >> runTask: step input: result [
	[ step run: result ]
		on: Error
		do: [ :err |  ]
]
