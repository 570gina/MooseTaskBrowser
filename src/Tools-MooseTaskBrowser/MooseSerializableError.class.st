Class {
	#name : #MooseSerializableError,
	#superclass : #Object,
	#instVars : [
		'internalError'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #'instance creation' }
MooseSerializableError class >> fromSton: aStream [
	^ (super fromSton: aStream) error
]

{ #category : #generated }
MooseSerializableError >> error [
	^ self class compiler evaluate: internalError
]

{ #category : #generated }
MooseSerializableError >> error: anError [
	internalError := anError asString
]
