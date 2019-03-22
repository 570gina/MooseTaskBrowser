Class {
	#name : #MooseTaskRuntime,
	#superclass : #Object,
	#instVars : [
		'dependancies',
		'task',
		'computation',
		'input',
		'output',
		'error',
		'active',
		'hasRun',
		'forceToRun'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #accessing }
MooseTaskRuntime >> active [
	^active
]

{ #category : #accessing }
MooseTaskRuntime >> active: aBoolean [
active := aBoolean
]

{ #category : #accessing }
MooseTaskRuntime >> description [
	^ task description
]

{ #category : #accessing }
MooseTaskRuntime >> forceToRun [
	^ forceToRun
]

{ #category : #accessing }
MooseTaskRuntime >> forceToRun: aValue [
	forceToRun := aValue 
]

{ #category : #accessing }
MooseTaskRuntime >> hasRun [
	^ hasRun
]

{ #category : #accesing }
MooseTaskRuntime >> icon [
	^ self iconNamed: #play
]

{ #category : #running }
MooseTaskRuntime >> input [
	^ input
]

{ #category : #accessing }
MooseTaskRuntime >> isError [
	^ error isNotNil 
]

{ #category : #running }
MooseTaskRuntime >> output [
	^ output
]

{ #category : #accessing }
MooseTaskRuntime >> printOn: aStream [
	task description printOn: aStream.
	aStream
		nextPutAll: ' Last input:# ';
		nextPutAll: input printString.
	self isError
		ifTrue: [ aStream
				nextPutAll: ' Error:# ';
				nextPutAll: error printString ]
		ifFalse: [ aStream
				nextPutAll: ' Last result:# ';
				nextPutAll: output printString ]
]

{ #category : #running }
MooseTaskRuntime >> run [
	hasRun := true.
	^ [ error := nil.
	output := task runWith: self ]
		on: Error
		do: [ :err | 
			error := err.
			err debug.
			output := nil ]
]

{ #category : #running }
MooseTaskRuntime >> run: anInput [
	^ (self shouldRunFor: anInput)
		ifTrue: [ input := anInput.
			self run ]
		ifFalse: [ output ]
]

{ #category : #running }
MooseTaskRuntime >> shouldRunFor: anInput [
	^ forceToRun
		or: [ (hasRun
				and: [ (anInput isNil or: [ input = anInput ]) and: [ output isNotNil ] ])
				not ]
]

{ #category : #accessing }
MooseTaskRuntime >> task [
	^ task
]

{ #category : #accessing }
MooseTaskRuntime >> task: aMooseCustomTask [
	task := aMooseCustomTask.
	hasRun := false.
	forceToRun := false. 
	input := nil.
	output := nil
]
