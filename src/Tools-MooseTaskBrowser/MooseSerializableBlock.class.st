Class {
	#name : #MooseSerializableBlock,
	#superclass : #Object,
	#instVars : [
		'internalBlock'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #'instance creation' }
MooseSerializableBlock class >> fromSton: aStream [
	^ (super fromSton: aStream) block
]

{ #category : #generated }
MooseSerializableBlock >> block [
	^ self class compiler evaluate: internalBlock
]

{ #category : #generated }
MooseSerializableBlock >> block: aBlock [
	internalBlock := aBlock asString 
]
