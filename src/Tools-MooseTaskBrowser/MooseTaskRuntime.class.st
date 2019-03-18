Class {
	#name : #MooseTaskRuntime,
	#superclass : #Object,
	#instVars : [
		'dependancies',
		'task',
		'context',
		'computation'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #accessing }
MooseTaskRuntime >> context [
	^ context
]

{ #category : #accessing }
MooseTaskRuntime >> context: aCollection [
	context := aCollection
]

{ #category : #running }
MooseTaskRuntime >> run [
	^ task run
]

{ #category : #accessing }
MooseTaskRuntime >> task [
	^ task
]

{ #category : #accessing }
MooseTaskRuntime >> task: aMooseCustomTask [
	task := aMooseCustomTask.
	computation := task computation.
	task computation: [ :t | computation cull: self cull: t ]
]
