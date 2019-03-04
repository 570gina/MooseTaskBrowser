"
self new openWithSpec.
"
Class {
	#name : #MooseTaskRepositoryList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listPresenter',
		'selectButton'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #specs }
MooseTaskRepositoryList class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #listPresenter;
		add:
			#selectButton
			height: self toolbarHeight;
		yourself
]

{ #category : #api }
MooseTaskRepositoryList >> extent [
	^ 250 @ 400
]

{ #category : #initialization }
MooseTaskRepositoryList >> initializeWidgets [
	listPresenter := self newList.
	selectButton := self newButton label: 'Select'.
		self focusOrder
		add: listPresenter;
		add: selectButton
]

{ #category : #accessing }
MooseTaskRepositoryList >> listPresenter [
	^ listPresenter
]

{ #category : #accessing }
MooseTaskRepositoryList >> selectButton [
	^ selectButton
]

{ #category : #api }
MooseTaskRepositoryList >> title [ 
	^'Repository'
]
