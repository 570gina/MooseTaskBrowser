"
I'm a job that manages the execution of tasks. I'm a model of MooseTaskBrowser. 
I'm composed of multiple steps, usually  my  steps are instances of MooseCustomTask.

I'm used by 

I use ...

See MooseTaskbrowser >> #example2 for an example.


"
Class {
	#name : #MooseJob,
	#superclass : #Object,
	#instVars : [
		'steps',
		'input'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #action }
MooseJob >> addSteps: aCollection [
	steps addAll: aCollection
]

{ #category : #action }
MooseJob >> combineSteps: aCollection [
	| firstTaskIndex combination |
	firstTaskIndex := steps indexOf: aCollection first.
	aCollection do: [ :i | self removeStep: i ].
	combination := aCollection allButFirst
		inject: aCollection first
		into: [ :acc :each | acc combineWith: each ].
	steps add: combination beforeIndex: firstTaskIndex
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
MooseJob >> runWithUpdatingBlock: aBlock [
	^ [ steps 
		inject: self input
		into: [ :result :step | 
			step run: result.
			aBlock value.
			step output ] ] future
]

{ #category : #action }
MooseJob >> separateStep: aStep [
	| index |
	index := steps indexOf: aStep.
	self removeStep: aStep.
	aStep tasks do: [ :i | steps add: i beforeIndex: index. index := index+1 ]
]

{ #category : #action }
MooseJob >> separateSteps: aCollection [
	aCollection do: [ :i | self separateStep: i ]
]

{ #category : #accessing }
MooseJob >> steps [
	^ steps
]

{ #category : #accessing }
MooseJob >> steps: aCollectionOfTasks [
	steps := aCollectionOfTasks 
]
