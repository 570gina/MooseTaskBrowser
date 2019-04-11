Class {
	#name : #MooseTaskJobFileTest,
	#superclass : #MooseTaskJobTest,
	#instVars : [
		'file'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #setup }
MooseTaskJobFileTest >> setUp [
	super setUp.
	file := MooseJobFile new.
	file job: job.
		file reference: 'C:\Users\user\Desktop\test.txt' asFileReference.
]

{ #category : #tests }
MooseTaskJobFileTest >> testLoadingAJob [
	| text loadedJob |
	steps add: self returnFifty.
	job tasks: steps.
	file saveAs.
	text := file reference readStreamDo: [ :stream | stream upToEnd ].
	loadedJob := (STONReader on: text readStream) next.
	self assert: job tasks size equals: loadedJob tasks size.
	self
		assert: job tasks first description
		equals: loadedJob tasks first description.
	"test finished."
	file reference delete
]

{ #category : #tests }
MooseTaskJobFileTest >> testSavingAJob [
	steps add: self returnFifty.
	job tasks: steps.
	self assert: file reference exists equals: false.
	file saveAs.
	self assert: file reference exists equals: true.
	"test finished."
	file reference delete
]
