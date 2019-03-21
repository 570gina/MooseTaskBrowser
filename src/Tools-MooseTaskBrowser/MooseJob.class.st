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

{ #category : #action }
MooseJob >> removeStep: aMooseTaskRuntime [
	steps remove: aMooseTaskRuntime
]

{ #category : #action }
MooseJob >> run [
	^ steps allButFirst
		inject: (steps first run: self input)
		into: [ :result :step | 
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
