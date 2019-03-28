Class {
	#name : #MooseTaskPersistenceTest,
	#superclass : #MooseTaskTests,
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #preparation }
MooseTaskPersistenceTest >> setUp [
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: self createBlockHandle
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: (MessageSend receiver: self selector: #body:)
		description: 'a description 4'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 5'.
			v input + 2 ]
		description: 'a description 5'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 6'.
			v input + 2 ]
		description: 'a description 6'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 7'.
			v input + 2 ]
		description: 'a description 7'
		length: 0.	
	taskRepo addTask: task.
]

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
