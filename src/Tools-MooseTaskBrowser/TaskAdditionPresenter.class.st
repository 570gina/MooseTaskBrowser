Class {
	#name : #TaskAdditionPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
TaskAdditionPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #list;
		yourself
]

{ #category : #'instance creation' }
TaskAdditionPresenter class >> open [
	<script>
	TaskAdditionPresenter  new openWithSpec
]

{ #category : #initialization }
TaskAdditionPresenter >> initializeWidgets [
	list := self newList beMultipleSelection.
	list displayBlock: [ :task | task description ].
	self focusOrder add: list
]

{ #category : #initialization }
TaskAdditionPresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 30 @ 10 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #accessing }
TaskAdditionPresenter >> list [
	^ list
]

{ #category : #api }
TaskAdditionPresenter >> title [ 
	^'Repository'
]
