Extension { #name : #MooseCustomTask }

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> asTaskRuntime [
	^ MooseTaskRuntime new
		task: self;
		yourself
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> basicRunWith: aParameter [

	^ computation cull: aParameter
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> combineWith: aMooseTask [
	| combination |
	combination := MooseComposedTask new addTask: self.
	aMooseTask class = MooseComposedTask
		ifTrue: [ 
			aMooseTask tasks do: [ :t | combination addTask: t ] ]
		ifFalse: [ combination
		
				addTask: aMooseTask ].
	^ combination
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> computation [
	^computation
]

{ #category : #'*Tools-MooseTaskBrowser' }
MooseCustomTask >> runWith: aParameter [
	| result |
	[ self setUp.
	result := self basicRunWith: aParameter ]
		ensure: [ self tearDown ].
		self flag: #tearDownMethodIsNil.
	^ result
]
