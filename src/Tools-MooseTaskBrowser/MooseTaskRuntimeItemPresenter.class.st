Class {
	#name : #MooseTaskRuntimeItemPresenter,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'description',
		'input',
		'output',
		'checkbox',
		'test'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseTaskRuntimeItemPresenter class >> defaultSpec [
	| h |
	h := self defaultFont height +2.
	^ SpecBoxLayout newVertical
		add:
			(SpecBoxLayout newHorizontal
				add:
					(SpecBoxLayout newVertical
						add: #checkbox
							withConstraints: [ :constraints | constraints height: h ];
						add: #test
							withConstraints: [ :constraints | constraints height: h ])
					withConstraints: [ :constraints | constraints width: h ];
				add:
					(SpecBoxLayout newVertical
						add: #input
							withConstraints: [ :constraints | constraints height: h ];
						add: #description
							withConstraints: [ :constraints | constraints height: h ];
						add: #output
							withConstraints: [ :constraints | constraints height: h ]))
			withConstraints: [ :constraints | constraints height: 3 * h ];
		yourself
]

{ #category : #specs }
MooseTaskRuntimeItemPresenter class >> example [
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
MooseTaskRuntimeItemPresenter >> checkbox [
	^ checkbox
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> checkbox: aBoolean [
	checkbox := aBoolean
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> description [
	^ description
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> description: anObject [
	description := anObject
]

{ #category : #initialization }
MooseTaskRuntimeItemPresenter >> initializePresenter [
	checkbox whenActivatedDo: [ self model forceToRun: true ].
	checkbox whenDeactivatedDo: [ self model forceToRun: false ]

	
]

{ #category : #initialization }
MooseTaskRuntimeItemPresenter >> initializeWidgets [
	input := self newLabel.
	description := self newLabel.
	output := self newLabel.
	checkbox := self newCheckBox.
	test := self newImage.
	self focusOrder
		add: test;
		add: input;
		add: description;
		add: output
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> input [
	^ input
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> input: anObject [
	input := anObject
]

{ #category : #initialization }
MooseTaskRuntimeItemPresenter >> modelChanged [
	self model
		ifNotNil: [ input label: 'Input: ' , self model input asString.
			description label: 'Task: ' , self model description.
			output label: 'Output: ' , self model output asString.
			self model hasRun
				ifTrue: [ self model isError
						ifTrue: [ test image: (self iconNamed: #testRed).
							checkbox state: true.
							checkbox disable ]
						ifFalse: [ test image: (self iconNamed: #testGreen).
							checkbox enable.
							checkbox state: self model forceToRun ] ]
				ifFalse: [ test image: (self iconNamed: #testNotRun).
					checkbox state: true.
					checkbox disable ] ]
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> output [
	^ output
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> output: anObject [
	output := anObject
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> test [
	^ test
]

{ #category : #accessing }
MooseTaskRuntimeItemPresenter >> test: anObject [
	test := anObject
]
