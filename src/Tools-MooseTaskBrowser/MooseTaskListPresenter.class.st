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

{ #category : #specs }
MooseTaskListPresenter class >> open [
	<script>
	MooseTaskListPresenter  new openWithSpec
]

{ #category : #api }
MooseTaskListPresenter >> extent [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	^ 30 @ 10 * (fontWidth @ rowHeight)
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
