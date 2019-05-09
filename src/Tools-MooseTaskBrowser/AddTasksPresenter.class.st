Class {
	#name : #AddTasksPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
AddTasksPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #list;
		yourself
]

{ #category : #'instance creation' }
AddTasksPresenter class >> open [
	<script>
	AddTasksPresenter  new openWithSpec
]

{ #category : #initialization }
AddTasksPresenter >> initializeWidgets [
	list := self newList beMultipleSelection.
	list displayBlock: [ :task | task description ].
	self focusOrder add: list
]

{ #category : #initialization }
AddTasksPresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 30 @ 10 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #accessing }
AddTasksPresenter >> list [
	^ list
]

{ #category : #api }
AddTasksPresenter >> title [ 
	^'Repository'
]
