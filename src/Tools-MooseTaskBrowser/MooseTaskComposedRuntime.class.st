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
	^ tasks collect: [ :t | [ t run: input ] future ]
]

{ #category : #running }
MooseTaskComposedRuntime >> combineWith: aMooseTaskRuntime [
	| combination |
	combination := self class new.
	tasks do: [ :t | combination addTaskRuntime: t ].
	aMooseTaskRuntime class = MooseTaskComposedRuntime
		ifTrue: [ aMooseTaskRuntime tasks do: [ :t | combination addTaskRuntime: t ] ]
		ifFalse: [ combination addTaskRuntime: aMooseTaskRuntime ].
	^ combination 
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> description [
	^ ' And ' join: (tasks collect: #description)
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> forceToRun [
	^ tasks allSatisfy: #forceToRun
]

{ #category : #forcing }
MooseTaskComposedRuntime >> forceToRun: aBoolean [
	tasks do: [ :t | t forceToRun: aBoolean ]
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> hasRun [
	^ tasks allSatisfy: #hasRun
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> hasRun: aBoolean [
	tasks do: [ :t | t hasRun: aBoolean ]
]

{ #category : #'adding tasks' }
MooseTaskComposedRuntime >> initialize [
	super initialize.
	tasks := OrderedCollection  new
]

{ #category : #running }
MooseTaskComposedRuntime >> output [
	^ output
]

{ #category : #running }
MooseTaskComposedRuntime >> run [
	| tempOutput |
	^[ error := nil.
	tempOutput := self basicRun.
	output := tempOutput
		collect: [ :f | f synchronizeTimeout: 1 minutes ] ]
		on: Error
		do: [ :err | 
			error := 'Error:' , err messageText.
			err debug.
			output := nil ]
]

{ #category : #accessing }
MooseTaskComposedRuntime >> tasks [
	^ tasks
]
