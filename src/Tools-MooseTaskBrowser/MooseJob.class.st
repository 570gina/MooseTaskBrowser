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

{ #category : #action }
MooseJob >> updateAtive: items [
	items
		ifNotNil: [ steps
				do: [ :i | 
					(items includes: i)
						ifTrue: [ i active: true ]
						ifFalse: [ i active: false ] ] ]
]
