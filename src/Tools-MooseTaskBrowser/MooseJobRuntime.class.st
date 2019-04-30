Class {
	#name : #MooseJobRuntime,
	#superclass : #Object,
	#instVars : [
		'input',
		'tasks',
		'output',
		'errorState'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #adding }
MooseJobRuntime >> addTasks: aCollectionOfTasks [
	"Add a collection of tasks instances of MooseCustomTask (or object with interfaces understanding asRuntimeTask and force"

	tasks addAll: (aCollectionOfTasks collect: #asTaskRuntime)
]

{ #category : #accessing }
MooseJobRuntime >> description [
	^ '[Job] Input: ' , input asString
]

{ #category : #accessing }
MooseJobRuntime >> errorState [
	^ errorState
]

{ #category : #accessing }
MooseJobRuntime >> errorState: aMooseTask [
	| collection |
	collection := OrderedCollection new.
	(aMooseTask class = MooseTaskComposedRuntime)
		ifFalse: [ collection add: aMooseTask ];
		ifTrue: [ collection := aMooseTask tasks ].
	collection
		do: [ :task | 
			task isError
				ifTrue: [ errorState ifNil: [ errorState := '' ].
					errorState := errorState , '-' , task description , ': '
						, task error asString , String lf ] ]
]

{ #category : #accessing }
MooseJobRuntime >> icon [
	tasks
		do: [ :t | 
			t hasRun
				ifFalse: [ ^ self iconNamed: #testNotRun ]
				ifTrue: [ 
					t isError
						ifTrue: [ ^ self iconNamed: #testRed ] ] ].
	^ self iconNamed: #testGreen
]

{ #category : #initialization }
MooseJobRuntime >> initialize [
	super initialize.
	tasks := OrderedCollection new
]

{ #category : #accessing }
MooseJobRuntime >> input: aString [
	input := aString
]

{ #category : #printing }
MooseJobRuntime >> printOn: aStream [
	aStream
		nextPutAll:
			'[Job]' , String lf , 'Input: ' , input asString , String lf
				, 'Output: ' , output asString
]

{ #category : #action }
MooseJobRuntime >> runWithUpdatingBlock: aBlock [
	^ tasks
		inject: input
		into: [ :result :step | 
			step run: result.
			self errorState: step.
			step hasRun: true.
			aBlock value.
			output := step output ]
]

{ #category : #accessing }
MooseJobRuntime >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseJobRuntime >> tasks: aCollection [
	tasks := aCollection
]
