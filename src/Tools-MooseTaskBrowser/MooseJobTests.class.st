Class {
	#name : #MooseJobTests,
	#superclass : #TestCase,
	#instVars : [
		'steps'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #tests }
MooseJobTests >> testJobReducesAnArithmeticOperation [
	steps := OrderedCollection new.
	steps
		add:
			(MooseCustomTask new
				with: [ :i | 1 ]
				description: 'gets a one'
				length: 0).
	steps
		add:
			(MooseCustomTask new
				with: [ :i | i input + 3 ]
				description: 'plus 3'
				length: 0).
	steps := steps
		collect: [ :t | 
			t asTaskRuntime  ].
	self
		assert:
			(MooseJob new
				steps: steps;
				run)
		equals: 4
]
