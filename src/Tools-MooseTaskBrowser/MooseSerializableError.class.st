Class {
	#name : #MooseSerializableError,
	#superclass : #Object,
	#instVars : [
		'internalError'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #generated }
MooseSerializableError >> error [ 
	^ self class compiler evaluate: internalError
]

{ #category : #generated }
MooseSerializableError >> error: anError [
	internalError := anError asString
]
