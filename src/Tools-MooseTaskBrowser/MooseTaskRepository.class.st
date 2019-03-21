Class {
	#name : #MooseTaskRepository,
	#superclass : #Object,
	#instVars : [
		'tasks'
	],
	#classInstVars : [
		'tasks'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #action }
MooseTaskRepository >> addTask: aMooseCustomTask [ 
	tasks ifNil: [tasks := OrderedCollection new].
	tasks add: aMooseCustomTask.
]

{ #category : #accessing }
MooseTaskRepository >> tasks [
	^ tasks
]
