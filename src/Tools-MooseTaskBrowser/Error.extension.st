Extension { #name : #Error }

{ #category : #'*Tools-MooseTaskBrowser' }
Error >> resetContexts [
	signalContext := nil. 
	handlerContext := nil.
	outerContext := nil.
]

{ #category : #'*Tools-MooseTaskBrowser' }
Error >> stonOn: aStream [
MooseJobFile defaultErrorSerializer serialize: self into: aStream
]
