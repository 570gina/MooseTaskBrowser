Class {
	#name : #MooseJob,
	#superclass : #Object,
	#instVars : [
		'steps',
		'input'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #adding }
MooseJob >> addSteps: aCollection [
	steps addAll: aCollection
]

{ #category : #running }
MooseJob >> debuggerErrorHandling: anError [
	anError debug
]

{ #category : #running }
MooseJob >> initialize [
	super initialize.
	steps := OrderedCollection new
]

{ #category : #running }
MooseJob >> input [
	^ input 
]

{ #category : #running }
MooseJob >> input: aValue [
	input := aValue
]

{ #category : #adding }
MooseJob >> removeStep: aMooseTaskRuntime [
	steps remove: aMooseTaskRuntime
]

{ #category : #running }
MooseJob >> run [
	^ steps allButFirst
		inject: (steps first run: self input)
		into: [ :result :step | step run: result ]
]

{ #category : #accessing }
MooseJob >> steps [
	^ steps
]

{ #category : #running }
MooseJob >> steps: aCollectionOfTasks [
	steps := aCollectionOfTasks 
]

{ #category : #running }
MooseJob >> uiErrorHandling: anError [
	| view |
	view := ExceptionDialog new.
	view okLabel:'Next'.
	view cancelLabel:'Stop'.
	view messageText: ('Task: ' , anError description) withCRs.
	view openDialogWithSpec
		cancelAction: [ view window close.
			^ false ].
	view window modalRelativeTo: World
]
