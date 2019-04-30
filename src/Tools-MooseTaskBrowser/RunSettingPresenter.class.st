Class {
	#name : #RunSettingPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'inputText'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
RunSettingPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: 'Provide the input for first task: '
			withConstraints: [ :constraints | constraints height: self defaultFont height + 6 ];
		add: #inputText;
		add: 'The number of inputs determines the number of job executions.'
			withConstraints: [ :constraints | constraints height: self defaultFont height ];
		add: 'Please separate the different inputs with spaces.'
			withConstraints: [ :constraints | constraints height: self defaultFont height ];
		add: '(ex. input1 input2 input3 ...)'
			withConstraints: [ :constraints | constraints height: self defaultFont height + 6 ];
		yourself
]

{ #category : #'instance creation' }
RunSettingPresenter class >> open [
	<script>
	self new openWithSpec
]

{ #category : #initialization }
RunSettingPresenter >> initializeWidgets [
	inputText := self newText.
	inputText autoAccept: true.
	self focusOrder add: inputText
]

{ #category : #initialization }
RunSettingPresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 35 @ 8 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #initialization }
RunSettingPresenter >> inputText [
	^ inputText
]

{ #category : #initialization }
RunSettingPresenter >> inputText: aString [
	inputText text: aString
]

{ #category : #initialization }
RunSettingPresenter >> title [
	^ 'Setting'
]
