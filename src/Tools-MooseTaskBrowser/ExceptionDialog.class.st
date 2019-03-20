"
self new openDialogWithSpec 
"
Class {
	#name : #ExceptionDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'messageText',
		'okLabel',
		'cancelLabel'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
ExceptionDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #messageText;
		yourself
]

{ #category : #accessing }
ExceptionDialog >> cancelLabel [
	^ cancelLabel
]

{ #category : #accessing }
ExceptionDialog >> cancelLabel: anObject [
	cancelLabel := anObject
]

{ #category : #api }
ExceptionDialog >> extent [
	^ 250 @ 200
]

{ #category : #initialization }
ExceptionDialog >> initializeDialogWindow: aWindow [
	super initializeDialogWindow: aWindow.
	aWindow toolbar okButton label: okLabel.
	aWindow toolbar cancelButton label: cancelLabel
]

{ #category : #initialization }
ExceptionDialog >> initializeWidgets [
	messageText := self newText disable.
]

{ #category : #accessing }
ExceptionDialog >> messageText [
	^ messageText
]

{ #category : #accessing }
ExceptionDialog >> messageText: aString [
	messageText text: aString
]

{ #category : #accessing }
ExceptionDialog >> okLabel [
	^ okLabel
]

{ #category : #accessing }
ExceptionDialog >> okLabel: anObject [
	okLabel := anObject
]

{ #category : #api }
ExceptionDialog >> title [ 
	^'Exception'
]
