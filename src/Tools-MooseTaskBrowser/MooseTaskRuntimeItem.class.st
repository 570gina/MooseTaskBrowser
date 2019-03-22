Class {
	#name : #MooseTaskRuntimeItem,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'description',
		'input',
		'output',
		'checkbox',
		'test'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
MooseTaskRuntimeItem class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #checkbox width: 3;
				add: #test ]
			height: 40;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #input;
						add: #description;
						add: #output ] ]
			height: 100;
		yourself
]

{ #category : #specs }
MooseTaskRuntimeItem class >> example [
	<example>
	| task |
	task := MooseCustomTask new
		with: [ :v | 
			| loc |
			loc := UIManager default
				request: 'Please insert the url to clone, with argument: '
				initialAnswer: 'https://github.com/fuhrmanator/FactoryVariants' ]
		description: '0 prompt url'
		length: 0.
	(self owner: nil on: task asTaskRuntime )
		openWithSpec
]

{ #category : #accessing }
MooseTaskRuntimeItem >> checkbox [
	^ checkbox
]

{ #category : #accessing }
MooseTaskRuntimeItem >> checkbox: anObject [
	checkbox := anObject
]

{ #category : #accessing }
MooseTaskRuntimeItem >> description [
	^ description
]

{ #category : #accessing }
MooseTaskRuntimeItem >> description: anObject [
	description := anObject
]

{ #category : #initialization }
MooseTaskRuntimeItem >> initializeWidgets [
	input := self newLabel.
	description := self newLabel.
	output := self newLabel.
	checkbox := self newCheckBox.
	test := self newImage.
	checkbox whenChangedDo: [ :val | self model forceToRun: val not ].
	checkbox labelOnLeft
]

{ #category : #accessing }
MooseTaskRuntimeItem >> input [
	^ input
]

{ #category : #accessing }
MooseTaskRuntimeItem >> input: anObject [
	input := anObject
]

{ #category : #initialization }
MooseTaskRuntimeItem >> modelChanged [
	self model isError
		ifTrue:
			[ self widget ifNotNil: [ self widget backgroundColor: Color red ] ].
	self model
		ifNotNil: [ input label: (self model input ifNil: [ 'missing' ]) asString.
			description label: self model description.
			output label: self model output asString.
			self model hasRun
				ifTrue: [ self model isError
						ifTrue: [ checkbox state: true.
							test image: (self iconNamed: #testRed) ]
						ifFalse: [ checkbox state: self model forceToRun.
							test image: (self iconNamed: #testGreen) ] ]
				ifFalse: [ checkbox state: true.
					test image: (self iconNamed: #testNotRun) ] ]
]

{ #category : #accessing }
MooseTaskRuntimeItem >> output [
	^ output
]

{ #category : #accessing }
MooseTaskRuntimeItem >> output: anObject [
	output := anObject
]

{ #category : #accessing }
MooseTaskRuntimeItem >> test [
	^ test
]
