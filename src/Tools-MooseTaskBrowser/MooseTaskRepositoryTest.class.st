Class {
	#name : #MooseTaskRepositoryTest,
	#superclass : #TestCase,
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #tests }
MooseTaskRepositoryTest >> testAddTask [
	"comment stating purpose of message"

	| repo task |
	repo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | true ]
		description: 'Test task 1'
		length: 0.
	repo addTask: task.
	task := MooseCustomTask new
		with: [ :v | true ]
		description: 'Test task 2'
		length: 0.
	repo addTask: task.
	self assert: repo tasks size equals: 2.
	self assert: (repo tasks at: 1) description equals: 'Test task 1'.
	self assert: (repo tasks includes:task).
]

{ #category : #tests }
MooseTaskRepositoryTest >> testInit [
	| repo |
	repo := MooseTaskRepository new.
	"tasks init to nil"

	self assert: repo tasks equals: nil.

]
