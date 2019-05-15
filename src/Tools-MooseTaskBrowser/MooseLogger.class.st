Class {
	#name : #MooseLogger,
	#superclass : #Object,
	#instVars : [
		'text',
		'now'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #adding }
MooseLogger >> addText: aString [
	text := text  , aString , String lf
]

{ #category : #accessing }
MooseLogger >> text [
	^text
]

{ #category : #accessing }
MooseLogger >> text: aString [
	text := aString
]
