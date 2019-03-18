Class {
	#name : #MooseTaskRepositoryTest,
	#superclass : #TestCase,
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #tests }
MooseTaskRepositoryTest >> testAddTask [
	"comment stating purpose of message"

	| repo task desc |
	desc :=  'Matrix Calculator'.
	repo := MooseTaskRepository new.

	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 50000000)
				do: [ :i | true ]
				displayingProgress: 'running task: ' , v description.
			true ]
		description: desc
		length: 0.
	repo addTask: task.
	self assert: repo tasks size equals: 1.
	
	self assert: (repo tasks at: 1) description equals: desc.
]

{ #category : #tests }
MooseTaskRepositoryTest >> testInit [
	| repo |
	repo := MooseTaskRepository new.
	"tasks init to nil"

	self assert: repo tasks equals: nil.

]
