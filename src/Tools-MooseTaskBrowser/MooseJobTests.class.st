Class {
	#name : #MooseJobTests,
	#superclass : #TestCase,
	#instVars : [
		'steps'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #tests }
MooseJobTests >> testJobReducesAnAritmeticOperation [
	steps := OrderedCollection new.
	steps
		add: (MooseCustomTask new with: [ 1 ] description: 'gets a one' length: 0).
	steps
		add:
			(MooseCustomTask new
				with: [ :i | i input + 3 ]
				description: 'plus 3'
				length: 0).
	steps := steps
		collect: [ :t | 
			MooseTaskRuntime new
				task: t;
				yourself ].
	self
		assert:
			(MooseJob new
				steps: steps;
				run)
		equals: 4
]
