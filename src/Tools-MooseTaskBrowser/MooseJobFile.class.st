"
I am a file manager that can save jobs and load jobs.
I use STON to read and write files.
"
Class {
	#name : #MooseJobFile,
	#superclass : #Object,
	#instVars : [
		'reference',
		'job',
		'fileName'
	],
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #serializing }
MooseJobFile class >> defaultBlockSerializer [
	^ MooseSerializerCleanBlock
]

{ #category : #serializing }
MooseJobFile class >> defaultErrorSerializer [
	^ MooseSerializerErrorWithoutContext
]

{ #category : #accessing }
MooseJobFile >> fileName [
	^ fileName
]

{ #category : #accessing }
MooseJobFile >> job [
	^ job
]

{ #category : #accessing }
MooseJobFile >> job: aMooseJob [
	job := aMooseJob
]

{ #category : #loading }
MooseJobFile >> load [
	| text |
	reference
		ifNil: [ reference := UIManager default
				chooseExistingFileReference: 'Select a Job'
				extensions: #('txt')
				path: FileLocator image parent.
			reference ifNil: [ ^ false ].
			reference extension = 'txt'
				ifFalse: [ ^ false ] ].
	reference extension = 'txt'
		ifFalse: [ ^ false ].
	fileName := reference base.
	text := reference readStreamDo: [ :stream | stream upToEnd ].
	job := (STONReader on: text readStream) next.
	^ true
]

{ #category : #accessing }
MooseJobFile >> reference [
	^ reference
]

{ #category : #accessing }
MooseJobFile >> reference: aFileReference [
	^ reference := aFileReference
]

{ #category : #saving }
MooseJobFile >> saveAs [
	reference
		ifNil: [ reference := UIManager default
				chooseForSaveFileReference: 'Save Job as?'
				extensions: #('txt')
				path: 'aMooseJob' asFileReference ]
		ifNotNil: [ reference exists
				ifTrue: [reference delete] ].
	reference ifNil: [ ^ false ].
	fileName := reference base.
	reference
		writeStreamDo: [ :stream | stream nextPutAll: (STON toStringPretty: job) ].
	^ true
]
