"
self new openDialogWithSpec 
"
Class {
	#name : #ExceptionDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'messageText',
		'label'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #specs }
ExceptionDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #messageText;
		add: #label height: self defaultFont height;
		yourself
]

{ #category : #api }
ExceptionDialog >> extent [
	^ 250 @ 200
]

{ #category : #initialization }
ExceptionDialog >> initializeWidgets [
	messageText := self newText disable.
	label := self newLabel label: 'Do you want to continue running?'
]

{ #category : #accessing }
ExceptionDialog >> label [
	^ label
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
