Extension { #name : #BlockClosure }

{ #category : #'*Tools-MooseTaskBrowser' }
BlockClosure >> stonOn: aStream [
MooseJobFile defaultBlockSerializer serialize: self into: aStream
]
