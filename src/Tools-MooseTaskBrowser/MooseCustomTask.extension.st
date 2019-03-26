Extension { #name : #MooseCustomTask }

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> asTaskRuntime [
	^ MooseTaskRuntime new
		task: self;
		forceToRun: true;
		yourself
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> basicRunWith: aParameter [

	^ computation value: aParameter
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> runWith: aParameter [
	| result |
	[ self setUp.
	result := self basicRunWith: aParameter ]
		ensure: [ self tearDown ].
	^ result
]
