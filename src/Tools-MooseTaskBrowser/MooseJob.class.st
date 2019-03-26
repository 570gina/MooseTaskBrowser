Class {
	#name : #MooseJob,
	#superclass : #Object,
	#instVars : [
		'steps',
		'input'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #action }
MooseJob >> addSteps: aCollection [
	steps addAll: aCollection
]

{ #category : #action }
MooseJob >> doNotForceAnyStep [
	steps do: [ :v | v forceToRun: false ]
]

{ #category : #action }
MooseJob >> forceRunAllSteps [
	steps do: [ :v | v forceToRun: true ]
]

{ #category : #action }
MooseJob >> getCheckBoxState [
	steps
		do: [ :v | 
			v forceToRun
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #initialization }
MooseJob >> initialize [
	super initialize.
	steps := OrderedCollection new
]

{ #category : #accessing }
MooseJob >> input [
	^ input 
]

{ #category : #accessing }
MooseJob >> input: aValue [
	input := aValue
]

{ #category : #'organizing steps' }
MooseJob >> move: aModifier theStep: aMooseTaskRuntime [
	| index |
	index := steps indexOf: aMooseTaskRuntime.
	steps swap: index with: index + aModifier
]

{ #category : #action }
MooseJob >> removeStep: aMooseTaskRuntime [
	steps remove: aMooseTaskRuntime
]

{ #category : #action }
MooseJob >> run [
	^ self runWithUpdatingBlock: [  ]
]

{ #category : #action }
MooseJob >> runWithUpdatingBlock: aBlock [
	^ steps allButFirst
		inject: (steps first run: self input)
		into: [ :result :step | 
			aBlock value.
			step run: result ]
]

{ #category : #accessing }
MooseJob >> steps [
	^ steps
]

{ #category : #accessing }
MooseJob >> steps: aCollectionOfTasks [
	steps := aCollectionOfTasks 
]
