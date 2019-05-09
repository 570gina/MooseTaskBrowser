Class {
	#name : #MooseJobAbstractRunner,
	#superclass : #Object,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #running }
MooseJobAbstractRunner >> run: aJob withUpdatingBlock: aBlock [
	aJob tasks
		inject: aJob input
		into: [ :result :step | 
			step run: result.
			"aJob errorState: step."
			step hasRun: true.
			aBlock value.
			aJob output: step output.
			step output ]
]
