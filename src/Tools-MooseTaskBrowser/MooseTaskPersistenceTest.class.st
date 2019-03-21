Class {
	#name : #MooseTaskPersistenceTest,
	#superclass : #MooseTaskTests,
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #tests }
MooseTaskPersistenceTest >> testStoneSerializationOverSingleBlockTask [
	| stream retrieved |
	task := taskRepo tasks detect: [ :t | t computation isBlock ].
	stream := String new writeStream.
	(STONWriter on: stream) nextPut: task.
	retrieved := (STONReader on: stream contents readStream) next.
	self
		assert: retrieved computation asString
		equals: task computation asString.
	self assert: retrieved computation isBlock
]

{ #category : #tests }
MooseTaskPersistenceTest >> testStoneSerializationOverSingleMessageSendTask [
	| stream retrieved |
	stream := String new writeStream.
	task := taskRepo tasks detect: [ :t | t computation isMessageSend ].
	(STONWriter on: stream) nextPut: task.
	retrieved := (STONReader on: stream contents readStream) next.
	self
		assert: retrieved computation selector
		equals: task computation selector.
	self
		assert: (retrieved computation receiver isKindOf: MooseTaskPersistenceTest).
]

{ #category : #tests }
MooseTaskPersistenceTest >> testStoneSerializationOverSingleMultipleTasks [
	| stream retrievedCollection |
	stream := String new writeStream.
	(STONWriter on: stream) nextPut: taskRepo.
	retrievedCollection := (STONReader on: stream contents readStream)
		next.
	retrievedCollection tasks
		select: [ :i | i computation isMessageSend ]
		thenDo: [ :retrieved | 
			self
				assert: (retrieved computation receiver isKindOf: MooseTaskPersistenceTest) ].
	retrievedCollection tasks
		reject: [ :i | i computation isMessageSend ]
		thenDo: [ :b | self assert: b computation  isBlock ]
]
