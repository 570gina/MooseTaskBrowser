Class {
	#name : #MooseCustomTaskWithContext,
	#superclass : #MooseCustomTask,
	#instVars : [
		'context',
		'dependancies'
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

{ #category : #accessing }
MooseCustomTaskWithContext >> dependancies [
	^ dependancies
]

{ #category : #dependancies }
MooseCustomTaskWithContext >> initialize [ 
	super initialize.
	dependancies := Set new .
]

{ #category : #dependancies }
MooseCustomTaskWithContext >> requires: aMooseCustomTaskWithContext [
	dependancies add: aMooseCustomTaskWithContext
]
