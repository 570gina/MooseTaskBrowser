"
I'm a composite of MooseTaskRuntime.
"
Class {
	#name : #MooseTaskComposedRuntime,
	#superclass : #MooseTaskAbstractRuntime,
	#instVars : [
		'tasks'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> addTaskRuntime: aMooseTaskRuntime [
	tasks add: aMooseTaskRuntime.
]

{ #category : #running }
MooseTaskComposedRuntime >> basicRun [
	^ tasks collect: [ :t | [ t run: input. t isError ifTrue:[ error := true]. ] future ]
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> description [
	^ 'Group'	" And ' join: (tasks collect: #description)"
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> hasRun [
	^ tasks allSatisfy: #hasRun
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> hasRun: aBoolean [
	tasks do: [ :t | t hasRun: aBoolean ]
]

{ #category : #accessing }
MooseTaskComposedRuntime >> icon [
	tasks
		do: [ :t | 
			t hasRun
				ifFalse: [ ^ self iconNamed: #testNotRun ]
				ifTrue: [ t isError
						ifTrue: [ 
							^ self iconNamed: #testRed ] ] ].
	^ self iconNamed: #testGreen
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> initialize [
	super initialize.
	tasks := OrderedCollection new
]

{ #category : #running }
MooseTaskComposedRuntime >> output [
	^ output
]

{ #category : #printing }
MooseTaskComposedRuntime >> printOn: aStream [
	aStream
		nextPutAll:
			'[Composed Task]' , String lf , 'input: ' , input asString , String lf
				, 'output: ' , output asString
]

{ #category : #running }
MooseTaskComposedRuntime >> run [
	| tempOutput |
	^ [ tempOutput := self basicRun.
	output := tempOutput
		collect: [ :f | f synchronizeTimeout: 2 minutes ] ]
		on: Error
		do: [ :err | error := err ]
]

{ #category : #accessing }
MooseTaskComposedRuntime >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseTaskComposedRuntime >> tasks: aCollection [
	tasks := aCollection
]
