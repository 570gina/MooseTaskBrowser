"
self new openDialogWithSpec 
"
Class {
	#name : #ExceptionDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'messageText'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
ExceptionDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #messageText;
		yourself
]

{ #category : #api }
ExceptionDialog >> extent [
	^ 250 @ 200
]

{ #category : #initialization }
ExceptionDialog >> initializeDialogWindow: aWindow [
	super initializeDialogWindow: aWindow.
	aWindow toolbar okButton label: 'Next'.
	aWindow toolbar cancelButton label: 'Stop'
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

{ #category : #api }
ExceptionDialog >> title [ 
	^'Exception'
]
