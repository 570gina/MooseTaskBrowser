"
I am a tool for serializing blocks.
"
Class {
	#name : #MooseSerializerCleanBlock,
	#superclass : #Object,
	#instVars : [
		'internalBlock'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #'instance creation' }
MooseSerializerCleanBlock class >> fromSton: aStream [
	^ (super fromSton: aStream) block
]

{ #category : #'instance creation' }
MooseSerializerCleanBlock class >> serialize: aBlock into: aStream [
	self assert: aBlock isClean.
	(self new block: aBlock) stonOn: aStream
]

{ #category : #generated }
MooseSerializerCleanBlock >> block [
	^ self class compiler evaluate: internalBlock
]

{ #category : #generated }
MooseSerializerCleanBlock >> block: aBlock [
	internalBlock := aBlock asString 
]
