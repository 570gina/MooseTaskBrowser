Class {
	#name : #MooseComposedTask,
	#superclass : #Object,
	#instVars : [
		'tasks'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #adding }
MooseComposedTask >> addTask: aMooseTask [
	tasks add: aMooseTask
]

{ #category : #action }
MooseComposedTask >> asTaskRuntime [
	^ MooseTaskComposedRuntime new
		tasks: (tasks collect: [ :t | t asTaskRuntime ]);
		yourself
]

{ #category : #action }
MooseComposedTask >> combineWith: aMooseTask [
	| combination |
	combination := self class new.
	tasks do: [ :t | combination addTask: t ].
	aMooseTask class = MooseComposedTask
		ifTrue: [ aMooseTask tasks do: [ :t | combination addTask: t ] ]
		ifFalse: [ combination addTask: aMooseTask ].
	^ combination
]

{ #category : #accessing }
MooseComposedTask >> description [
	^ 'Group'
]

{ #category : #initialization }
MooseComposedTask >> initialize [
	super initialize.
	tasks := OrderedCollection new.
]

{ #category : #accessing }
MooseComposedTask >> tasks [
	^ tasks
]
