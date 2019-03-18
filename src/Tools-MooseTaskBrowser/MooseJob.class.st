Class {
	#name : #MooseJob,
	#superclass : #Object,
	#instVars : [
		'steps',
		'context',
		'jobOutput'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #running }
MooseJob >> debuggerErrorHandling: anError [
	anError debug
]

{ #category : #accessing }
MooseJob >> jobInput [
	^ jobInput ifNil: [ #nothing ]
]

{ #category : #running }
MooseJob >> run [
	context := Dictionary new.
	context at: 0 put: self jobInput.
	steps
		doWithIndex: [ :step :index | 
			[ step
				context:
					(context
						at: index - 1
						ifAbsent: [ self error: ' Previous step has to be executed' ]).
			context at: index ifAbsentPut: [ step run ].
			context at: index ]
				on: Error
				do: [ :err | self debuggerErrorHandling: err ] ].
	^ context at: steps size
]

{ #category : #running }
MooseJob >> runOn: aRunner [
	
]

{ #category : #running }
MooseJob >> steps: aCollectionOfTasks [
	steps := aCollectionOfTasks 
]

{ #category : #running }
MooseJob >> uiErrorHandling: anError [
	| view |
	view := ExceptionDialog new.
	view messageText: ('Task: ' , anError description) withCRs.
	view openDialogWithSpec
		cancelAction: [ view window close.
			^ false ].
	view window modalRelativeTo: World
]
