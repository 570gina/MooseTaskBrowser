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
MooseJob >> combineSteps: aCollection setIndex: index [
	aCollection do: [ :i | self removeStep: i ].
	steps 
add: aCollection beforeIndex: index

]

{ #category : #action }
MooseJob >> doNotForceAnyStep [
	steps
		do: [ :v | 
			v isArray
				ifTrue: [ v do: [ :i | i forceToRun: false ] ]
				ifFalse: [ v forceToRun: false ] ]
]

{ #category : #action }
MooseJob >> forceRunAllSteps [
	steps
		do: [ :v | 
			v isArray
				ifTrue: [ v do: [ :i | i forceToRun: true ] ]
				ifFalse: [ v forceToRun: true ] ]
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
MooseJob >> move: aModifier theStep: aStep [
	| index |
	index := steps indexOf: aStep.
	steps swap: index with: index + aModifier
]

{ #category : #action }
MooseJob >> removeStep: aStep [
	steps remove: aStep
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
