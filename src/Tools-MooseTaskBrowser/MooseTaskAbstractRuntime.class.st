"
I'm a wrapper on MooseCustomTask.
I offer a slightly different API so that I can get managed by a MooseJobRuntime and I can be edited by the MooseTaskBrowser.
In particular 
	- I offer input and output to pipe tasks. 

In the future it may be worth to see if my functionalities should not be pushed to MooseCustomTask. 
"
Class {
	#name : #MooseTaskAbstractRuntime,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'error'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseTaskAbstractRuntime >> basicRun [
	self subclassResponsibility
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> description [
	self subclassResponsibility
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> error [
	^ error
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> hasRun [
	^ self subclassResponsibility 
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> hasRun: aBoolean [
	self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> input [
	^ input
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> isError [
	^ self error isNotNil
]

{ #category : #running }
MooseTaskAbstractRuntime >> output [
	^ output
]

{ #category : #printing }
MooseTaskAbstractRuntime >> printState [
		^ self subclassResponsibility
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> requiresInput [
	^ self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> run [
	self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> run: anInput [
	input := anInput.
	^ self run
]

{ #category : #running }
MooseTaskAbstractRuntime >> runWithUpdatingBlock: aBlock [
	self run.
	aBlock value.
	self hasRun: true
]
