Class {
	#name : #MooseTaskRuntime,
	#superclass : #Object,
	#instVars : [
		'dependancies',
		'task',
		'context',
		'computation'
	],
	#category : #'Tools-MooseTaskBrowser'
}

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
MooseTaskRuntime >> task: aMooseCustomTaskWithContext [
	task := aMooseCustomTaskWithContext.
	computation := task computation.
	task computation: [ :t | computation cull: self cull: t ]
]
