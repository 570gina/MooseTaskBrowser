Class {
	#name : #BaselineOfMooseTaskBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfMooseTaskBrowser
}

{ #category : #baseline }
BaselineOfMooseTaskBrowser >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Packages"
			spec package: 'Tools-MooseTaskBrowser' 
			 ]
]

{ #category : #accessing }
BaselineOfMooseTaskBrowser >> projectClass [
	 ^  MetacelloCypressBaselineProject
]
