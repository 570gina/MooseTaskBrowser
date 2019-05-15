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
	^ tasks
		collect: [ :t | 
			.
			[ t run: input ] future ]
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> description [
	^ 'Group'	" And ' join: (tasks collect: #description)"
]

{ #category : #accessing }
MooseTaskComposedRuntime >> error [
	^ tasks anySatisfy: [ :t | t isError ]
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

	(tasks allSatisfy: #hasRun)
		ifTrue: [ (tasks anySatisfy: #isError)
				ifTrue: [ ^ self iconNamed: #testRed ]
				ifFalse: [ ^ self iconNamed: #testGreen ] ]
		ifFalse: [ ^ self iconNamed: #testNotRun ]
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> initialize [
	super initialize.
	tasks := OrderedCollection new
]

{ #category : #accessing }
MooseTaskComposedRuntime >> isError [
	^ self error
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

{ #category : #printing }
MooseTaskComposedRuntime >> printState [
	^tasks allButFirst
		inject: tasks first printState
		into: [ :string :t | string , String lf , t printState string ]
]

{ #category : #accessing }
MooseTaskComposedRuntime >> requiresInput [
	^ tasks anySatisfy: [ :t | t requiresInput ]
]

{ #category : #running }
MooseTaskComposedRuntime >> run [
	| tempOutput |
	tempOutput := self basicRun.
	output := tempOutput
		collect: [ :f | f synchronizeTimeout: 2 minutes ].
	^ output
]

{ #category : #accessing }
MooseTaskComposedRuntime >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseTaskComposedRuntime >> tasks: aCollection [
	tasks := aCollection
]
