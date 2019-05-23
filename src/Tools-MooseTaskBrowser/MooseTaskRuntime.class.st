"
I'm a simple task managed by a MooseJob. I'm displayed in a MooseTaskBrowser.
My main API is forceToRun, hasRun, basicRun 


"
Class {
	#name : #MooseTaskRuntime,
	#superclass : #MooseTaskAbstractRuntime,
	#instVars : [
		'task',
		'hasRun'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseTaskRuntime >> basicRun [
	^ task runWith: self
]

{ #category : #accessing }
MooseTaskRuntime >> description [
	^ task description
]

{ #category : #accessing }
MooseTaskRuntime >> hasRun [
	^ hasRun
]

{ #category : #accessing }
MooseTaskRuntime >> hasRun: aBoolean [
	hasRun := aBoolean
]

{ #category : #accessing }
MooseTaskRuntime >> icon [
	^ self hasRun
		ifFalse: [ self iconNamed: #testNotRun ]
		ifTrue: [ error
				ifNil: [ self iconNamed: #testGreen ]
				ifNotNil: [ self iconNamed: #testRed ] ]
]

{ #category : #printing }
MooseTaskRuntime >> printOn: aStream [
	aStream
		nextPutAll:
			'[Task: ' , self description , ']' , String lf , 'input: '
				, input asString , String lf , 'output: ' , output asString
]

{ #category : #printing }
MooseTaskRuntime >> printState [
	^ self isError
		ifTrue: [ '	Fail: [' , self description , '] - ' , error asString ]
		ifFalse: [ '	Succeed: [' , self description , ']' ]
]

{ #category : #accessing }
MooseTaskRuntime >> requiresInput [
	^ task computation numArgs > 0
]

{ #category : #running }
MooseTaskRuntime >> run [
	^ [ error := nil.
	output := self basicRun ]
		on: Error
		do: [ :err | 
			error := err.
			output := nil.
			err signal ]
]

{ #category : #accessing }
MooseTaskRuntime >> task [
	^ task
]

{ #category : #accessing }
MooseTaskRuntime >> task: aMooseCustomTask [
	task := aMooseCustomTask.
	hasRun := false.
	input := nil.
	output := nil
]
