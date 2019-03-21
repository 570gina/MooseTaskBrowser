Class {
	#name : #MooseTaskRuntime,
	#superclass : #Object,
	#instVars : [
		'dependancies',
		'task',
		'computation',
		'input',
		'output',
		'error'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

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
	^ [ error := nil.
	output := task runWith: self ]
		on: Error
		do: [ :err | 
			error := err.
			err debug.
			output := nil. ]
]

{ #category : #running }
MooseTaskRuntime >> run: anInput [
	^ ((anInput isNil or: [ input = anInput ]) and: [ output isNotNil ])
		ifTrue: [ output ]
		ifFalse: [ input := anInput.
			self run ]
]

{ #category : #accessing }
MooseTaskRuntime >> task [
	^ task
]

{ #category : #accessing }
MooseTaskRuntime >> task: aMooseCustomTask [
	task := aMooseCustomTask
]
