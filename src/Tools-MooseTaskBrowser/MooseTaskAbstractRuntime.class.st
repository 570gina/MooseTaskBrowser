Class {
	#name : #MooseTaskAbstractRuntime,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'error'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #running }
MooseTaskAbstractRuntime >> basicRun [
	self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> combineWith: anOtherTask [
	self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> description [
	self subclassResponsibility
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> forceToRun [
	self subclassResponsibility
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> hasRun [
	^ self subclassResponsibility 
]

{ #category : #running }
MooseTaskAbstractRuntime >> initialize [
	super initialize.
	input := nil.
	output := nil
]

{ #category : #running }
MooseTaskAbstractRuntime >> input [
	^ input
]

{ #category : #accessing }
MooseTaskAbstractRuntime >> isError [
	^ error isNotNil 
]

{ #category : #running }
MooseTaskAbstractRuntime >> output [
	^ output
]

{ #category : #running }
MooseTaskAbstractRuntime >> run [
	self subclassResponsibility
]

{ #category : #running }
MooseTaskAbstractRuntime >> run: anInput [

	^ (self shouldRunFor: anInput)
		ifTrue: [ input := anInput.
			self run ]
		ifFalse: [ output ]
]

{ #category : #running }
MooseTaskAbstractRuntime >> shouldRunFor: anInput [
	^ (self forceToRun or: [self isKindOf: MooseTaskComposedRuntime])
		or: [ (self hasRun
				and: [ (anInput isNil or: [ input = anInput ]) and: [ output isNotNil ] ])
				not ]
]
