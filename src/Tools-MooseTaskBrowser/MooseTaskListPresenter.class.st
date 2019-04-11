Class {
	#name : #MooseTaskListPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listPresenter'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseTaskListPresenter class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #listPresenter;
		yourself
]

{ #category : #api }
MooseTaskListPresenter >> extent [
	^ 250 @ 400
]

{ #category : #initialization }
MooseTaskListPresenter >> initializeWidgets [
	listPresenter := self newList beMultipleSelection.
	self focusOrder
		add: listPresenter.
]

{ #category : #accessing }
MooseTaskListPresenter >> listPresenter [
	^ listPresenter
]

{ #category : #action }
MooseTaskListPresenter >> setList: aCollection [
	aCollection
		ifNotNil: [ listPresenter
				items: aCollection;
				displayBlock: [ :task | task description ] ]
]

{ #category : #api }
MooseTaskListPresenter >> title [ 
	^'Repository'
]
