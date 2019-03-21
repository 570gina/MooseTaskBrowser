Extension { #name : #BlockClosure }

{ #category : #'*Tools-MooseTaskBrowser' }
BlockClosure >> stonOn: aStream [
	self assert: self isClean.
	(MooseSerializableBlock new block: self) stonOn: aStream
]
