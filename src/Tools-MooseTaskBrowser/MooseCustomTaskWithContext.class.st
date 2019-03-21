Class {
	#name : #MooseCustomTaskWithContext,
	#superclass : #MooseCustomTask,
	#instVars : [
		'context'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #accessing }
MooseCustomTaskWithContext >> context [
	^ context
]

{ #category : #accessing }
MooseCustomTaskWithContext >> context: anObject [
	context := anObject
]
