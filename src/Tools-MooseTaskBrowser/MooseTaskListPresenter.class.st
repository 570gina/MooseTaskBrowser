Class {
	#name : #MooseTaskListPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseTaskListPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #list;
		yourself
]

{ #category : #specs }
MooseTaskListPresenter class >> open [
	<script>
	MooseTaskListPresenter  new openWithSpec
]

{ #category : #initialization }
MooseTaskListPresenter >> initializeWidgets [
	list := self newList beMultipleSelection.
	list displayBlock: [ :task | task description ].
	self focusOrder add: list
]

{ #category : #initialization }
MooseTaskListPresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 30 @ 10 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #accessing }
MooseTaskListPresenter >> list [
	^ list
]

{ #category : #api }
MooseTaskListPresenter >> title [ 
	^'Repository'
]
