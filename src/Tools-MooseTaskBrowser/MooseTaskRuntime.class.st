"
I'm a simple task managed by a MooseJob. I'm displayed in a MooseTaskBrowser.
My main API is forceToRun, hasRun, basicRun 


"
Class {
	#name : #MooseTaskRuntime,
	#superclass : #MooseTaskAbstractRuntime,
	#instVars : [
		'task',
		'hasRun',
		'forceToRun'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseTaskRuntime >> basicRun [
	^ task runWith: self
]

{ #category : #running }
MooseTaskRuntime >> combineWith: aMooseTaskRuntime [
	| combination |
	combination := MooseTaskComposedRuntime new.
	aMooseTaskRuntime class = MooseTaskComposedRuntime
		ifTrue: [ combination addTaskRuntime: self.
			aMooseTaskRuntime tasks do: [ :t | combination addTaskRuntime: t ] ]
		ifFalse: [ combination
				addTaskRuntime: self;
				addTaskRuntime: aMooseTaskRuntime ].
	^ combination 
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

{ #category : #accessing }
MooseTaskRuntime >> hasRun: aBoolean [
	hasRun := aBoolean
]

{ #category : #accessing }
MooseTaskRuntime >> icon [
	^ self iconNamed: #play
]

{ #category : #accessing }
MooseTaskRuntime >> printOn: aStream [
	task description printOn: aStream
]

{ #category : #running }
MooseTaskRuntime >> run [
	^ [ error := nil.
	output := self basicRun ]
		on: Error
		do: [ :err | 
			error := err asString.
			err debug.
			output := nil ]
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

{ #category : #accessing }
MooseTaskRuntime >> tasks [
	^ {self}
]
