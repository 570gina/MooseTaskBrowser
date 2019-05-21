Class {
	#name : #MooseJobRuntime,
	#superclass : #Object,
	#instVars : [
		'input',
		'tasks',
		'output',
		'errorState',
		'runner',
		'logger'
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
						, task error asString , String lf. ] ]
]

{ #category : #accessing }
MooseJobRuntime >> icon [
	(tasks allSatisfy: #hasRun)
		ifTrue: [ (tasks anySatisfy: #isError)
				ifTrue: [ ^ self iconNamed: #testRed ]
				ifFalse: [ ^ self iconNamed: #testGreen ] ]
		ifFalse: [ ^ self iconNamed: #testNotRun ]
	
		
]

{ #category : #initialization }
MooseJobRuntime >> initialize [
	super initialize.
	tasks := OrderedCollection new
]

{ #category : #accessing }
MooseJobRuntime >> input [
	^ input
]

{ #category : #accessing }
MooseJobRuntime >> input: aString [
	input := aString
]

{ #category : #accessing }
MooseJobRuntime >> logger: aLogger [
logger:=aLogger
]

{ #category : #accessing }
MooseJobRuntime >> output [
	^output
]

{ #category : #accessing }
MooseJobRuntime >> output: theOutputOfLastTask [
	output := theOutputOfLastTask
]

{ #category : #printing }
MooseJobRuntime >> printOn: aStream [
	aStream
		nextPutAll:
			'[Job]' , String lf , 'Input: ' , input asString , String lf
				, 'Output: ' , output asString
]

{ #category : #running }
MooseJobRuntime >> runWithUpdatingBlock: aBlock [
	logger addText: 'Begin: ' , self description.
	aBlock value.
	runner runJob: self withUpdatingBlock: aBlock withErrorLogger: logger.
	logger addText: 'End: ' , self description
]

{ #category : #accessing }
MooseJobRuntime >> runner: aRunner [
 runner := aRunner
]

{ #category : #accessing }
MooseJobRuntime >> tasks [
	^ tasks
]

{ #category : #accessing }
MooseJobRuntime >> tasks: aCollection [
	tasks := aCollection
]
