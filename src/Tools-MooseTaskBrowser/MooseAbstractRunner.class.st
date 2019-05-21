Class {
	#name : #MooseAbstractRunner,
	#superclass : #Object,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #accessing }
MooseAbstractRunner >> order [
^self subclassResponsibility 
	
]

{ #category : #running }
MooseAbstractRunner >> runJob: aJob withUpdatingBlock: aBlock withErrorLogger: aLogger [
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			self runTask: step input: result.
			step hasRun: true.
			aLogger addText: step printState .
			aBlock value.
			aJob output: step output.
			step output ]
]

{ #category : #running }
MooseAbstractRunner >> runTask: step input: result [
	[ step run: result ]
		on: Error
		do: [ :err |  ]
]
