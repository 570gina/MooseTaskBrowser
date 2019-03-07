Class {
	#name : #MooseCustomTaskWithContext,
	#superclass : #MooseCustomTask,
	#instVars : [
		'context'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #accessing }
MooseCustomTaskWithContext >> context [
	^ context
]

{ #category : #accessing }
MooseCustomTaskWithContext >> context: anObject [
	context := anObject
]
