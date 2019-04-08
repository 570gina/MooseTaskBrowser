Class {
	#name : #MooseTaskRepositoryView,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listPresenter'
	],
	#category : #'Tools-MooseTaskBrowser-core-ui'
}

{ #category : #specs }
MooseTaskRepositoryView class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #listPresenter;
		yourself
]

{ #category : #api }
MooseTaskRepositoryView >> extent [
	^ 250 @ 400
]

{ #category : #initialization }
MooseTaskRepositoryView >> initializeWidgets [
	listPresenter := self newList beMultipleSelection.
	self focusOrder
		add: listPresenter.
]

{ #category : #accessing }
MooseTaskRepositoryView >> listPresenter [
	^ listPresenter
]

{ #category : #action }
MooseTaskRepositoryView >> setList: aCollection [
	aCollection
		ifNotNil: [ listPresenter
				items: aCollection;
				displayBlock: [ :task | task description ] ]
]

{ #category : #api }
MooseTaskRepositoryView >> title [ 
	^'Repository'
]
