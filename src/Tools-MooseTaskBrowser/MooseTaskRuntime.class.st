Class {
	#name : #MooseTaskRuntime,
	#superclass : #MooseTaskAbstractRuntime,
	#instVars : [
		'task',
		'hasRun',
		'forceToRun'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #running }
MooseTaskRuntime >> basicRun [
	hasRun := true.
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
MooseTaskRuntime >> icon [
	^ self iconNamed: #play
]

{ #category : #accessing }
MooseTaskRuntime >> printOn: aStream [
	task description printOn: aStream
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
