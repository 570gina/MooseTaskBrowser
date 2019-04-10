Class {
	#name : #MooseTaskJobFileTest,
	#superclass : #MooseTaskJobTest,
	#instVars : [
		'file'
	],
	#category : #'Tools-MooseTaskBrowser-newTests'
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
	job steps: steps.
	file saveAs.
	text := file reference readStreamDo: [ :stream | stream upToEnd ].
	loadedJob := (STONReader on: text readStream) next.
	self assert: job steps size equals: loadedJob steps size.
	self
		assert: job steps first description
		equals: loadedJob steps first description.
	"test finished."
	file reference delete
]

{ #category : #tests }
MooseTaskJobFileTest >> testSavingAJob [
	steps add: self returnFifty.
	job steps: steps.
	self assert: file reference exists equals: false.
	file saveAs.
	self assert: file reference exists equals: true.
	"test finished."
	file reference delete
]
