Extension { #name : #Error }

{ #category : #'*Tools-MooseTaskBrowser' }
Error >> stonOn: aStream [
	(MooseSerializableError new error: self) stonOn: aStream
]
