"
I am a tool for serializing errors.
But I won't serialize the error contexts.
"
Class {
	#name : #MooseSerializerErrorWithoutContext,
	#superclass : #Object,
	#instVars : [
		'internalError'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #'instance creation' }
MooseSerializerErrorWithoutContext class >> fromSton: aStream [
	^ (super fromSton: aStream) error
]

{ #category : #'instance creation' }
MooseSerializerErrorWithoutContext class >> serialize: anError into: aStonWriter [
	aStonWriter
		writeObject:
			(anError copy
				resetContexts;
				yourself)
]
