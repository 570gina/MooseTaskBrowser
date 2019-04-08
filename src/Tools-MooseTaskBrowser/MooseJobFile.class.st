Class {
	#name : #MooseJobFile,
	#superclass : #Object,
	#instVars : [
		'reference',
		'job',
		'fileName'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #accessing }
MooseJobFile >> fileName [
	^ fileName
]

{ #category : #accessing }
MooseJobFile >> fileName: anObject [
	fileName := anObject
]

{ #category : #accessing }
MooseJobFile >> job [
	^ job
]

{ #category : #accessing }
MooseJobFile >> job: anObject [
	job := anObject
]

{ #category : #loading }
MooseJobFile >> load [
	| text |
	reference := UIManager default
		chooseExistingFileReference: 'Select a Job'
		extensions: #('txt')
		path: FileLocator home.
	reference ifNil: [ ^ false ].
	reference extension = 'txt'
		ifFalse: [ ^ false ].
	fileName := reference base.
	text := reference readStreamDo: [ :stream | stream upToEnd ].
	job := (STONReader on: text readStream) next.
	^ true
]

{ #category : #saving }
MooseJobFile >> saveAs [
	reference
		ifNil: [ reference := UIManager default
				chooseForSaveFileReference: 'Save Job as?'
				extensions: #('txt')
				path: 'aMooseJob' asFileReference ]
		ifNotNil: [ reference delete ].
	reference
		ifNil: [ ^ false].
		fileName := reference base.
			reference
				writeStreamDo: [ :stream | stream nextPutAll: (STON toStringPretty: job) ].
			^ true

]
